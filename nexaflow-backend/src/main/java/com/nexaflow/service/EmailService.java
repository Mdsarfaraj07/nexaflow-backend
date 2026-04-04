package com.nexaflow.service;

import com.nexaflow.entity.EmailLog;
import com.nexaflow.enums.EmailStatus;
import com.nexaflow.repository.EmailLogRepository;
import com.nexaflow.util.CurrencyUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;
    private final EmailLogRepository emailLogRepository;
    private final CurrencyUtil currencyUtil;

    @Value("${spring.mail.from}")
    private String fromEmail;

    @Value("${app.url}")
    private String appUrl;

    @Async
    public void sendEmail(String to, String subject, String htmlBody, String emailType) {
        EmailLog emailLog = EmailLog.builder()
                .toEmail(to)
                .subject(subject)
                .body(htmlBody)
                .emailType(emailType)
                .status(EmailStatus.PENDING)
                .build();

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);

            mailSender.send(message);

            emailLog.setStatus(EmailStatus.SENT);
            emailLog.setSentAt(LocalDateTime.now());
            
            System.out.println("✅ EMAIL SENT → " + to + " | " + subject);
        } catch (Exception e) {
            emailLog.setStatus(EmailStatus.FAILED);
            emailLog.setErrorMessage(e.getMessage());
            System.err.println("❌ EMAIL FAILED → " + to + " | " + e.getMessage());
        } finally {
            emailLogRepository.save(emailLog);
        }
    }

    public void sendWelcomeEmail(String to, String name, String email) {
        String content = String.format("""
            <div class="h1">Welcome to NexaFlow, %s! 🎉</div>
            <p class="p">Your account is ready. Access your dashboard to track projects, invoices, and messages.</p>
            <a href="%s/dashboard" class="btn">Open My Dashboard →</a>
            <div class="info-box">
                <div class="info-row"><span class="info-label">Email</span><span class="info-val">%s</span></div>
                <div class="info-row"><span class="info-label">Portal</span><span class="info-val">%s/dashboard</span></div>
            </div>
            """, name, appUrl, email, appUrl);

        sendEmail(to, "Welcome to NexaFlow", getEmailTemplate(content), "welcome");
    }

    public void sendBookingConfirmation(String to, Map<String, Object> data) {
        Double amount = (Double) data.getOrDefault("amount", 0.0);
        String amtDisplay = String.format("%s <span style=\"color:#8892b0;font-size:.8em\">(≈ %s)</span>",
                currencyUtil.formatINR(amount), currencyUtil.formatUSD(currencyUtil.inrToUsd(amount)));

        String content = String.format("""
            <div class="h1">Booking Confirmed ✅</div>
            <p class="p">Hi %s, your booking is confirmed.</p>
            <div class="info-box">
                <div class="info-row"><span class="info-label">Service</span><span class="info-val">%s</span></div>
                <div class="info-row"><span class="info-label">Booking ID</span><span class="info-val">%s</span></div>
                <div class="info-row"><span class="info-label">Invoice</span><span class="info-val">%s</span></div>
                <div class="info-row"><span class="info-label">Amount Paid</span><span class="info-val amount">%s</span></div>
                <div class="info-row"><span class="info-label">Status</span><span class="info-val"><span class="badge badge-green">Confirmed</span></span></div>
            </div>
            <a href="%s/dashboard" class="btn">View Dashboard →</a>
            <p class="p">Our team will be in touch within 24 hours. 🚀</p>
            """,
                data.get("clientName"),
                data.get("serviceName"),
                data.get("bookingId"),
                data.get("invoiceNum"),
                amtDisplay,
                appUrl);

        sendEmail(to, "Booking Confirmed — " + data.get("serviceName"), 
                 getEmailTemplate(content), "booking");
    }

    public void sendPaymentReceived(String to, Map<String, Object> data) {
        Double amount = (Double) data.getOrDefault("amount", 0.0);
        String amtDisplay = String.format("%s <span style=\"color:#8892b0;font-size:.8em\">(≈ %s)</span>",
                currencyUtil.formatINR(amount), currencyUtil.formatUSD(currencyUtil.inrToUsd(amount)));

        String content = String.format("""
            <div class="h1">Payment Received 💳</div>
            <p class="p">Hi %s, we've received your payment. Thank you!</p>
            <div class="info-box">
                <div class="info-row"><span class="info-label">Amount</span><span class="info-val amount">%s</span></div>
                <div class="info-row"><span class="info-label">Payment ID</span><span class="info-val">%s</span></div>
                <div class="info-row"><span class="info-label">Invoice</span><span class="info-val">%s</span></div>
                <div class="info-row"><span class="info-label">Date</span><span class="info-val">%s</span></div>
            </div>
            <a href="%s/dashboard" class="btn">View Dashboard →</a>
            """,
                data.get("clientName"),
                amtDisplay,
                data.get("paymentId"),
                data.get("invoiceNum"),
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("MMMM d, yyyy")),
                appUrl);

        sendEmail(to, "Payment Received — NexaFlow", getEmailTemplate(content), "payment_received");
    }

    public void sendMilestoneCompleted(String to, Map<String, Object> data) {
        String content = String.format("""
            <div class="h1">Milestone Completed ✨</div>
            <p class="p">Hi %s, great news! A milestone has been completed.</p>
            <div class="info-box">
                <div class="info-row"><span class="info-label">Project</span><span class="info-val">%s</span></div>
                <div class="info-row"><span class="info-label">Milestone</span><span class="info-val">%s</span></div>
                <div class="info-row"><span class="info-label">Status</span><span class="info-val"><span class="badge badge-green">Completed</span></span></div>
            </div>
            <a href="%s/dashboard" class="btn">View Project →</a>
            """,
                data.get("clientName"),
                data.get("projectTitle"),
                data.get("milestoneTitle"),
                appUrl);

        sendEmail(to, "Milestone Completed — " + data.get("projectTitle"), 
                 getEmailTemplate(content), "milestone");
    }

    private String getEmailTemplate(String content) {
        return String.format("""
            <!DOCTYPE html><html><head><meta charset="UTF-8">
            <style>
                body{font-family:'DM Sans',Arial,sans-serif;background:#05091a;color:#dde3f5;margin:0;padding:0}
                .wrap{max-width:580px;margin:30px auto;background:#080d22;border:1px solid rgba(255,255,255,.08);border-radius:16px;overflow:hidden}
                .header{padding:28px 32px;background:linear-gradient(135deg,rgba(124,92,252,.15),rgba(0,229,201,.08));border-bottom:1px solid rgba(255,255,255,.08)}
                .logo{font-size:1.3rem;font-weight:800;color:#fff}.logo span{color:#00e5c9}
                .body{padding:28px 32px}.h1{font-size:1.25rem;font-weight:700;color:#fff;margin:0 0 12px}
                .p{font-size:.9rem;color:#8892b0;line-height:1.7;margin:0 0 14px}
                .btn{display:inline-block;padding:12px 24px;border-radius:10px;background:linear-gradient(135deg,#7c5cfc,#4361ee);color:#fff;font-weight:700;text-decoration:none;font-size:.9rem;margin:10px 0}
                .info-box{background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.08);border-radius:10px;padding:16px;margin:14px 0}
                .info-row{display:flex;justify-content:space-between;padding:5px 0;font-size:.85rem;border-bottom:1px solid rgba(255,255,255,.05)}
                .info-row:last-child{border:none}.info-label{color:#8892b0}.info-val{color:#fff;font-weight:600}
                .amount{font-size:1.4rem;font-weight:800;color:#00e5c9;font-family:monospace}
                .footer{padding:18px 32px;text-align:center;font-size:.75rem;color:#546080;border-top:1px solid rgba(255,255,255,.05)}
                .badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:.75rem;font-weight:700}
                .badge-green{background:rgba(0,229,100,.15);color:#00e564}
            </style></head>
            <body><div class="wrap">
                <div class="header"><div class="logo">Nexa<span>Flow</span></div></div>
                <div class="body">%s</div>
                <div class="footer">
                    NexaFlow Solutions · hello@nexaflow.in<br>
                    <a href="%s" style="color:#7c5cfc">Visit Website</a>
                </div>
            </div></body></html>
            """, content, appUrl);
    }
}
