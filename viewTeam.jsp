<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Team Report | PerformancePlus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="min-height: 100vh;">
    <div class="container" style="max-width: 900px;">
        <div class="card shadow-lg p-4 border-0" style="border-radius: 15px;">
            <h3 class="text-center mb-4 text-primary">Team Performance Report</h3>
            <table class="table table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Employee</th>
                        <th>Goal</th>
                        <th>Progress</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Map<String, Object>> reports = (List<Map<String, Object>>) session.getAttribute("teamPerformanceReports");
                        if(reports != null && !reports.isEmpty()) {
                            for(Map<String, Object> r : reports) {
                    %>
                        <tr>
                            <td><strong><%= r.get("employee_name") %></strong></td>
                            <td><%= r.get("kpi_title") %></td>
                            <td>
                                <div class="progress" style="height: 10px;">
                                    <% int percent = (int)r.get("target") > 0 ? ((int)r.get("current") * 100 / (int)r.get("target")) : 0; %>
                                    <div class="progress-bar" style="width: <%= percent %>%"></div>
                                </div>
                                <small><%= r.get("current") %> / <%= r.get("target") %></small>
                            </td>
                            <td>
                                <span class="badge <%= "Completed".equals(r.get("status")) ? "bg-success" : "bg-warning text-dark" %>">
                                    <%= r.get("status") %>
                                </span>
                            </td>
                        </tr>
                    <%      }
                        } else { %>
                        <tr><td colspan="4" class="text-center text-muted p-4">No team data available.</td></tr>
                    <% } %>
                </tbody>
            </table>
            <div class="mt-3 text-center">
                <a href="dashboard.jsp" class="btn btn-secondary px-4">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>