# 🐝 BeeTask – Smart Work & Task Management Platform

**BeeTask** is a full-featured web application for managing personal and team tasks, scheduling work, collaborating on projects, and optimizing productivity using AI-driven suggestions. Designed with usability, scalability, and security in mind, it supports various real-world use cases from education to business.

---

## 🌟 Key Features

- ✅ **User Authentication**  
  Register via email or Google, verify via OTP, and recover password securely.

- 📁 **Project & Task Management**  
  Create projects, assign members, manage task boards (To Do, In Progress, Done), upload attachments, comment, and track status in real time.

- 📅 **Calendar Integration**  
  Visualize upcoming deadlines, task timelines, and reminders on an interactive calendar synced to tasks and events.

- 🔔 **Notification System**  
  Get system or leader-generated notifications for task assignments, deadlines, and changes.

- 💡 **AI Scheduling**  
  Suggests optimal time slots for tasks based on workload and calendar using **Gemini AI API**.

- 🧩 **Templates & Notes**  
  Use ready-made templates (Scrum, Agile, V-Model...) and take categorized personal notes.

- 🔒 **Security & Optimization**  
  Passwords hashed with BCrypt, HTTPS with TLS 1.3, CSRF/XSS prevention, lazy-loading, and DB indexing for performance.

---

## 🛠️ Tech Stack

### Frontend
- **JSP, JSTL, HTML5, CSS3, JavaScript (ES6)**
- AJAX, Fetch API for dynamic interactions
- Google OAuth 2.0 integration
- Responsive UI with Material Design & Dark Mode

### Backend
- **Java Servlet**, JDBC, DAO Pattern
- SQL Server 2019+
- BCrypt for password hashing, SendGrid API for email
- Gemini AI API integration via RESTful endpoints
- Apache Tomcat for deployment

---

## 🚀 Getting Started

### Prerequisites
- Java JDK 11+
- Apache Tomcat 9+
- SQL Server
- IDE (Eclipse/IntelliJ) or Maven
- Google OAuth credentials
- SendGrid API Key

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/khanhhoa2102/BeeTask.git
   ```

2. **Import into IDE & configure server**
   - Deploy on Apache Tomcat
   - Set project as Dynamic Web Project

3. **Database Setup**
   - Use `BeeTask.sql` to create schema & sample data in SQL Server

4. **Configure Secrets**
   - Add Google OAuth client ID and SendGrid API key in `web.xml` or environment file

5. **Run & Access**
   - Start Tomcat and access `http://localhost:8080/BeeTask`

---

## 👨‍💻 Team & Contribution

This project was developed by a 5-member team as a Capstone Project at **FPT University – Da Nang**.

| Name                   | Email                            | Role           |
|------------------------|----------------------------------|----------------|
| **Dương Khánh Hòa**    | hoadkde180869@fpt.edu.vn         | Team Leader    |
| Nguyễn Hữu Sơn         | sonnnhde180845@fpt.edu.vn        | Developer      |
| Nguyễn Thanh Minh      | minhntde180825@fpt.edu.vn        | Developer      |
| Lê Xuân Sơn            | lexuanson03@gmail.com            | Developer      |
| Nguyễn Văn Nhật Nam    | pro94983@gmail.com               | Developer      |

**Team Leader Responsibilities (Hòa):**
- Led the team and coordinated development flow  
- Implemented user authentication (email, Google), email OTP verification, and password recovery  
- Designed and integrated AI scheduling module using Gemini API  
- Reviewed code and ensured secure deployment

