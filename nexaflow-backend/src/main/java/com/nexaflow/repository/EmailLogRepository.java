package com.nexaflow.repository;

import com.nexaflow.entity.EmailLog;
import com.nexaflow.enums.EmailStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EmailLogRepository extends JpaRepository<EmailLog, String> {
    
    List<EmailLog> findByToEmail(String toEmail);
    
    List<EmailLog> findByStatus(EmailStatus status);
    
    List<EmailLog> findByEmailType(String emailType);
    
    List<EmailLog> findAllByOrderByCreatedAtDesc();
}
