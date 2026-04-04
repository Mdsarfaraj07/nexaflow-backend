package com.nexaflow.service;

import com.nexaflow.dto.request.BookingRequest;
import com.nexaflow.entity.*;
import com.nexaflow.enums.*;
import com.nexaflow.repository.*;
import com.nexaflow.util.CurrencyUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final ServiceRepository serviceRepository;
    private final UserRepository userRepository;
    private final ProjectRepository projectRepository;
    private final InvoiceRepository invoiceRepository;
    private final MilestoneRepository milestoneRepository;
    private final CouponRepository couponRepository;
    private final EmailService emailService;
    private final CurrencyUtil currencyUtil;

    @Transactional
    public Map<String, Object> createBooking(BookingRequest request, String userEmail) {
        // Get or create client
        User client = userRepository.findByEmail(request.getClientEmail())
                .orElseGet(() -> {
                    User newClient = User.builder()
                            .name(request.getClientName())
                            .email(request.getClientEmail())
                            .phone(request.getClientPhone())
                            .company(request.getClientCompany())
                            .password("") // Will be set if they register
                            .role(UserRole.CLIENT)
                            .preferredCurrency(request.getCurrency() != null ? request.getCurrency() : "INR")
                            .isActive(true)
                            .build();
                    return userRepository.save(newClient);
                });

        // Get service
        com.nexaflow.entity.Service service = serviceRepository.findById(request.getServiceId())
                .orElseThrow(() -> new RuntimeException("Service not found"));

        Double servicePriceINR = service.getPriceINR();
        Double discountINR = 0.0;

        // Apply coupon if provided
        if (request.getCouponCode() != null && !request.getCouponCode().isEmpty()) {
            Coupon coupon = couponRepository.findByCodeAndIsActiveTrue(request.getCouponCode().toUpperCase())
                    .orElse(null);
            
            if (coupon != null && coupon.isValid()) {
                if (coupon.getType() == CouponType.PERCENT) {
                    discountINR = (double) Math.round(servicePriceINR * coupon.getDiscount() / 100.0);
                } else {
                    discountINR = currencyUtil.usdToInr(coupon.getDiscount());
                }
                coupon.incrementUsage();
                couponRepository.save(coupon);
            }
        }

        servicePriceINR = servicePriceINR - discountINR;
        Double gst = (double) Math.round(servicePriceINR * 0.18);
        Double total = servicePriceINR + gst;

        // Calculate amount paid based on payment type
        Double amountPaid = 0.0;
        PaymentType paymentType = PaymentType.CONSULTATION;
        
        if (request.getPaymentType() != null) {
            paymentType = PaymentType.valueOf(request.getPaymentType().toUpperCase());
            switch (paymentType) {
                case FULL:
                    amountPaid = total;
                    break;
                case PARTIAL:
                    amountPaid = (double) Math.round(total * 0.5);
                    break;
                case CONSULTATION:
                    amountPaid = 0.0;
                    break;
            }
        }

        if (request.getAmountPaid() != null) {
            amountPaid = request.getAmountPaid();
        }

        // Create booking
        Booking booking = Booking.builder()
                .client(client)
                .service(service)
                .clientName(request.getClientName())
                .clientEmail(request.getClientEmail())
                .clientPhone(request.getClientPhone())
                .clientCompany(request.getClientCompany())
                .serviceName(service.getName())
                .servicePrice(servicePriceINR)
                .paymentType(paymentType)
                .paymentId(request.getPaymentId())
                .amountPaid(amountPaid)
                .total(total)
                .currency(request.getCurrency() != null ? request.getCurrency() : "INR")
                .amountUSD(currencyUtil.inrToUsd(total))
                .discountINR(discountINR)
                .couponCode(request.getCouponCode())
                .status(BookingStatus.CONFIRMED)
                .projectBrief(request.getProjectBrief())
                .build();

        booking = bookingRepository.save(booking);

        // Create project
        Project project = Project.builder()
                .client(client)
                .booking(booking)
                .title(service.getName())
                .service(service.getName())
                .status(ProjectStatus.PLANNING)
                .progress(0)
                .phase("Discovery & Planning")
                .startDate(LocalDate.now())
                .budget(servicePriceINR)
                .paid(amountPaid)
                .build();

        project = projectRepository.save(project);

        // Create default milestones
        String[] milestoneNames = {
                "Discovery & Requirements",
                "Design & Prototype",
                "Development",
                "Testing & QA",
                "Delivery"
        };

        LocalDate milestoneBaseDate = LocalDate.now().plusDays(7);
        for (int i = 0; i < milestoneNames.length; i++) {
            LocalDate dueDate = milestoneBaseDate.plusDays(i * 14L);
            Milestone milestone = Milestone.builder()
                    .project(project)
                    .client(client)
                    .title(milestoneNames[i])
                    .status(MilestoneStatus.PENDING)
                    .dueDate(dueDate)
                    .build();
            milestoneRepository.save(milestone);
        }

        // Create invoice
        String invoiceNum = generateInvoiceNumber();
        Invoice invoice = Invoice.builder()
                .client(client)
                .booking(booking)
                .invoiceNum(invoiceNum)
                .items(String.format("[{\"name\":\"%s\",\"qty\":1,\"rate\":%.2f,\"amount\":%.2f}]",
                        service.getName(), servicePriceINR, servicePriceINR))
                .subtotal(servicePriceINR)
                .gst(gst)
                .total(total)
                .amountPaid(amountPaid)
                .amountDue(total - amountPaid)
                .currency(request.getCurrency() != null ? request.getCurrency() : "INR")
                .amountUSD(currencyUtil.inrToUsd(total))
                .discountINR(discountINR)
                .couponCode(request.getCouponCode())
                .status(amountPaid >= total ? InvoiceStatus.PAID : 
                       amountPaid > 0 ? InvoiceStatus.PARTIAL : InvoiceStatus.PENDING)
                .paidDate(amountPaid > 0 ? LocalDateTime.now() : null)
                .build();

        invoice = invoiceRepository.save(invoice);

        // Update client's total invested
        client.setTotalInvested((client.getTotalInvested() != null ? client.getTotalInvested() : 0.0) + amountPaid);
        userRepository.save(client);

        // Send booking confirmation email
        Map<String, Object> emailData = new HashMap<>();
        emailData.put("clientName", booking.getClientName());
        emailData.put("serviceName", service.getName());
        emailData.put("bookingId", booking.getId());
        emailData.put("invoiceNum", invoice.getInvoiceNum());
        emailData.put("amount", amountPaid);

        emailService.sendBookingConfirmation(client.getEmail(), emailData);

        // Prepare response
        Map<String, Object> response = new HashMap<>();
        response.put("booking", booking);
        response.put("project", project);
        response.put("invoice", invoice);
        response.put("refId", booking.getId().toUpperCase());

        return response;
    }

    public List<Booking> getAllBookings() {
        return bookingRepository.findAllByOrderByCreatedAtDesc();
    }

    public List<Booking> getClientBookings(String userEmail) {
        User client = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return bookingRepository.findByClientOrderByCreatedAtDesc(client);
    }

    public Booking getBookingById(String id) {
        return bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));
    }

    private String generateInvoiceNumber() {
        long count = invoiceRepository.count();
        int year = LocalDate.now().getYear();
        return String.format("NXF-%d-%04d", year, count + 48);
    }
}
