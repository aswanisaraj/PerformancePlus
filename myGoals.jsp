<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Performance Goals | PerformancePlus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .text-darkish { color: #212529 !important; }
        .btn-darkish { background-color: #212529 !important; border-color: #212529 !important; color: white !important; }
        .btn-darkish:hover { background-color: #343a40 !important; }
        .progress-bar-darkish { background-color: #212529 !important; }
    </style>
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="min-height: 100vh;">
    <div class="container" style="max-width: 950px;">
        <div class="card shadow-lg p-4 border-0" style="border-radius: 15px;">
            <h3 class="text-center mb-4 text-darkish fw-bold">My Performance Goals</h3>
            
            <table class="table table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Goal Details</th>
                        <th class="text-center">Target</th>
                        <th style="width: 25%;">Progress</th>
                        <th class="text-center">Status</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Map<String, Object>> goals = (List<Map<String, Object>>) session.getAttribute("employeeGoals");
                        if(goals != null && !goals.isEmpty()) {
                            for(Map<String, Object> g : goals) {
                                int current = (int)g.get("current");
                                int target = (int)g.get("target");
                                int percent = (target > 0) ? (current * 100 / target) : 0;
                    %>
                        <tr>
                            <td>
                                <div class="fw-bold"><%= g.get("title") %></div>
                                <small class="text-muted">
                                    <%= (g.get("description") != null) ? g.get("description") : "No description available." %>
                                </small>
                            </td>
                            <td class="text-center"><span class="badge bg-secondary px-3"><%= target %></span></td>
                            <td>
                                <div class="progress" style="height: 15px;">
                                    <div class="progress-bar progress-bar-darkish" style="width: <%= percent %>%"></div>
                                </div>
                                <small class="text-center d-block mt-1"><%= percent %>% Complete</small>
                            </td>
                            <td class="text-center">
                                <span class="badge rounded-pill <%= "Completed".equals(g.get("status")) ? "bg-success" : "bg-warning text-dark" %>">
                                    <%= g.get("status") %>
                                </span>
                            </td>
                            <td class="text-center">
                                <% if(!"Completed".equals(g.get("status"))) { %>
                                <form action="UpdateProgressServlet" method="post" class="input-group input-group-sm">
                                    <input type="hidden" name="kpiId" value="<%= g.get("kpi_id") %>">
                                    <input type="number" name="newProgress" class="form-control" value="<%= current %>">
                                    <button type="submit" class="btn btn-darkish">Update</button>
                                </form>
                                <% } else { %>
                                    <button class="btn btn-sm btn-outline-secondary disabled w-100">Locked</button>
                                <% } %>
                            </td>
                        </tr>
                    <%      } 
                        } else { %>
                        <tr><td colspan="5" class="text-center p-5 text-muted">No active goals found.</td></tr>
                    <% } %>
                </tbody>
            </table>
            <div class="mt-4"><a href="dashboard.jsp" class="btn btn-outline-dark px-4">Back to Dashboard</a></div>
        </div>
    </div>
</body>
</html>