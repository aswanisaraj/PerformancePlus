<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users | PerformancePlus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-5">
    <div class="container card shadow p-4">
        <h3 class="mb-4">User Management</h3>
        <table class="table table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Name</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Map<String, Object>> users = (List<Map<String, Object>>) session.getAttribute("managementUserList");
                    if(users != null) {
                        for(Map<String, Object> u : users) {
                %>
                    <tr>
                        <td><%= u.get("user_id") %></td>
                        <td><%= u.get("username") %></td>
                        <td><%= u.get("full_name") %></td>
                        <td><span class="badge bg-primary"><%= u.get("role_name") %></span></td>
                        <td>
                            <form action="DeleteUserServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this user?');">
                                <input type="hidden" name="userId" value="<%= u.get("user_id") %>">
                                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% }} %>
            </tbody>
        </table>
        <div class="mt-3">
            <a href="dashboard.jsp" class="btn btn-secondary">Back</a>
        </div>
    </div>
</body>
</html>