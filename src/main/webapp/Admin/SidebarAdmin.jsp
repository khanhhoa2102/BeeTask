<button class="toggle-btn"><i class="fas fa-bars"></i></button>
    <% String uri = request.getRequestURI(); %>
<ul class="menu">
    <li <% if (uri.endsWith("/SystemAdmin.jsp")) { %> class="active" <% } %>>
        <a href="${pageContext.request.contextPath}/admin/user-stats">
            <i class="fas fa-home"></i><span>Dashboard</span>
        </a>
    </li>
    
    
     <li <% if (uri.endsWith("/UserManagementServlet")) { %> class="active" <% } %>>
    <a href="${pageContext.request.contextPath}/UserManagementServlet">
        <i class="fas fa-user-cog"></i><span>User Management</span>
    </a>
</li>





<li <% if (uri.endsWith("/allprojects")) { %> class="active" <% } %>>
    <a href="${pageContext.request.contextPath}/allprojects">
        <i class="fas fa-diagram-project"></i><span>Projects Management</span>
    </a>
</li>




    <li <% if (uri.endsWith("/Templates.jsp")) { %> class="active" <% } %>>
        <a href="${pageContext.request.contextPath}/Admin/ManagementTemplates.jsp">
            <i class="fas fa-copy"></i><span>Templates Management</span>
        </a>
    </li>
    
 
    
    
    
</ul>