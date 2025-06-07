<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng - Admin</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #0e101a;
            color: white;
            display: flex;
            height: 100vh;
        }
        .container {
            display: flex;
            width: 100%;
        }
        .sidebar {
            width: 220px;
            background: #1a1d2e;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .sidebar-header h2 {
            margin: 0;
            font-size: 20px;
            color: #f97316;
        }
        .sidebar-header p {
            margin: 5px 0 20px;
            font-size: 13px;
            color: #aaa;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
        }
        .sidebar ul li {
            margin-bottom: 15px;
        }
        .sidebar ul li a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 8px 12px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .sidebar ul li.active a,
        .sidebar ul li a:hover {
            background-color: #f97316;
        }
        .sidebar-footer {
            margin-top: auto;
        }
        .sidebar-footer a {
            color: #ccc;
            text-decoration: none;
            font-size: 14px;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            background: #131624;
            overflow-y: auto;
        }
        .main-header h1 {
            margin-bottom: 20px;
        }
        .user-table table {
            width: 100%;
            border-collapse: collapse;
            background: #1e2235;
            border-radius: 10px;
            overflow: hidden;
        }
        .user-table th, .user-table td {
            padding: 12px 16px;
            border-bottom: 1px solid #2a2d42;
            text-align: left;
        }
        .user-table th {
            background: #2c314d;
            color: #f3f3f3;
        }
        .user-table tr:hover {
            background-color: #262c49;
        }
        .status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status.active {
            background-color: #10b981;
            color: white;
        }
        .status.locked {
            background-color: #ef4444;
            color: white;
        }
        .lock-btn {
            padding: 6px 10px;
            border: none;
            border-radius: 4px;
            background-color: #f97316;
            color: white;
            cursor: pointer;
            font-size: 13px;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>AdminPanel</h2>
            <p>Quản trị hệ thống</p>
        </div>
        <ul>
            <li><a href="dashboard.jsp">📊 Dashboard</a></li>
            <li class="active"><a href="user-management.jsp">👥 Quản lý người dùng</a></li>
        </ul>
        <div class="sidebar-footer">
            <a href="#">🔓 Đăng xuất</a>
        </div>
    </aside>

    <!-- Main -->
    <main class="main-content">
        <header class="main-header">
            <h1>Quản lý người dùng</h1>
        </header>

        <section class="user-table">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tên người dùng</th>
                        <th>Email</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody id="user-list">
                    <!-- Sẽ được render bằng JS -->
                </tbody>
            </table>
        </section>
    </main>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const users = [
            { id: 1, name: "Nguyễn Văn A", email: "vana@example.com", locked: false },
            { id: 2, name: "Trần Thị B", email: "thib@example.com", locked: true },
            { id: 3, name: "Lê Hữu C", email: "huuc@example.com", locked: false }
        ];

        const userList = document.getElementById("user-list");

        function renderUsers() {
            userList.innerHTML = "";
            users.forEach(user => {
                const tr = document.createElement("tr");
                tr.innerHTML = `
                    <td>${user.id}</td>
                    <td>${user.name}</td>
                    <td>${user.email}</td>
                    <td><span class="status ${user.locked ? 'locked' : 'active'}">
                        ${user.locked ? 'Đã khoá' : 'Đang hoạt động'}
                    </span></td>
                    <td>
                        <button class="lock-btn" data-id="${user.id}">
                            ${user.locked ? 'Mở khoá' : 'Khoá'}
                        </button>
                    </td>
                `;
                userList.appendChild(tr);
            });

            document.querySelectorAll(".lock-btn").forEach(btn => {
                btn.addEventListener("click", () => {
                    const id = parseInt(btn.dataset.id);
                    const user = users.find(u => u.id === id);
                    user.locked = !user.locked;
                    renderUsers();
                });
            });
        }

        renderUsers();
    });
</script>
</body>
</html>
