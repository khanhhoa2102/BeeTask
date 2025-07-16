import model.ai.AISuggestionRequest;
import model.ai.AISuggestionResponse;
import model.ai.SimpleTask;
import model.ai.SimpleCalendarEvent;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AIServiceTest {
    public static void main(String[] args) {
        System.out.println("🧪 [TEST] Running AIService test...");

        // Kiểm tra API key
        System.out.println("🔐 API_KEY starts with: " + (AIService.API_KEY != null ? AIService.API_KEY.substring(0, 12) + "..." : "null"));
        System.out.println("📦 MODEL_NAME = " + AIService.MODEL_NAME);

        // Tạo Task mẫu
        SimpleTask task = new SimpleTask();
        task.setTitle("Test Task");
        task.setDescription("Thử nghiệm gửi yêu cầu AI");
        task.setDueDate(LocalDateTime.of(2025, 8, 1, 23, 59));
        task.setPriority("Low");
        task.setDifficulty(1);

        // Tạo Calendar Event mẫu
        SimpleCalendarEvent event = new SimpleCalendarEvent();
        event.setTitle("Cuộc họp UI");
        event.setStartTime(LocalDateTime.of(2025, 7, 20, 9, 0));
        event.setEndTime(LocalDateTime.of(2025, 7, 20, 10, 0));

        // Đóng gói vào request
        List<SimpleTask> tasks = new ArrayList<>();
        tasks.add(task);
        List<SimpleCalendarEvent> calendar = new ArrayList<>();
        calendar.add(event);

        AISuggestionRequest request = new AISuggestionRequest(tasks, calendar);

        // Gửi request đến AIService
        AIService service = new AIService();
        try {
            AISuggestionResponse result = service.sendSchedulingRequest(request);
            System.out.println("✅ AI Suggestion Response:");
            System.out.println(result);
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi gọi AI:");
            e.printStackTrace();
        }
    }
}
