<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Audit Logs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-5">
    <h3>System Audit Logs</h3>
    <table class="table table-bordered bg-white">
        <thead class="table-dark">
            <tr><th>Log ID</th><th>Action</th><th>Time</th></tr>
        </thead>
        <tbody>
            <% 
                List<Map<String, Object>> logs = (List<Map<String, Object>>) session.getAttribute("auditLogList");
                if(logs != null) {
                    for(Map<String, Object> log : logs) {
            %>
                <tr>
                    <td><%= log.get("log_id") %></td>
                    <td><%= log.get("action") %></td>
                    <td><%= log.get("timestamp") %></td>
                </tr>
            <% }} %>
        </tbody>
    </table>
    <a href="dashboard.jsp" class="btn btn-secondary">Back</a>
</body>
</html>