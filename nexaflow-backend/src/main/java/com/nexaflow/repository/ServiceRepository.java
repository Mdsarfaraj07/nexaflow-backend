package com.nexaflow.repository;

import com.nexaflow.entity.Service;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ServiceRepository extends JpaRepository<Service, String> {
    
    List<Service> findByIsActiveTrueOrderByDisplayOrderAsc();
    
    List<Service> findByCategory(String category);
    
    List<Service> findByIsPopularTrue();
}
