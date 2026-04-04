package com.nexaflow.entity;

import com.nexaflow.enums.BookingStatus;
import com.nexaflow.enums.PaymentType;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "bookings")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id")
    private User client;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_id")
    private Service service;

    @NotBlank(message = "Client name is required")
    @Column(name = "client_name", nullable = false)
    private String clientName;

    @Email
    @NotBlank(message = "Client email is required")
    @Column(name = "client_email", nullable = false)
    private String clientEmail;

    @Column(name = "client_phone")
    private String clientPhone;

    @Column(name = "client_company")
    private String clientCompany;

    @Column(name = "service_name")
    private String serviceName;

    @Column(name = "service_price")
    private Double servicePrice;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_type")
    private PaymentType paymentType; // FULL, PARTIAL, CONSULTATION

    @Column(name = "payment_id")
    private String paymentId;

    @Column(name = "amount_paid")
    private Double amountPaid = 0.0;

    @Column(name = "total")
    private Double total;

    @Column(name = "currency")
    private String currency = "INR"; // INR or USD

    @Column(name = "amount_usd")
    private Double amountUSD;

    @Column(name = "discount_inr")
    private Double discountINR = 0.0;

    @Column(name = "coupon_code")
    private String couponCode;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BookingStatus status = BookingStatus.CONFIRMED;

    @Column(name = "project_brief", columnDefinition = "TEXT")
    private String projectBrief;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
