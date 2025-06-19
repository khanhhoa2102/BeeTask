<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>BeeTask - Task</title>
    <link rel="stylesheet" href="css/task.css">
</head>
<body>

<h2 style="color: white; text-align: center; margin-top: 20px;">Tên Project</h2>

<!-- ========== Kanban Board ========== -->
<div class="project-dashboard">
    <div class="task-status-container">

        <!-- To Do -->
        <div class="task-column">
            <h3>To Do (<c:out value="${fn:length(toDoList)}" />)</h3>
            <c:forEach var="task" items="${toDoList}">
                <div class="task-card">
                    <div class="title-menu-wrapper">
                        <p class="task-title">${task.title}</p>
                        <button class="menu-dot">⋮</button>
                    </div>
                    <p class="task-date">${task.dueDate}</p>
                    <c:if test="${not empty task.imageUrl}">
                        <img src="${task.imageUrl}" alt="task image">
                    </c:if>
                </div>
            </c:forEach>
        </div>

        <!-- In Progress -->
        <div class="task-column">
            <h3>In Progress (<c:out value="${fn:length(inProgressList)}" />)</h3>
            <c:forEach var="task" items="${inProgressList}">
                <div class="task-card">
                    <div class="title-menu-wrapper">
                        <p class="task-title">${task.title}</p>
                        <button class="menu-dot">⋮</button>
                    </div>
                    <p class="task-date">${task.dueDate}</p>
                </div>
            </c:forEach>
        </div>

        <!-- Done -->
        <div class="task-column">
            <h3>Done (<c:out value="${fn:length(doneList)}" />)</h3>
            <c:forEach var="task" items="${doneList}">
                <div class="task-card">
                    <div class="title-menu-wrapper">
                        <p class="task-title">${task.title}</p>
                        <button class="menu-dot">⋮</button>
                    </div>
                    <p class="task-date">${task.dueDate}</p>
                    <c:if test="${not empty task.imageUrl}">
                        <img src="${task.imageUrl}" alt="task image">
                    </c:if>
                </div>
            </c:forEach>
        </div>

    </div>

    <!-- ========== Task Table ========== -->
    <div class="tasks-overview">
        <h2 style="color: white; margin-left: 10px;">Tasks</h2>
        <table class="task-list">
            <thead>
                <tr class="task-row">
                    <th class="task-cell">Tasks</th>
                    <th class="task-cell">Deadline</th>
                    <th class="task-cell">Priority</th>
                    <th class="task-cell">Suggested Time</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="task" items="${taskList}">
                <tr class="task-row">
                    <td class="task-cell">${task.title}</td>
                    <td class="task-cell">${task.dueDate}</td>
                    <td class="task-cell priority">
                        <c:choose>
                            <c:when test="${task.priority eq 'High'}">
                                <span class="priority hight">High</span>
                            </c:when>
                            <c:when test="${task.priority eq 'Medium'}">
                                <span class="priority medium">Medium</span>
                            </c:when>
                            <c:otherwise>
                                <span class="priority low">Low</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="task-cell">Thu 8:00 - 10PM</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
