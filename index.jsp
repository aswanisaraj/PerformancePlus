<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>PerformancePlus | Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Matches the dashboard header color from your UI */
        body { background-color: #f8f9fa; height: 100vh; display: flex; align-items: center; }
        .login-card { width: 100%; max-width: 400px; padding: 15px; margin: auto; }
        .card-header { background-color: #212529; color: white; border-radius: 8px 8px 0 0 !important; }
        .btn-primary { background-color: #212529; border: none; }
        .btn-primary:hover { background-color: #343a40; }
    </style>
</head>
<body>
    <div class="login-card">
        <p class="text-center mb-3"><b>Access the system as an ADMIN, MANAGER, or EMPLOYEE.</b></p>
        
        <div class="card shadow-sm border-0">
            <div class="card-header text-center py-3">
                <h4 class="mb-0">PerformancePlus</h4>
            </div>
            <div class="card-body p-4">
                <% String error = request.getParameter("error"); 
                   if(error != null) { %>
                    <div class="alert alert-danger p-2 small"><%= error %></div>
                <% } %>
                
                <form action="login" method="post">
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" placeholder="Enter your username" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 py-2">Sign In</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>