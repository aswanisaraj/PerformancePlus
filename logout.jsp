<%
    session.invalidate(); // Destroy the session
    response.sendRedirect("index.jsp?error=Logged Out Successfully");
%>