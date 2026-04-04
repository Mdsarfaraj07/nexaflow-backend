package com.nexaflow;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * NexaFlow v3.0 — Spring Boot Application
 * Global SaaS & Digital Agency Platform
 * 
 * Features:
 * - Dual Currency Support (INR + USD)
 * - Payment Gateways (Stripe + Razorpay)
 * - JWT Authentication
 * - Project Management
 * - Invoice & Billing
 * - Email Notifications
 * - AI Chat Integration
 */
@SpringBootApplication
@EnableAsync
@EnableScheduling
public class NexaFlowApplication {

    public static void main(String[] args) {
        SpringApplication.run(NexaFlowApplication.class, args);
        System.out.println("\n" +
            "═══════════════════════════════════════════════════════════════════\n" +
            "  NexaFlow v3.0 Backend Started Successfully! \n" +
            "  ✅ Server: http://localhost:8080\n" +
            "  ✅ API Docs: http://localhost:8080/api\n" +
            "  ✅ Health: http://localhost:8080/actuator/health\n" +
            "═══════════════════════════════════════════════════════════════════\n"
        );
    }
}
