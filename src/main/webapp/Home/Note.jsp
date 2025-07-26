<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Ghi chú của tôi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Home/Note.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<jsp:include page="/Header.jsp"/>

<div class="container">
    <aside class="sidebar">
        <div class="user-profile">
            <button class="icon-btn">
                <img src="../Asset/Longlogo.png" alt="BeeTask Logo">
            </button>
        </div>
        <%@ include file="../Sidebar.jsp" %>
        <%@ include file="../Help.jsp" %>
    </aside>

    <main class="main-content">

        <c:if test="${not empty error}">
            <div style="background-color: #ffe6e6; color: #cc0000; padding: 10px; border: 1px solid #cc0000; margin-bottom: 10px; border-radius: 5px;">
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty info}">
            <div style="background-color: #e6f7ff; color: #005580; padding: 10px; border: 1px solid #005580; margin-bottom: 10px; border-radius: 5px;">
                ${info}
            </div>
        </c:if>

        <div class="notes-header">
            <h1 class="notes-title"><i class="fas fa-sticky-note"></i> Ghi chú của tôi</h1>
            <div class="header-actions">
                <button id="add-note-btn" class="add-note-btn">
                    <i class="fas fa-plus"></i> Thêm ghi chú
                </button>
            </div>
        </div>

        <div class="notes-container">
            <div class="notes-list" id="notes-list">
                <c:choose>
                    <c:when test="${not empty notes}">
                        <c:forEach var="note" items="${notes}">
                            <div class="note-item" data-id="${note.noteId}">
                                <div class="note-checkbox-wrapper">
                                </div>
                                <div class="note-content" data-editable="true">
                                    <span class="note-text">${note.title}</span>
                                    <p class="note-description">${note.content}</p>
                                    <div class="note-meta">
                                        <div class="note-labels">
                                            <c:if test="${not empty note.labelName}">
                                                <span class="note-label" data-color="${note.labelColor}">
                                                    <span class="label-dot" style="background-color:${note.labelColor}"></span>
                                                    ${note.labelName}
                                                </span>
                                            </c:if>
                                        </div>
                                        <div class="note-dates">
                                            <span class="note-created">
                                                <i class="fas fa-calendar-plus"></i>
                                                <fmt:formatDate value="${note.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                            <c:if test="${not empty note.deadline}">
                                                <span class="note-deadline" data-deadline="${note.deadline}">
                                                    <i class="fas fa-clock"></i>
                                                    <fmt:formatDate value="${note.deadline}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                <div class="note-actions">
                                    <button class="menu-btn" data-note-id="${note.noteId}">
                                        <i class="fas fa-ellipsis-h"></i>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div id="empty-state">
                            <i class="fas fa-sticky-note empty-icon"></i>
                            <h3>Không có ghi chú nào</h3>
                            <p>Nhấn "Thêm ghi chú" để bắt đầu.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <input type="hidden" id="userId" value="${sessionScope.userId}">
    </main>
</div>

<!-- Context Menu -->
<div id="context-menu" class="context-menu">
    <div class="context-menu-item" data-action="setLabel"><i class="fas fa-tag"></i> Chọn nhãn</div>
    <div class="context-menu-item" data-action="setDeadline"><i class="fas fa-clock"></i> Thêm deadline</div>
    <div class="context-menu-divider"></div>
    <div class="context-menu-item danger" data-action="delete"><i class="fas fa-trash"></i> Xóa ghi chú</div>
</div>

<!-- Label Modal -->
<div id="label-modal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Chọn hoặc tạo nhãn</h3>
            <button id="close-label-modal" class="close-btn">&times;</button>
        </div>
        <div class="label-options">
            <!-- Labels từ database sẽ được load ở đây -->
        </div>
        <div class="section-divider"></div>
        <div class="add-label-section">
            <div class="new-label-form">
                <input type="text" id="new-label-name" placeholder="Tên nhãn" class="form-input">
                <div class="color-picker">
                    <div class="color-option selected" data-color="#FFD700" style="background-color: #FFD700;"></div> <!-- yellow -->
                    <div class="color-option" data-color="#FF0000" style="background-color: #FF0000;"></div> <!-- red -->
                    <div class="color-option" data-color="#008000" style="background-color: #008000;"></div> <!-- green -->
                    <div class="color-option" data-color="#FFA500" style="background-color: #FFA500;"></div> <!-- orange -->
                    <div class="color-option" data-color="#8B0000" style="background-color: #8B0000;"></div> <!-- darkred -->
                    <div class="color-option" data-color="#DC143C" style="background-color: #DC143C;"></div> <!-- crimson -->
                    <div class="color-option" data-color="#0000FF" style="background-color: #0000FF;"></div> <!-- blue -->
                    <div class="color-option" data-color="#A52A2A" style="background-color: #A52A2A;"></div> <!-- brown -->
                </div>
                <button id="create-label-btn" class="btn-primary">Tạo nhãn</button>
            </div>
        </div>
    </div>
</div>

<!-- Deadline Modal -->
<div id="deadline-modal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Chọn thời hạn</h3>
            <button id="close-deadline-modal" class="close-btn">&times;</button>
        </div>
        <div class="form-group">
            <label>Ngày:</label>
            <input type="date" id="deadline-date" class="form-input">
        </div>
        <div class="form-group">
            <label>Giờ:</label>
            <input type="time" id="deadline-time" class="form-input">
        </div>
        <div class="quick-deadline-options">
            <label>Tùy chọn nhanh:</label>
            <div class="quick-options">
                <div class="quick-option" data-hours="3">+3 giờ</div>
                <div class="quick-option" data-days="1">+1 ngày</div>
                <div class="quick-option" data-days="7">+1 tuần</div>
            </div>
        </div>
        <div class="deadline-actions">
            <button id="save-deadline" class="btn-primary">Lưu</button>
            <button id="remove-deadline" class="btn-secondary">Xóa</button>
        </div>
    </div>
</div>

<!-- Delete Modal -->
<div id="delete-modal" class="modal-overlay">
    <div class="modal-content delete-modal-content">
        <div class="modal-header">
            <h3>Xác nhận xóa</h3>
            <button id="close-delete-modal" class="close-btn">&times;</button>
        </div>
        <div class="delete-confirmation">
            <i class="fas fa-exclamation-triangle delete-icon"></i>
            <p class="delete-warning">Bạn có chắc muốn xóa ghi chú này?</p>
        </div>
        <div class="delete-actions">
            <button id="cancel-delete" class="btn-secondary">Hủy</button>
            <button id="confirm-delete" class="btn-danger">Xóa</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/Home/Note.js"></script>
</body>
</html>
