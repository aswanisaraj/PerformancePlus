<%@ page isErrorPage="true" language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Oops! Error Occurred</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="height: 100vh;">
    <div class="container text-center">
        <div class="card shadow mx-auto" style="max-width: 500px;">
            <div class="card-body py-5">
                <h1 class="display-4 text-danger">!</h1>
                <h3>Something went wrong</h3>
                <p class="text-muted">The system encountered an unexpected error. Please check your connection or contact the Admin.</p>
                <a href="dashboard.jsp" class="btn btn-primary">Return to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>