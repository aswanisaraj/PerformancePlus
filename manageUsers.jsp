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
        
        <!-- Add New User Form -->
        <div class="card mb-4 bg-white border-primary">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0">Add New User</h5>
            </div>
            <div class="card-body">
                <form action="login" method="post">
                    <input type="hidden" name="action" value="addUser">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label for="newUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="newUsername" name="newUsername" required>
                        </div>
                        <div class="col-md-3">
                            <label for="newPassword" class="form-label">Password</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="col-md-3">
                            <label for="newFullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="newFullName" name="newFullName" required>
                        </div>
                        <div class="col-md-2">
                            <label for="newRoleId" class="form-label">Role</label>
                            <select class="form-select" id="newRoleId" name="newRoleId" required>
                                <option value="">Select Role</option>
                                <option value="2">Manager</option>
                                <option value="3">Employee</option>
                            </select>
                        </div>
                        <div class="col-md-1 d-flex align-items-end">
                            <button type="submit" class="btn btn-success w-100">Add User</button>
                        </div>
                    </div>
                </form>
                <% 
                    String msg = request.getParameter("msg");
                    if("UserCreated".equals(msg)) {
                %>
                    <div class="alert alert-success mt-3 mb-0">User created successfully!</div>
                <% } %>
            </div>
        </div>

        <h5 class="mb-3">Existing Users</h5>
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