<button class="toggle-btn"><i class="fas fa-bars"></i></button>
<% String uri = request.getRequestURI(); %>
<ul class="menu">
    <li <% if (uri.endsWith("/Home.jsp")) { %> class="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/Home.jsp">
            <i class="fas fa-home"></i><span>Home</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/projects.jsp")) { %> class="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Projects.jsp">
            <i class="fas fa-folder-open"></i><span>Projects</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/Templates.jsp")) { %> class="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/Templates.jsp">
            <i class="fas fa-copy"></i><span>Templates</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/CalendarHome.jsp")) { %> class="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/CalendarHome.jsp">
            <i class="fas fa-calendar-day"></i><span>Today</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/Table.jsp")) { %> class="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/Table.jsp">
            <i class="fas fa-calendar-alt"></i><span>Calendar</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/Note.jsp")) { %> class ="active" <% } %>>
        <a href="${pageContext.request.contextPath}/notes">
            <i class="fas fa-calendar-alt"></i><span>Note</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/leaderstaticservlet")) { %> class="active" <% } %>>
        <a href="${pageContext.request.contextPath}/leaderstaticservlet">
            <i class="fas fa-chart-bar"></i><span>Statistics</span>
        </a>
    </li>

    <% if (user != null && "Admin".equalsIgnoreCase(user.getRole())) { %>
        <li <% if (uri.endsWith("/SystemAdmin.jsp")) { %> class="active" <% } %>> 
            <a href="${pageContext.request.contextPath}/Admin/SystemAdmin.jsp">
                <i class="fas fa-chart-line"></i><span>Administrator</span>
            </a>
        </li>
    <% } %>
    
    <li <% if (uri.endsWith("/Setting.jsp")) { %> class="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/Setting.jsp">
            <i class="fas fa-cog"></i><span>Setting</span>
        </a>
    </li>
</ul>
