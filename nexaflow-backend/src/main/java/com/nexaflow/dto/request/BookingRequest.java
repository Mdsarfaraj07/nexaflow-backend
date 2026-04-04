package com.nexaflow.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingRequest {
    
    @NotBlank(message = "Client name is required")
    private String clientName;
    
    @Email(message = "Invalid email format")
    @NotBlank(message = "Client email is required")
    private String clientEmail;
    
    private String clientPhone;
    private String clientCompany;
    
    @NotBlank(message = "Service ID is required")
    private String serviceId;
    
    private String serviceName;
    private Double servicePrice;
    private Double servicePriceUSD;
    
    private String paymentType; // FULL, PARTIAL, CONSULTATION
    private String paymentId;
    private Double amountPaid;
    private String projectBrief;
    private String currency; // INR or USD
    private String couponCode;
}
