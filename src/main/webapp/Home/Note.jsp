<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <title>My notes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Home/Note.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<jsp:include page="/Header.jsp"/>

<div class="container">
    <aside class="sidebar">
        <%@ include file="../Sidebar.jsp" %>
        
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
            <h1 class="notes-title"><i class="fas fa-sticky-note"></i> My notes</h1>
            <div class="header-actions">
                <button id="add-note-btn" class="add-note-btn">
                    <i class="fas fa-plus"></i> Add notes
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
                            <h3>No notes</h3>
                            <p>Click "Add Note" to begin.</p>
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
    <div class="context-menu-item" data-action="setLabel"><i class="fas fa-tag"></i> Select label</div>
    <div class="context-menu-item" data-action="setDeadline"><i class="fas fa-clock"></i> Add deadlines</div>
    <div class="context-menu-divider"></div>
    <div class="context-menu-item danger" data-action="delete"><i class="fas fa-trash"></i> Delete notes</div>
</div>

<!-- Label Modal -->
<div id="label-modal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Select or create a label</h3>
            <button id="close-label-modal" class="close-btn">&times;</button>
        </div>
        <div class="label-options">
            <!-- Labels từ database sẽ được load ở đây -->
        </div>
        <div class="section-divider"></div>
        <div class="add-label-section">
            <div class="new-label-form">
                <input type="text" id="new-label-name" placeholder="Label name" class="form-input">
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
                <button id="create-label-btn" class="btn-primary">Create labels</button>
            </div>
        </div>
    </div>
</div>

<!-- Deadline Modal -->
<div id="deadline-modal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Choose a deadline</h3>
            <button id="close-deadline-modal" class="close-btn">&times;</button>
        </div>
        <div class="form-group">
            <label>Day:</label>
            <input type="date" id="deadline-date" class="form-input">
        </div>
        <div class="form-group">
            <label>Time:</label>
            <input type="time" id="deadline-time" class="form-input">
        </div>
        <div class="quick-deadline-options">
            <label>Quick options:</label>
            <div class="quick-options">
                <div class="quick-option" data-hours="3">+3 hours</div>
                <div class="quick-option" data-days="1">+1 day</div>
                <div class="quick-option" data-days="7">+1 week</div>
            </div>
        </div>
        <div class="deadline-actions">
            <button id="save-deadline" class="btn-primary">Save</button>
            <button id="remove-deadline" class="btn-secondary">Delete</button>
        </div>
    </div>
</div>

<!-- Delete Modal -->
<div id="delete-modal" class="modal-overlay">
    <div class="modal-content delete-modal-content">
        <div class="modal-header">
            <h3>Confirm deletion</h3>
            <button id="close-delete-modal" class="close-btn">&times;</button>
        </div>
        <div class="delete-confirmation">
            <i class="fas fa-exclamation-triangle delete-icon"></i>
            <p class="delete-warning">Are you sure you want to delete this note?</p>
        </div>
        <div class="delete-actions">
            <button id="cancel-delete" class="btn-secondary">Cancel</button>
            <button id="confirm-delete" class="btn-danger">Delete</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/Home/Note.js"></script>
</body>
</html>
