<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Assign Task | PerformancePlus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Darkish Theme Customizations */
        .card {
            border-radius: 15px;
        }
        /* Header color matching dashboard */
        .text-darkish {
            color: #212529 !important;
        }
       
        .btn-darkish {
            background-color: #212529 !important;
            border-color: #212529 !important;
            color: white !important;
        }
        .btn-darkish:hover {
            background-color: #343a40 !important;
        }
    </style>
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="min-height: 100vh;">
    <div class="container" style="max-width: 600px;">
        <div class="card shadow-lg p-4 border-0">
            <h3 class="text-center mb-4 text-darkish fw-bold">Assign New Goal</h3>
            
            <form action="AddKPIServlet" method="post">
                <div class="mb-3">
                    <label class="form-label fw-bold">Select Employee</label>
                    <select name="employeeId" class="form-select" required>
                        <% 
                            List<Map<String, Object>> team = (List<Map<String, Object>>) session.getAttribute("myTeamList");
                            if(team != null && !team.isEmpty()) {
                                for(Map<String, Object> member : team) {
                        %>
                            <option value="<%= member.get("user_id") %>"><%= member.get("full_name") %></option>
                        <%      }
                            } else { %>
                            <option disabled>No employees found</option>
                        <% } %>
                    </select>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-bold">Task Title</label>
                    <input type="text" name="title" class="form-control" required placeholder="e.g. Sales Target">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="description" class="form-control" rows="2" placeholder="Describe the goal requirements..."></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Target Value</label>
                    <input type="number" name="targetValue" class="form-control" required placeholder="Enter numeric target">
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-darkish py-2 fw-bold">Assign Task</button>
                    <a href="dashboard.jsp" class="btn btn-outline-secondary">Back</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>