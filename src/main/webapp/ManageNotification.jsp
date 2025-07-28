<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="./Header.jsp"%>
        <title>Manage Notifications</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ManageNotification.css">
    </head>
    <body class="dashboard-body">
        <div class="dashboard-container">
            <!-- Sidebar -->
            <%@include file="./Sidebar.jsp"%>

            <main class="main-content">

                <h2>Manage Project Notifications</h2>

                <!-- Container where notifications will be inserted -->
                <div id="projectNotificationsWrapper">
                    <!-- JS will populate this with grouped project notifications -->
                </div>
                <div id="addNotificationModal" class="modal hidden">
                    <div class="modal-content">
                        <span id="closeModal" class="close-button">&times;</span>
                        <h3 id="modalTitle">Add Notification</h3>
                        <form id="addNotificationForm">
                            <input type="hidden" id="modalProjectId" />
                            <input type="hidden" id="editingNotificationId" />
                            <label for="notificationMessage">Message:</label>
                            <textarea id="notificationMessage" rows="5" required></textarea>
                            <button type="submit" id="submitButton">Add</button>
                        </form>
                    </div>
                </div>
            </main>
        </div>
        <script src="${pageContext.request.contextPath}/ManageNotification.js"></script>
    </body>
</html>
