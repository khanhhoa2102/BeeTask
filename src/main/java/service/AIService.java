package service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import config.AppConfig;
import model.ai.AISuggestionRequest;
import model.ai.AISuggestionResponse;
import com.google.gson.GsonBuilder;
import utils.LocalDateTimeAdapter;
import java.time.LocalDateTime;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class AIService {

    private static final String API_URL = "https://openrouter.ai/api/v1/chat/completions";
    private static final String API_KEY = AppConfig.get("openrouter.api_key");
    private static final String MODEL_NAME = AppConfig.get("openrouter.model");

    public AISuggestionResponse sendSchedulingRequest(AISuggestionRequest request) throws IOException {
        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();

        // Step 1: Convert user input to JSON
        String userJson = gson.toJson(request);

        // Step 2: Build message payload
        JsonObject messageSystem = new JsonObject();
        messageSystem.addProperty("role", "system");
//        messageSystem.addProperty("content",
//                "You are an AI assistant that generates optimized task schedules. "
//                + "Return your response as JSON ONLY in this format (strict ISO 8601 date format - e.g. 2025-07-20T18:00:00):\n"
//                + "{ \"schedules\": [\n"
//                + "  {\n"
//                + "    \"title\": \"Task name\",\n"
//                + "    \"difficulty\": 1,\n"
//                + "    \"dueDate\": \"2025-07-20T18:00:00\",\n"
//                + "    \"start\": \"2025-07-18T08:00:00\",\n"
//                + "    \"end\": \"2025-07-18T10:00:00\",\n"
//                + "    \"priority\": \"High\",\n"
//                + "    \"confidence\": 0.85,\n"
//                + "    \"shortDescription\": \"This task is important and fits best in your morning schedule.\"\n"
//                + "  },\n"
//                + "  ...\n"
//                + "]}");
        messageSystem.addProperty("content",
                "You are an AI assistant that helps schedule tasks. "
                + "Given exactly ONE task and a list of calendar events, "
                + "your job is to suggest the best start and end time for **THAT ONE TASK ONLY**, considering the user's calendar."
                + "You MUST return a JSON response in this format:\n"
                + "{ \"schedules\": [\n"
                + "  {\n"
                + "    \"title\": \"Task name\",\n"
                + "    \"description\": \"(optional short text)\",\n"
                + "    \"difficulty\": 1,\n"
                + "    \"dueDate\": \"2025-07-20T18:00:00\",\n"
                + "    \"start\": \"2025-07-18T08:00:00\",\n"
                + "    \"end\": \"2025-07-18T10:00:00\",\n"
                + "    \"priority\": \"High\",\n"
                + "    \"confidence\": 0.85,\n"
                + "    \"shortDescription\": \"This task is important and fits best in your morning schedule.\"\n"
                + "  }\n"
                + "]}\n"
                + "**Do NOT return any suggestion for other tasks or calendar events. Only return 1 schedule object.**"
        );

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

    public static void main(String[] args) {
        System.out.println("🔧 Testing AIService API Key loading...");

        if (API_KEY == null || API_KEY.isBlank()) {
            System.out.println("❌ API_KEY is missing or empty!");
        } else {
            System.out.println("✅ API_KEY loaded: " + API_KEY.substring(0, Math.min(10, API_KEY.length())) + "...");
        }

        if (MODEL_NAME == null || MODEL_NAME.isBlank()) {
            System.out.println("❌ MODEL_NAME is missing or empty!");
        } else {
            System.out.println("✅ MODEL_NAME loaded: " + MODEL_NAME);
        }
    }

}
