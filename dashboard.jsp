<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security Check: Ensure user is logged in
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("userRole");

    if (username == null) {
        response.sendRedirect("index.jsp?error=Please Login First");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>PerformancePlus | Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* NEW BLACKISH THEME CUSTOMIZATIONS */
        body { background-color: #f8f9fa; }
        
        /* Dark Sidebar & Header */
        .navbar-dark.bg-dark { background-color: #212529 !important; }
        
        /* Blackish List Group for Sidebar */
        .list-group-item.active {
            background-color: #212529 !important;
            border-color: #212529 !important;
            color: white !important;
        }
        
        .list-group-item:hover:not(.active) {
            background-color: #e9ecef;
            color: #212529;
        }

        /* Stats Cards Styling */
        .stats-card {
            border-top: 4px solid #212529 !important;
        }
        
        .stats-value {
            color: #212529 !important;
        }

        .uppercase { text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-dark shadow-sm">
        <div class="container">
            <span class="navbar-brand fw-bold">PerformancePlus</span>
            <div class="text-white">
                Welcome, <strong><%= username %></strong> (<%= role %>)
                <a href="logout.jsp" class="btn btn-sm btn-danger ms-3 px-3">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h3 class="fw-bold text-dark">Dashboard Overview</h3>
        <hr>
        <div class="row">
            <div class="col-md-3">
                <div class="list-group shadow-sm">
                    <% if ("ADMIN".equals(role)) { %>
                        <a href="#" class="list-group-item list-group-item-action active">Admin Control Panel</a>
                        <a href="viewAuditLogs.jsp" class="list-group-item list-group-item-action">System Audit Logs</a>
                        <a href="manageUsers.jsp" class="list-group-item list-group-item-action">Manage Users</a>
                    <% } else if ("MANAGER".equals(role)) { %>
                        <a href="assignKPI.jsp" class="list-group-item list-group-item-action active">Assign New KPI</a>
                        <a href="viewTeam.jsp" class="list-group-item list-group-item-action">My Team Reports</a>
                    <% } else if ("EMPLOYEE".equals(role)) { %>
                        <a href="myGoals.jsp" class="list-group-item list-group-item-action active">My Active Goals</a>
                        <a href="feedback.jsp" class="list-group-item list-group-item-action">View Feedback</a>
                    <% } %>
                </div>
            </div>

            <div class="col-md-9">
                <div class="alert alert-success border-0 shadow-sm" style="background-color: #d1e7dd; color: #0f5132;">
                    Successfully Authenticated as <strong><%= role %></strong>.
                </div>
                
                <% if ("ADMIN".equals(role)) { %>
                    <div class="card shadow-sm mt-3 border-0 stats-card">
                        <div class="card-body">
                            <h5 class="card-title fw-bold text-dark">System Statistics</h5>
                            <p class="card-text text-muted">Admin, Check the total users and roles.</p>
                            
                            <div class="row text-center mt-4">
                                <div class="col-md-4">
                                    <div class="p-4 border-0 bg-light rounded shadow-sm">
                                        <h6 class="text-secondary uppercase fw-bold">Total Users</h6>
                                        <p class="display-6 fw-bold stats-value mb-0">
                                            <%= session.getAttribute("totalUsers") != null ? session.getAttribute("totalUsers") : "0" %>
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-4 border-0 bg-light rounded shadow-sm">
                                        <h6 class="text-secondary uppercase fw-bold">Roles Configured</h6>
                                        <p class="display-6 fw-bold stats-value mb-0">
                                            <%= session.getAttribute("totalRoles") != null ? session.getAttribute("totalRoles") : "0" %>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>