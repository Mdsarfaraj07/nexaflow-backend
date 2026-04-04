package com.nexaflow.repository;

import com.nexaflow.entity.Invoice;
import com.nexaflow.entity.User;
import com.nexaflow.enums.InvoiceStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, String> {
    
    List<Invoice> findByClient(User client);
    
    List<Invoice> findByClientOrderByCreatedAtDesc(User client);
    
    List<Invoice> findByStatus(InvoiceStatus status);
    
    List<Invoice> findByClientAndStatus(User client, InvoiceStatus status);
    
    Optional<Invoice> findByInvoiceNum(String invoiceNum);
    
    List<Invoice> findAllByOrderByCreatedAtDesc();
}
