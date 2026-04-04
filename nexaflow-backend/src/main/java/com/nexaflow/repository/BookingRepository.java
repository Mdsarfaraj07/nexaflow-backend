package com.nexaflow.repository;

import com.nexaflow.entity.Booking;
import com.nexaflow.entity.User;
import com.nexaflow.enums.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, String> {
    
    List<Booking> findByClient(User client);
    
    List<Booking> findByClientOrderByCreatedAtDesc(User client);
    
    List<Booking> findByStatus(BookingStatus status);
    
    List<Booking> findByClientAndStatus(User client, BookingStatus status);
    
    List<Booking> findAllByOrderByCreatedAtDesc();
}
