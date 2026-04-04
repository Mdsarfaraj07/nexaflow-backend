package com.nexaflow.config;

import com.nexaflow.entity.Service;
import com.nexaflow.entity.User;
import com.nexaflow.enums.UserRole;
import com.nexaflow.repository.ServiceRepository;
import com.nexaflow.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final ServiceRepository serviceRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${app.admin.email}")
    private String adminEmail;

    @Value("${app.admin.password}")
    private String adminPassword;

    @Value("${app.admin.name}")
    private String adminName;

    @Value("${app.demo.client.email}")
    private String demoClientEmail;

    @Value("${app.demo.client.password}")
    private String demoClientPassword;

    @Value("${app.demo.client.name}")
    private String demoClientName;

    @Override
    public void run(String... args) {
        initializeUsers();
        initializeServices();
        
        System.out.println("\n═══════════════════════════════════════════════════════════════");
        System.out.println("  ✅ Database Initialized Successfully!");
        System.out.println("  📧 Admin: " + adminEmail + " | Password: " + adminPassword);
        System.out.println("  📧 Demo Client: " + demoClientEmail + " | Password: " + demoClientPassword);
        System.out.println("═══════════════════════════════════════════════════════════════\n");
    }

    private void initializeUsers() {
        // Create default admin if not exists
        if (!userRepository.existsByEmail(adminEmail)) {
            User admin = User.builder()
                    .name(adminName)
                    .email(adminEmail)
                    .password(passwordEncoder.encode(adminPassword))
                    .role(UserRole.ADMIN)
                    .preferredCurrency("INR")
                    .isActive(true)
                    .emailVerified(true)
                    .build();
            userRepository.save(admin);
            System.out.println("✓ Default admin created");
        }

        // Create demo client if not exists
        if (!userRepository.existsByEmail(demoClientEmail)) {
            User demoClient = User.builder()
                    .name(demoClientName)
                    .email(demoClientEmail)
                    .password(passwordEncoder.encode(demoClientPassword))
                    .phone("+91 98765 43210")
                    .company("Demo Company Ltd")
                    .role(UserRole.CLIENT)
                    .preferredCurrency("INR")
                    .totalInvested(0.0)
                    .isActive(true)
                    .emailVerified(true)
                    .build();
            userRepository.save(demoClient);
            System.out.println("✓ Demo client created");
        }
    }

    private void initializeServices() {
        if (serviceRepository.count() == 0) {
            // Website Development
            Service service1 = Service.builder()
                    .name("Website Development")
                    .description("Custom website development with modern technologies")
                    .priceINR(50000.0)
                    .priceUSD(600.0)
                    .category("Web Development")
                    .deliveryTime("2-3 weeks")
                    .features("[\"Responsive Design\", \"SEO Optimized\", \"Admin Panel\", \"Mobile Friendly\", \"Fast Loading\"]")
                    .isActive(true)
                    .isPopular(true)
                    .displayOrder(1)
                    .icon("code")
                    .build();

            // Mobile App Development
            Service service2 = Service.builder()
                    .name("Mobile App Development")
                    .description("Native iOS and Android app development")
                    .priceINR(150000.0)
                    .priceUSD(1800.0)
                    .category("Mobile Development")
                    .deliveryTime("4-6 weeks")
                    .features("[\"iOS & Android\", \"API Integration\", \"Push Notifications\", \"Cloud Backend\", \"App Store Ready\"]")
                    .isActive(true)
                    .isPopular(true)
                    .displayOrder(2)
                    .icon("smartphone")
                    .build();

            // UI/UX Design
            Service service3 = Service.builder()
                    .name("UI/UX Design")
                    .description("Beautiful and intuitive user interface design")
                    .priceINR(30000.0)
                    .priceUSD(360.0)
                    .category("Design")
                    .deliveryTime("1-2 weeks")
                    .features("[\"Wireframes\", \"Mockups\", \"Prototypes\", \"User Testing\", \"Design System\"]")
                    .isActive(true)
                    .isPopular(false)
                    .displayOrder(3)
                    .icon("palette")
                    .build();

            // E-commerce Solution
            Service service4 = Service.builder()
                    .name("E-commerce Solution")
                    .description("Complete e-commerce platform with payment integration")
                    .priceINR(100000.0)
                    .priceUSD(1200.0)
                    .category("E-commerce")
                    .deliveryTime("3-4 weeks")
                    .features("[\"Product Management\", \"Payment Gateway\", \"Order Tracking\", \"Admin Dashboard\", \"Mobile Responsive\"]")
                    .isActive(true)
                    .isPopular(true)
                    .displayOrder(4)
                    .icon("shopping-cart")
                    .build();

            // Digital Marketing
            Service service5 = Service.builder()
                    .name("Digital Marketing")
                    .description("Complete digital marketing and SEO services")
                    .priceINR(25000.0)
                    .priceUSD(300.0)
                    .category("Marketing")
                    .deliveryTime("Ongoing")
                    .features("[\"SEO Optimization\", \"Social Media\", \"Content Marketing\", \"Analytics\", \"PPC Campaigns\"]")
                    .isActive(true)
                    .isPopular(false)
                    .displayOrder(5)
                    .icon("trending-up")
                    .build();

            // Custom Software Development
            Service service6 = Service.builder()
                    .name("Custom Software Development")
                    .description("Tailored software solutions for your business needs")
                    .priceINR(200000.0)
                    .priceUSD(2400.0)
                    .category("Software Development")
                    .deliveryTime("6-8 weeks")
                    .features("[\"Custom Features\", \"Scalable Architecture\", \"API Development\", \"Database Design\", \"Maintenance Support\"]")
                    .isActive(true)
                    .isPopular(false)
                    .displayOrder(6)
                    .icon("cpu")
                    .build();

            serviceRepository.save(service1);
            serviceRepository.save(service2);
            serviceRepository.save(service3);
            serviceRepository.save(service4);
            serviceRepository.save(service5);
            serviceRepository.save(service6);

            System.out.println("✓ Default services created");
        }
    }
}
