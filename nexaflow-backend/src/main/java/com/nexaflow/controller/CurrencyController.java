package com.nexaflow.controller;

import com.nexaflow.util.CurrencyUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/currency")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CurrencyController {

    private final CurrencyUtil currencyUtil;

    @GetMapping("/rate")
    public ResponseEntity<Map<String, Object>> getExchangeRate() {
        Map<String, Object> response = new HashMap<>();
        response.put("usdToInr", currencyUtil.getUsdToInrRate());
        response.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/convert")
    public ResponseEntity<Map<String, Object>> convertCurrency(@RequestBody Map<String, Object> request) {
        Double amount = ((Number) request.get("amount")).doubleValue();
        String from = (String) request.getOrDefault("from", "INR");
        String to = (String) request.getOrDefault("to", "USD");

        Double converted;
        if ("INR".equals(from) && "USD".equals(to)) {
            converted = currencyUtil.inrToUsd(amount);
        } else if ("USD".equals(from) && "INR".equals(to)) {
            converted = currencyUtil.usdToInr(amount);
        } else {
            converted = amount; // Same currency
        }

        Map<String, Object> response = new HashMap<>();
        response.put("amount", amount);
        response.put("from", from);
        response.put("to", to);
        response.put("converted", converted);
        response.put("rate", currencyUtil.getUsdToInrRate());

        return ResponseEntity.ok(response);
    }
}
