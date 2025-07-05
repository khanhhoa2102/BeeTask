<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="./Header.jsp"%>
        <title>VIP account</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/VIP.css">
    </head>
    <body class="dashboard-body">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="user-profile">
                    <div class="avatar">
                        <% if (headerUser.getAvatarUrl() != null && !headerUser.getAvatarUrl().isEmpty()) { %>
                        <img src="<%= headerUser.getAvatarUrl() %>" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%;">
                        <% } else { %>
                        <div style="width: 40px; height: 40px; border-radius: 50%; background-color: #ccc;"></div>
                        <% } %>
                    </div>
                    <div class="info">
                        <span class="username"><%= headerUser.getUsername() %></span>
                        <span class="email"><%= headerUser.getEmail() %></span>
                    </div>
                </div>

                <%@include file="./Sidebar.jsp"%>
                <%@include file="./Help.jsp" %>
            </aside>
            <main class="main-content">
                <div class="main-box">
                    <div class="checkout">
                        <div class="product">
                            <p><strong>Tên sản phẩm:</strong>Tài khoản VIP</p>
                            <p><strong>Giá tiền:</strong> 2000 VNĐ</p>
                            <p><strong>Số lượng:</strong> 1</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/payment" method="post">
                            <button type="submit" id="create-payment-link-btn">
                                Tạo Link thanh toán
                            </button>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>
