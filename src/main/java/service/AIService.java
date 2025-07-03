package service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import config.AppConfig;
import model.ai.AISuggestionRequest;
import model.ai.AISuggestionResponse;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class AIService {

    private static final String API_URL = "https://openrouter.ai/api/v1/chat/completions";
   private static final String API_KEY = AppConfig.get("openrouter.api.key");
    private static final String MODEL_NAME = "mistralai/mistral-7b-instruct:free";

    public AISuggestionResponse sendSchedulingRequest(AISuggestionRequest request) throws IOException {
        Gson gson = new Gson();

        // Step 1: Convert user input to JSON
        String userJson = gson.toJson(request);

        // Step 2: Build message payload
        JsonObject messageSystem = new JsonObject();
        messageSystem.addProperty("role", "system");
        messageSystem.addProperty("content", "You are an AI assistant that generates optimized task schedules. Reply ONLY with valid JSON in the format: { \"schedules\": [...] }");

        JsonObject messageUser = new JsonObject();
        messageUser.addProperty("role", "user");
        messageUser.addProperty("content", "Here is my list of tasks and calendar events:\n\n" + userJson);

        JsonObject body = new JsonObject();
        body.addProperty("model", MODEL_NAME);
        body.add("messages", gson.toJsonTree(new JsonObject[]{messageSystem, messageUser}));

        System.out.println(">> [AIService] Sending JSON to OpenRouter:");
        System.out.println(body.toString());

        // Step 3: Send HTTP POST request
        HttpURLConnection conn = (HttpURLConnection) new URL(API_URL).openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setRequestProperty("Accept-Charset", "UTF-8");
        conn.setDoOutput(true);

        try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream(), StandardCharsets.UTF_8)) {
            writer.write(body.toString());
        }

        System.out.println(">> [AIService] Waiting for AI response...");

        // Step 4: Read response from AI
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
        }

        System.out.println("<< [AIService] Raw response from AI:");
        System.out.println(response);

        // Step 5: Extract the JSON content string from the AI response
        JsonObject json = gson.fromJson(response.toString(), JsonObject.class);
        String rawContent = json.getAsJsonArray("choices")
                .get(0).getAsJsonObject()
                .getAsJsonObject("message")
                .get("content").getAsString();

        System.out.println("<< [AIService] Extracted content:");
        System.out.println(rawContent);

        // Step 6: Remove markdown wrapper if exists
        String content = extractPureJson(rawContent);

        try {
            return gson.fromJson(content, AISuggestionResponse.class);
        } catch (Exception e) {
            System.out.println("❌ [AIService] Failed to parse JSON content:");
            System.out.println(content);
            throw new IOException("AI returned invalid JSON", e);
        }
    }

    /**
     * Extracts pure JSON from a markdown-formatted response.
     */
    private String extractPureJson(String content) {
        int start = content.indexOf("```json");
        int end = content.indexOf("```", start + 7);

        if (start != -1 && end != -1) {
            return content.substring(start + 7, end).trim();
        }

        // Fallback: find first and last JSON brace
        int braceStart = content.indexOf("{");
        int braceEnd = content.lastIndexOf("}");
        if (braceStart != -1 && braceEnd != -1) {
            return content.substring(braceStart, braceEnd + 1).trim();
        }

        return content;
    }
}
