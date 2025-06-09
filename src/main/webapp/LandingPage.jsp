<%-- 
    Document   : LandingPage
    Created on : 8 thg 6, 2025, 10:53:59
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BeeTask - Quản lý công việc và ghi chú</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="LandingPage.css">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <!-- Logo -->
                <div class="logo">
                    <div class="logo-icon">B</div>
                    <span class="logo-text">BeeTask</span>
                </div>

                <!-- Search Bar -->
                <div class="search-container">
                    <div class="search-box">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" placeholder="Tìm kiếm templates..." class="search-input">
                    </div>
                </div>

                <!-- Auth Buttons -->
                <div class="auth-buttons">
                    <button class="btn btn-ghost">
                        <i class="fas fa-sign-in-alt"></i>
                        Đăng nhập
                    </button>
                    <button class="btn btn-primary">
                        <i class="fas fa-user-plus"></i>
                        Đăng ký
                    </button>
                </div>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <div class="hero-content">
                <div class="badge">
                    🚀 Quản lý công việc hiệu quả
                </div>
                <h1 class="hero-title">
                    Quản lý công việc và ghi chú với 
                    <span class="gradient-text">BeeTask</span>
                </h1>
                <p class="hero-description">
                    Tương tự như Trello, BeeTask giúp bạn tổ chức công việc một cách trực quan và hiệu quả. 
                    Bắt đầu với các template có sẵn hoặc tạo board của riêng bạn.
                </p>
                <div class="hero-buttons">
                    <button class="btn btn-primary btn-large">
                        Bắt đầu miễn phí
                        <i class="fas fa-arrow-right"></i>
                    </button>
                    <button class="btn btn-outline btn-large">
                        Xem demo
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Tại sao chọn BeeTask?</h2>
                <p class="section-description">
                    Những tính năng mạnh mẽ giúp bạn quản lý công việc hiệu quả hơn
                </p>
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h3 class="feature-title">Task Management</h3>
                    <p class="feature-description">Organize and track your tasks efficiently</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3 class="feature-title">Team Collaboration</h3>
                    <p class="feature-description">Work together seamlessly with your team</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <h3 class="feature-title">Fast & Intuitive</h3>
                    <p class="feature-description">Lightning-fast performance with intuitive design</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3 class="feature-title">Secure & Reliable</h3>
                    <p class="feature-description">Your data is safe and always accessible</p>
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
                <div class="template-card">
                    <div class="template-image">
                        <img src="https://via.placeholder.com/300x200/4F46E5/FFFFFF?text=Kanban" alt="Kanban Template">
                    </div>
                    <div class="template-content">
                        <div class="template-category">Project Management</div>
                        <h3 class="template-title">Kanban Template</h3>
                        <p class="template-description">Organize tasks with visual boards</p>
                    </div>
                </div>

                <div class="template-card">
                    <div class="template-image">
                        <img src="https://via.placeholder.com/300x200/7C3AED/FFFFFF?text=To+Do" alt="To Do Template">
                    </div>
                    <div class="template-content">
                        <div class="template-category">Personal</div>
                        <h3 class="template-title">To Do Template</h3>
                        <p class="template-description">Simple task management</p>
                    </div>
                </div>

                <div class="template-card">
                    <div class="template-image">
                        <img src="https://via.placeholder.com/300x200/059669/FFFFFF?text=V+Model" alt="V Model Template">
                    </div>
                    <div class="template-content">
                        <div class="template-category">Development</div>
                        <h3 class="template-title">V Model Template</h3>
                        <p class="template-description">Software development lifecycle</p>
                    </div>
                </div>

                <div class="template-card">
                    <div class="template-image">
                        <img src="https://via.placeholder.com/300x200/DC2626/FFFFFF?text=Agile" alt="Agile Template">
                    </div>
                    <div class="template-content">
                        <div class="template-category">Development</div>
                        <h3 class="template-title">Agile Template</h3>
                        <p class="template-description">Agile project methodology</p>
                    </div>
                </div>

                <div class="template-card">
                    <div class="template-image">
                        <img src="https://via.placeholder.com/300x200/0891B2/FFFFFF?text=Waterfall" alt="Waterfall Template">
                    </div>
                    <div class="template-content">
                        <div class="template-category">Development</div>
                        <h3 class="template-title">Waterfall Template</h3>
                        <p class="template-description">Sequential project phases</p>
                    </div>
                </div>

                <div class="template-card">
                    <div class="template-image">
                        <img src="https://via.placeholder.com/300x200/7C2D12/FFFFFF?text=Scrum" alt="Scrum Template">
                    </div>
                    <div class="template-content">
                        <div class="template-category">Development</div>
                        <h3 class="template-title">Scrum Template</h3>
                        <p class="template-description">Sprint-based development</p>
                    </div>
                </div>
            </div>

            <div class="view-all">
                <button class="btn btn-outline btn-large">
                    Xem tất cả Template
                    <i class="fas fa-arrow-right"></i>
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
                    <button class="btn btn-white btn-large">
                        Đăng ký miễn phí
                        <i class="fas fa-arrow-right"></i>
                    </button>
                    <button class="btn btn-outline-white btn-large">
                        Liên hệ tư vấn
                    </button>
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

    <script src="LandingPage.js"></script>
</body>
</html>
