<button class="toggle-btn"><i class="fas fa-bars"></i></button>
<% String uri = request.getRequestURI();%>
<ul class="menu">
    <li <% if (uri.endsWith("/Home.jsp")) { %> class ="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/Home.jsp">
            <i class="fas fa-home"></i><span>Home</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/Templates.jsp")) { %> class ="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/Templates.jsp">
            <i class="fas fa-copy"></i><span>Templates</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/CalendarHome.jsp")) { %> class ="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/CalendarHome.jsp">
            <i class="fas fa-calendar-day"></i><span>Today</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/Table.jsp")) { %> class ="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/Table.jsp">
            <i class="fas fa-calendar-alt"></i><span>Calendar</span>
        </a>
    </li>
    <li <% if (uri.endsWith("/Setting.jsp")) { %> class ="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Home/Setting.jsp">
            <i class="fas fa-cog"></i><span>Setting</span>
        </a>
    </li>
</ul>