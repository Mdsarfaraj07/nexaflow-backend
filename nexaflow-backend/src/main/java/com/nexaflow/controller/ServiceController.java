package com.nexaflow.controller;

import com.nexaflow.entity.Service;
import com.nexaflow.repository.ServiceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/services")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ServiceController {

    private final ServiceRepository serviceRepository;

    @GetMapping("/public")
    public ResponseEntity<List<Service>> getActiveServices() {
        List<Service> services = serviceRepository.findByIsActiveTrueOrderByDisplayOrderAsc();
        return ResponseEntity.ok(services);
    }

    @GetMapping
    public ResponseEntity<List<Service>> getAllServices() {
        List<Service> services = serviceRepository.findAll();
        return ResponseEntity.ok(services);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Service> getServiceById(@PathVariable String id) {
        Service service = serviceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Service not found"));
        return ResponseEntity.ok(service);
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Service> createService(@RequestBody Service service) {
        Service savedService = serviceRepository.save(service);
        return ResponseEntity.ok(savedService);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Service> updateService(@PathVariable String id, @RequestBody Service serviceDetails) {
        Service service = serviceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Service not found"));

        service.setName(serviceDetails.getName());
        service.setDescription(serviceDetails.getDescription());
        service.setPriceINR(serviceDetails.getPriceINR());
        service.setPriceUSD(serviceDetails.getPriceUSD());
        service.setCategory(serviceDetails.getCategory());
        service.setDeliveryTime(serviceDetails.getDeliveryTime());
        service.setFeatures(serviceDetails.getFeatures());
        service.setIsActive(serviceDetails.getIsActive());
        service.setIsPopular(serviceDetails.getIsPopular());
        service.setDisplayOrder(serviceDetails.getDisplayOrder());
        service.setIcon(serviceDetails.getIcon());

        Service updatedService = serviceRepository.save(service);
        return ResponseEntity.ok(updatedService);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteService(@PathVariable String id) {
        serviceRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
