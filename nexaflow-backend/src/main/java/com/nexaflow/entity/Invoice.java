package com.nexaflow.entity;

import com.nexaflow.enums.InvoiceStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "invoices")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Invoice {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id", nullable = false)
    private User client;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id")
    private Booking booking;

    @Column(name = "invoice_num", nullable = false, unique = true)
    private String invoiceNum;

    @Column(name = "items", columnDefinition = "TEXT")
    private String items; // JSON array of line items

    @Column(name = "subtotal")
    private Double subtotal;

    @Column(name = "gst")
    private Double gst; // GST/Tax amount

    @Column(name = "total")
    private Double total;

    @Column(name = "amount_paid")
    private Double amountPaid = 0.0;

    @Column(name = "amount_due")
    private Double amountDue;

    @Column(name = "currency")
    private String currency = "INR";

    @Column(name = "amount_usd")
    private Double amountUSD;

    @Column(name = "discount_inr")
    private Double discountINR = 0.0;

    @Column(name = "coupon_code")
    private String couponCode;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private InvoiceStatus status = InvoiceStatus.PENDING;

    @Column(name = "paid_date")
    private LocalDateTime paidDate;

    @Column(name = "due_date")
    private LocalDateTime dueDate;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
