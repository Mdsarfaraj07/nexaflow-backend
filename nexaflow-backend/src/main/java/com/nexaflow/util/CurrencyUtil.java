package com.nexaflow.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import jakarta.annotation.PostConstruct;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Map;

@Component
public class CurrencyUtil {

    @Value("${app.currency.default.usd-to-inr}")
    private Double defaultUsdToInr;

    @Value("${app.currency.api.url}")
    private String currencyApiUrl;

    private volatile Double usdToInrRate;
    private final WebClient webClient;

    public CurrencyUtil(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.build();
    }

    @PostConstruct
    public void init() {
        usdToInrRate = defaultUsdToInr;
        refreshExchangeRate();
    }

    // Refresh every 6 hours
    @Scheduled(fixedRate = 21600000)
    public void refreshExchangeRate() {
        try {
            Map<String, Object> response = webClient.get()
                    .uri(currencyApiUrl)
                    .retrieve()
                    .bodyToMono(Map.class)
                    .block();

            if (response != null && response.containsKey("rates")) {
                Map<String, Double> rates = (Map<String, Double>) response.get("rates");
                if (rates.containsKey("INR")) {
                    usdToInrRate = rates.get("INR");
                    System.out.println("💱 Exchange rate updated: 1 USD = ₹" + 
                                     String.format("%.2f", usdToInrRate));
                }
            }
        } catch (Exception e) {
            System.err.println("⚠️  Exchange rate refresh failed, using ₹" + usdToInrRate);
        }
    }

    public Double getUsdToInrRate() {
        return usdToInrRate;
    }

    public Double inrToUsd(Double inr) {
        if (inr == null) return 0.0;
        return Math.round(inr / usdToInrRate * 100.0) / 100.0;
    }

    public Double usdToInr(Double usd) {
        if (usd == null) return 0.0;
        return (double) Math.round(usd * usdToInrRate);
    }

    public String formatINR(Double amount) {
        if (amount == null) amount = 0.0;
        NumberFormat format = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
        return format.format(amount);
    }

    public String formatUSD(Double amount) {
        if (amount == null) amount = 0.0;
        NumberFormat format = NumberFormat.getCurrencyInstance(Locale.US);
        return format.format(amount);
    }

    public String formatPrice(Double inrAmount, String currency) {
        if ("USD".equalsIgnoreCase(currency)) {
            return formatUSD(inrToUsd(inrAmount));
        }
        return formatINR(inrAmount);
    }
}
