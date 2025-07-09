from flask import Flask, request, jsonify
from dotenv import load_dotenv
import os
import requests

app = Flask(__name__)
load_dotenv()

api_key = os.getenv("TOGETHER_API_KEY")  # ✅ dùng đúng biến TOGETHER
if not api_key:
    raise Exception("❌ TOGETHER_API_KEY not found in .env")

TOGETHER_API_URL = "https://api.together.xyz/v1/chat/completions"

@app.route("/ai/schedule", methods=["POST"])
def suggest_schedule():
    data = request.json
    tasks = data.get("tasks", [])
    calendar = data.get("calendar", [])

    prompt = build_prompt(tasks, calendar)

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": "meta-llama/Llama-3-8b-chat-hf",  # ✅ hoặc thay bằng model khác như mistral nếu bạn muốn
        "messages": [
            {"role": "system", "content": "You are a helpful AI scheduling assistant."},
            {"role": "user", "content": prompt}
        ],
        "max_tokens": 1000
    }

    try:
        response = requests.post(TOGETHER_API_URL, headers=headers, json=payload)
        result = response.json()
        suggestion = result["choices"][0]["message"]["content"]

        return jsonify({
            "status": "success",
            "suggestion": suggestion.strip()
        })

    except Exception as e:
        print("[ERROR]", e)
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


def build_prompt(tasks, calendar):
    task_lines = "\n".join([
        f"- {task['title']} (Due: {task['dueDate']}, Status: {task.get('status', 'Unknown')})"
        for task in tasks
    ])
    calendar_lines = "\n".join([
        f"- {event['title']}: {event['start']} → {event['end']}"
        for event in calendar
    ])
    return f"""
Bạn là trợ lý AI giúp người dùng lập lịch làm việc thông minh.

Tasks:
{task_lines}

Calendar:
{calendar_lines or '(Trống)'}

Hãy đề xuất thời gian phù hợp để thực hiện các task, tránh trùng lịch đã có.

Trả kết quả đúng định dạng JSON như sau:
{{
  "suggestions": [
    {{
      "task": "Tên task",
      "start": "yyyy-MM-ddTHH:mm",
      "end": "yyyy-MM-ddTHH:mm"
    }}
  ]
}}

Chỉ trả về JSON, không cần giải thích.
""".strip()


if __name__ == "__main__":
    app.run(port=5001, debug=True)
