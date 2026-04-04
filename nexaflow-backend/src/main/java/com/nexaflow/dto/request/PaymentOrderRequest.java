package com.nexaflow.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentOrderRequest {
    
    @NotNull(message = "Amount is required")
    private Double amount;
    
    private String currency = "INR"; // INR or USD
    private String gateway = "auto"; // auto, stripe, razorpay
}
