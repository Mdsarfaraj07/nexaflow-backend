package com.nexaflow.repository;

import com.nexaflow.entity.Coupon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CouponRepository extends JpaRepository<Coupon, String> {
    
    Optional<Coupon> findByCode(String code);
    
    Optional<Coupon> findByCodeAndIsActiveTrue(String code);
    
    List<Coupon> findByIsActiveTrue();
    
    List<Coupon> findAllByOrderByCreatedAtDesc();
}
