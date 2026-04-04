package com.nexaflow.service;

import com.nexaflow.entity.Invoice;
import com.nexaflow.entity.User;
import com.nexaflow.enums.InvoiceStatus;
import com.nexaflow.repository.InvoiceRepository;
import com.nexaflow.repository.UserRepository;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;
import lombok.RequiredArgsConstructor;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final InvoiceRepository invoiceRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;

    @Value("${stripe.api.key}")
    private String stripeApiKey;

    @Value("${stripe.publishable.key}")
    private String stripePublishableKey;

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret}")
    private String razorpayKeySecret;

    private RazorpayClient razorpayClient;

    @PostConstruct
    public void init() {
        if (stripeApiKey != null && !stripeApiKey.isEmpty()) {
            Stripe.apiKey = stripeApiKey;
        }

        if (razorpayKeyId != null && !razorpayKeyId.isEmpty() &&
            razorpayKeySecret != null && !razorpayKeySecret.isEmpty()) {
            try {
                razorpayClient = new RazorpayClient(razorpayKeyId, razorpayKeySecret);
            } catch (RazorpayException e) {
                System.err.println("Failed to initialize Razorpay: " + e.getMessage());
            }
        }
    }

    public Map<String, Object> createPaymentOrder(Double amount, String currency, String gateway) {
        Map<String, Object> response = new HashMap<>();

        // Auto-select gateway based on currency
        boolean useStripe = "stripe".equals(gateway) || 
                           ("USD".equalsIgnoreCase(currency) && stripeApiKey != null && !stripeApiKey.isEmpty());
        boolean useRazorpay = !useStripe && razorpayClient != null;

        try {
            // Stripe Payment Intent
            if (useStripe) {
                Long amountInCents = Math.round(amount * 100);
                
                PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                        .setAmount(amountInCents)
                        .setCurrency(currency.toLowerCase())
                        .addPaymentMethodType("card")
                        .build();

                PaymentIntent paymentIntent = PaymentIntent.create(params);

                Map<String, Object> order = new HashMap<>();
                order.put("id", paymentIntent.getId());
                order.put("amount", paymentIntent.getAmount());
                order.put("currency", paymentIntent.getCurrency());

                response.put("order", order);
                response.put("clientSecret", paymentIntent.getClientSecret());
                response.put("key", stripePublishableKey);
                response.put("gateway", "stripe");

                return response;
            }

            // Razorpay Order
            if (useRazorpay) {
                Integer amountInPaise = (int) Math.round(amount * 100);

                JSONObject orderRequest = new JSONObject();
                orderRequest.put("amount", amountInPaise);
                orderRequest.put("currency", "INR");
                orderRequest.put("receipt", "rcpt_" + System.currentTimeMillis());

                Order order = razorpayClient.orders.create(orderRequest);

                response.put("order", convertRazorpayOrderToMap(order));
                response.put("key", razorpayKeyId);
                response.put("gateway", "razorpay");

                return response;
            }

            // Demo mode (no payment gateway configured)
            Map<String, Object> demoOrder = new HashMap<>();
            demoOrder.put("id", "demo_" + System.currentTimeMillis());
            demoOrder.put("amount", Math.round(amount * 100));
            demoOrder.put("currency", currency);
            demoOrder.put("demo", true);

            response.put("order", demoOrder);
            response.put("key", "");
            response.put("demo", true);
            response.put("gateway", "demo");

            return response;

        } catch (StripeException | RazorpayException e) {
            throw new RuntimeException("Payment order creation failed: " + e.getMessage());
        }
    }

    @Transactional
    public Map<String, Object> verifyPayment(String paymentId, String invoiceId, String gateway) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Verify based on gateway
            if ("stripe".equals(gateway) && stripeApiKey != null && !stripeApiKey.isEmpty()) {
                PaymentIntent paymentIntent = PaymentIntent.retrieve(paymentId);
                
                if (!"succeeded".equals(paymentIntent.getStatus())) {
                    throw new RuntimeException("Payment not completed");
                }

                markInvoiceAsPaid(invoiceId, paymentId);
                response.put("success", true);
                response.put("paymentId", paymentId);
                response.put("gateway", "stripe");

            } else if ("razorpay".equals(gateway) && razorpayClient != null) {
                // For Razorpay, signature verification would be done here
                // For now, we'll mark as paid (in production, verify signature)
                markInvoiceAsPaid(invoiceId, paymentId);
                response.put("success", true);
                response.put("paymentId", paymentId);
                response.put("gateway", "razorpay");

            } else {
                // Demo mode
                markInvoiceAsPaid(invoiceId, paymentId);
                response.put("success", true);
                response.put("demo", true);
            }

        } catch (StripeException e) {
            throw new RuntimeException("Payment verification failed: " + e.getMessage());
        }

        return response;
    }

    private void markInvoiceAsPaid(String invoiceId, String paymentId) {
        Invoice invoice = invoiceRepository.findById(invoiceId)
                .orElseThrow(() -> new RuntimeException("Invoice not found"));

        invoice.setStatus(InvoiceStatus.PAID);
        invoice.setAmountPaid(invoice.getTotal());
        invoice.setAmountDue(0.0);
        invoice.setPaidDate(LocalDateTime.now());

        invoiceRepository.save(invoice);

        // Send payment received email
        User client = invoice.getClient();
        Map<String, Object> emailData = new HashMap<>();
        emailData.put("clientName", client.getName());
        emailData.put("amount", invoice.getTotal());
        emailData.put("paymentId", paymentId);
        emailData.put("invoiceNum", invoice.getInvoiceNum());

        emailService.sendPaymentReceived(client.getEmail(), emailData);
    }

    private Map<String, Object> convertRazorpayOrderToMap(Order order) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", order.get("id"));
        map.put("entity", order.get("entity"));
        map.put("amount", order.get("amount"));
        map.put("currency", order.get("currency"));
        map.put("receipt", order.get("receipt"));
        map.put("status", order.get("status"));
        return map;
    }

    public Map<String, Object> getStripePublicKey() {
        Map<String, Object> response = new HashMap<>();
        response.put("key", stripePublishableKey);
        response.put("enabled", stripeApiKey != null && !stripeApiKey.isEmpty());
        return response;
    }
}
