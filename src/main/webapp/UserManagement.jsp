
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="UserManagement.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="admin-container">
    <aside class="sidebar">
        <h2>SystemAdmin</h2>
        <div class="admin-info">
            <i class="fas fa-user-shield avatar"></i>
            <p>Admin</p>
            <small>Quản trị hệ thống</small>
        </div>
        <ul class="nav-links">
            <li><a href="SystemAdmin.jsp"><i class="fas fa-chart-line"></i> Dashboard</a></li>
            <li class="active"><i class="fas fa-users"></i> User Management</li>
        </ul>
    </aside>

    <main class="main-content">
        <h1>Quản lý người dùng</h1>

        <!-- Tìm kiếm người dùng -->
        <div class="search-box">
            <form action="UserManagementServlet" method="get">
                <%
                    String keyword = (String) request.getAttribute("keyword");
                    if (keyword == null) keyword = "";
                %>
                <input type="text" name="keyword" placeholder="Tìm theo ID, tên, email..." value="<%= keyword %>">
                <button type="submit">Tìm kiếm</button>
            </form>
        </div>

        <!-- Khóa/Mở tài khoản -->
        <section id="account-actions">
            <h2>Khóa hoặc Mở tài khoản</h2>
            <form action="UserManagementServlet" method="post">
                <input type="text" name="userId" placeholder="Nhập User ID">
                <select name="action">
                    <option value="lock">Khóa tài khoản</option>
                    <option value="unlock">Mở tài khoản</option>
                </select>
                <button type="submit">Thực hiện</button>
            </form>
        </section>

        <!-- Danh sách người dùng bị khóa -->
        <section id="locked">
            <h2>Người dùng bị khóa</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Ngày tạo</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<User> lockedUsers = (List<User>) request.getAttribute("lockedUsers");
                        if (lockedUsers != null) {
                            for (User user : lockedUsers) {
                    %>
                    <tr>
                        <td><%= user.getUserId() %></td>
                        <td><%= user.getUsername() %></td>
                        <td><%= user.getEmail() %></td>
                        <td><%= user.getCreatedAt() %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </section>

        <!-- Danh sách người dùng -->
        <section id="all-users">
            <h2>Danh sách người dùng</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Ngày tạo</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<User> allUsers = (List<User>) request.getAttribute("allUsers");
                        if (allUsers != null) {
                            for (User user : allUsers) {
                    %>
                    <tr>
                        <td><%= user.getUserId() %></td>
                        <td><%= user.getUsername() %></td>
                        <td><%= user.getEmail() %></td>
                        <td><%= user.getCreatedAt() %></td>
                        <td>
                            <%= user.isActive() ? "Đang hoạt động" : "Bị khóa" %>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>


<%-- <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="UserManagement.css">
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    
    
    
</head>
<body>
<div class="admin-container">
    <aside class="sidebar">
        <h2>SystemAdmin</h2>
        
         <div class="admin-info">
                    <i class="fas fa-user-shield avatar"></i>
                    <p>Admin</p>
                    <small>Quản trị hệ thống</small>
                </div>
        
        
        <ul class="nav-links">
            <li><a href="SystemAdmin.jsp"><i class="fas fa-chart-line"></i> Dashboard</a></li>
            <li class="active"><i class="fas fa-users"></i> Quản lý người dùng</li>
        </ul>
    </aside>

    <main class="main-content">
        <h1>Quản lý người dùng</h1>

        <!-- Tìm kiếm người dùng -->
        <div class="search-box">
            <form action="UserManagement.jsp" method="get">
                <input type="text" name="keyword" placeholder="Tìm theo ID, tên, email...">
                <button type="submit">Tìm kiếm</button>
            </form>
        </div>

        <!-- Khóa/Mở tài khoản -->
        <section id="account-actions">
            <h2>Khóa hoặc Mở tài khoản</h2>
            <form action="UserActionServlet" method="post">
                <input type="text" name="userId" placeholder="Nhập User ID">
                <select name="action">
                    <option value="lock">Khóa tài khoản</option>
                    <option value="unlock">Mở tài khoản</option>
                </select>
                <button type="submit">Thực hiện</button>
            </form>
        </section>

        <!-- Danh sách người dùng bị khóa -->
        <section id="locked">
            <h2>Người dùng bị khóa</h2>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Ngày tạo</th>
                </tr>
                </thead>
                <tbody>
                <!-- Dữ liệu từ servlet hoặc JSTL -->
                </tbody>
            </table>
        </section>

        <!-- Danh sách người dùng -->
        <section id="all-users">
            <h2>Danh sách người dùng</h2>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Ngày tạo</th>
                    <th>Dự án</th>
                    <th>Vai trò</th>
                </tr>
                </thead>
                <tbody>
                <!-- Dữ liệu người dùng -->
                </tbody>
            </table>
        </section>
    </main>
</div>
</body>
</html>
--%>

