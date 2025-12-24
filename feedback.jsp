<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Feedback | PerformancePlus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="min-height: 100vh;">
    <div class="container" style="max-width: 800px;">
        <div class="card shadow-lg p-4">
            <h3 class="text-center mb-4 border-bottom pb-3">Manager Feedback</h3>
            
            <div class="list-group">
                <% 
                    List<String> feedbackList = (List<String>) session.getAttribute("employeeFeedback");
                    if (feedbackList != null && !feedbackList.isEmpty()) {
                        for (String comment : feedbackList) {
                %>
                    <div class="list-group-item list-group-item-action border-start border-4 border-primary mb-3 shadow-sm rounded">
                        <p class="mb-1 text-dark fw-bold">Performance Note:</p>
                        <p class="mb-0 text-muted fst-italic">"<%= comment %>"</p>
                    </div>
                <% 
                        }
                    } else { 
                %>
                    <div class="alert alert-info text-center">
                        No feedback entries found in the database yet.
                    </div>
                <% } %>
            </div>

            <div class="mt-4 text-center">
                <a href="dashboard.jsp" class="btn btn-dark px-4">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>