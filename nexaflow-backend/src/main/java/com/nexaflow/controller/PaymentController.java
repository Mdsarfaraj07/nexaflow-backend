package com.nexaflow.controller;

import com.nexaflow.dto.request.PaymentOrderRequest;
import com.nexaflow.service.PaymentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping("/create-order")
    public ResponseEntity<Map<String, Object>> createPaymentOrder(
            @Valid @RequestBody PaymentOrderRequest request) {
        
        Map<String, Object> response = paymentService.createPaymentOrder(
                request.getAmount(),
                request.getCurrency(),
                request.getGateway()
        );
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/verify")
    public ResponseEntity<Map<String, Object>> verifyPayment(@RequestBody Map<String, String> request) {
        String paymentId = request.getOrDefault("razorpay_payment_id", 
                          request.get("stripe_payment_intent_id"));
        String invoiceId = request.get("invoiceId");
        String gateway = request.get("gateway");

        Map<String, Object> response = paymentService.verifyPayment(paymentId, invoiceId, gateway);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/stripe-key")
    public ResponseEntity<Map<String, Object>> getStripeKey() {
        Map<String, Object> response = paymentService.getStripePublicKey();
        return ResponseEntity.ok(response);
    }
}
