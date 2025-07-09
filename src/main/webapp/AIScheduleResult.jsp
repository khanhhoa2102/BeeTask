<%@ page import="org.json.JSONObject" %>
<%
    JSONObject result = (JSONObject) request.getAttribute("aiResult");
%>

<h2>? G?i ý t? AI Agent</h2>
<ul>
  <li><strong>Start:</strong> <%= result.getString("suggestedStart") %></li>
  <li><strong>End:</strong> <%= result.getString("suggestedEnd") %></li>
  <li><strong>Confidence:</strong> <%= result.getDouble("confidence") * 100 %> %</li>
</ul>
