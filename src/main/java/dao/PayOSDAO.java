/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import org.json.JSONObject;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 *
 * @author ADMIN
 */
public class PayOSDAO {
    private final String clientId = "82ecff05-52b9-4f85-adc1-378ecec04ad5";
    private final String apiKey = "e8739a2a-d42a-4191-b40e-88ec2a9c59d7";
    private final String checksumKey = "c0b198c9ac287c53c0cbcc33ba942e4cf8615fe99e0a4177b04acc6f057322e6";

    public String createPayOSOrder(long orderCode, long amount, String returnUrl, String cancelUrl, int id) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();
        
        String description = "Thanh toan don hang ID: " + id;

        String rawSignature = "amount=" + amount +
                      "&cancelUrl=" + cancelUrl +
                      "&description=" + description +
                      "&orderCode=" + orderCode +
                      "&returnUrl=" + returnUrl;
        String signature = generateSignature(rawSignature, checksumKey);
        
        JSONObject bodyJson = new JSONObject();
        bodyJson.put("orderCode", orderCode);
        bodyJson.put("amount", amount);
        bodyJson.put("description", description);
        bodyJson.put("returnUrl", returnUrl);
        bodyJson.put("cancelUrl", cancelUrl);
        bodyJson.put("signature", signature);

        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("https://api-merchant.payos.vn/v2/payment-requests"))
            .header("Content-Type", "application/json")
            .header("x-client-id", clientId)
            .header("x-api-key", apiKey)
            .POST(HttpRequest.BodyPublishers.ofString(bodyJson.toString()))
            .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        System.out.println("PayOS response body:\n" + response.body()); // Debug log

        if (response.statusCode() == 200 || response.statusCode() == 201) {
            return response.body();
        } else {
            throw new RuntimeException("PayOS create payment failed (" + response.statusCode() + "): " + response.body());
        }
    }


    public String getPayOSOrderStatus(long orderCode) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("https://api-merchant.payos.vn/v2/payment-requests/" + orderCode))
            .header("x-client-id", clientId)
            .header("x-api-key", apiKey)
            .GET()
            .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            return response.body();
        } else {
            throw new RuntimeException("Failed to check order status. HTTP: " + response.statusCode());
        }
    }

    public String generateSignature(String data, String checksumKey) {
        try {
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKey = new SecretKeySpec(checksumKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secretKey);
            byte[] hash = sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hash);
        } catch (Exception e) {
            throw new RuntimeException("Error while generating signature", e);
        }
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder hexString = new StringBuilder();
        for (byte b : bytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }



}
