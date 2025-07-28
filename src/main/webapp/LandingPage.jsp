<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Template" %>
<%@ page import="dao.TemplateDAO" %>

<%
    TemplateDAO dao = new TemplateDAO();
    List<Template> templates = dao.getAllTemplates();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BeeTask - Work & Note Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="LandingPage.css">
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container">
                <div class="header-content">
                    <div class="header-left">
                        <button class="icon-btn">
                            <img src="${pageContext.request.contextPath}/Asset/Longlogo.png" alt="Logo">
                        </button>
                    </div>
                    <div class="search-container">
                        <div class="search-box">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" placeholder="Search templates..." class="search-input">
                        </div>
                    </div>
                    <div class="auth-buttons">
                        <button class="btn btn-ghost" onclick="window.location.href = 'Authentication/Login.jsp'">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </button>
                        <button class="btn btn-primary" onclick="window.location.href = 'Authentication/Register.jsp'">
                            <i class="fas fa-user-plus"></i> Register
                        </button>
                    </div>
                </div>
            </div>
        </header>

        <!-- Hero Section -->
        <section class="hero">
            <div class="container">
                <div class="hero-content">
                    <div class="badge">🚀 Efficient Task Management</div>
                    <h1 class="hero-title">
                        Manage tasks and notes with 
                        <span class="gradient-text">BeeTask</span>
                    </h1>
                    <p class="hero-description">
                        Similar to Trello, BeeTask helps you organize tasks visually and effectively.
                    </p>
                    <div class="hero-buttons">
                        <button class="btn btn-primary btn-large" onclick="window.location.href = 'Authentication/Register.jsp'">Get Started for Free <i class="fas fa-arrow-right"></i></button>
                        <button class="btn btn-outline btn-large" onclick="window.location.href = 'Home/Tutorial.jsp'">View Demo</button>
                    </div>
                </div>
            </div>
        </section>


        <div class="templates-grid">
            <%
                if (templates != null) {
                    int count = 0;
                    for (Template template : templates) {
                        String thumb = (template.getThumbnailUrl() != null && !template.getThumbnailUrl().isEmpty())
                                ? template.getThumbnailUrl()
                                : "https://via.placeholder.com/300x200";
                        // Thêm class 'hidden-template' cho các template từ thứ 7 trở đi
                        String hiddenClass = (count >= 6) ? "hidden-template" : "";
            %>
            <a href="TemplateDetail.jsp?templateId=<%= template.getTemplateId()%>" 
               class="template-card <%= hiddenClass%>">
                <div class="template-image">
                    <img src="<%= thumb%>" alt="<%= template.getName()%>">
                </div>
                <div class="template-content">
                    <div class="template-category"><%= template.getCategory()%></div>
                    <h3 class="template-title"><%= template.getName()%></h3>
                    <p class="template-description"><%= template.getDescription()%></p>
                </div>
            </a>
            <%
                        count++;
                    }
                }
            %>
        </div>
        <div class="view-all">
            <button class="btn btn-outline btn-large" id="viewAllBtn">
                View All Templates <i class="fas fa-arrow-right"></i>
            </button>
        </div>

        <!-- CTA Section -->
        <section class="cta">
            <div class="container">
                <div class="cta-content">
                    <h2 class="cta-title">Ready to start with BeeTask?</h2>
                    <p class="cta-description">
                        Join thousands of users who are managing work efficiently with BeeTask.
                    </p>
                    <div class="cta-buttons">
                        <button class="btn btn-white btn-large" onclick="window.location.href = 'Authentication/Register.jsp'">Sign Up Free <i class="fas fa-arrow-right"></i></button>
                        <button class="btn btn-outline-white btn-large">Contact Us</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-logo">
                        <div class="logo-icon"></div>
                        <span class="logo-text">BeeTask</span>
                    </div>
                    <p class="footer-description">Efficient task & note management</p>
                    <div class="footer-links">
                        <a href="#">About Us</a>
                        <a href="#">Features</a>
                        <a href="#">Support</a>
                        <a href="#">Contact</a>
                    </div>
                    <div class="footer-copyright">
                        © 2024 BeeTask. All rights reserved.
                    </div>
                </div>
            </div>
        </footer>

        <script src="${pageContext.request.contextPath}/LandingPage.js"></script>
    </body>
</html>
