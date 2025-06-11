<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Template" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BeeTask - Quản lý công việc và ghi chú</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/LandingPage.css">
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
                            <input type="text" placeholder="Tìm kiếm templates..." class="search-input">
                        </div>
                    </div>
                    <div class="auth-buttons">
                        <button class="btn btn-ghost">
                            <i class="fas fa-sign-in-alt"></i> Đăng nhập
                        </button>
                        <button class="btn btn-primary">
                            <i class="fas fa-user-plus"></i> Đăng ký
                        </button>
                    </div>
                </div>
            </div>
        </header>

        <!-- Hero Section -->
        <section class="hero">
            <div class="container">
                <div class="hero-content">
                    <div class="badge">🚀 Quản lý công việc hiệu quả</div>
                    <h1 class="hero-title">
                        Quản lý công việc và ghi chú với 
                        <span class="gradient-text">BeeTask</span>
                    </h1>
                    <p class="hero-description">
                        Tương tự như Trello, BeeTask giúp bạn tổ chức công việc một cách trực quan và hiệu quả.
                    </p>
                    <div class="hero-buttons">
                        <button class="btn btn-primary btn-large">Bắt đầu miễn phí <i class="fas fa-arrow-right"></i></button>
                        <button class="btn btn-outline btn-large">Xem demo</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- Templates Section -->
        <section class="templates">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Template mẫu</h2>
                    <p class="section-description">
                        Bắt đầu nhanh chóng với các template được thiết kế sẵn cho nhiều mục đích khác nhau
                    </p>
                </div>

                <div class="templates-grid">
                    <%
                        List<Template> templates = (List<Template>) request.getAttribute("templates");
                        if (templates != null) {
                            for (Template template : templates) {
                                String thumb = (template.getThumbnailUrl() != null && !template.getThumbnailUrl().isEmpty())
                                        ? template.getThumbnailUrl()
                                        : "https://via.placeholder.com/300x200";
                    %>
                    <div class="template-card">
                        <div class="template-image">
                            <img src="<%= thumb %>" alt="<%= template.getName() %>">
                        </div>
                        <div class="template-content">
                            <div class="template-category"><%= template.getCategory() %></div>
                            <h3 class="template-title"><%= template.getName() %></h3>
                            <p class="template-description"><%= template.getDescription() %></p>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>

                <div class="view-all">
                    <button class="btn btn-outline btn-large">
                        Xem tất cả Template <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta">
            <div class="container">
                <div class="cta-content">
                    <h2 class="cta-title">Sẵn sàng bắt đầu với BeeTask?</h2>
                    <p class="cta-description">
                        Tham gia cùng hàng nghìn người dùng đang quản lý công việc hiệu quả với BeeTask
                    </p>
                    <div class="cta-buttons">
                        <button class="btn btn-white btn-large">Đăng ký miễn phí <i class="fas fa-arrow-right"></i></button>
                        <button class="btn btn-outline-white btn-large">Liên hệ tư vấn</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-logo">
                        <div class="logo-icon">B</div>
                        <span class="logo-text">BeeTask</span>
                    </div>
                    <p class="footer-description">Quản lý công việc và ghi chú hiệu quả</p>
                    <div class="footer-links">
                        <a href="#">Về chúng tôi</a>
                        <a href="#">Tính năng</a>
                        <a href="#">Hỗ trợ</a>
                        <a href="#">Liên hệ</a>
                    </div>
                    <div class="footer-copyright">
                        © 2024 BeeTask. Tất cả quyền được bảo lưu.
                    </div>
                </div>
            </div>
        </footer>
        <script src="${pageContext.request.contextPath}/LandingPage.js"></script>
    </body>
</html>
