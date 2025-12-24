import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;


public class AddKPIServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int empId = Integer.parseInt(request.getParameter("employeeId"));
        String title = request.getParameter("title");
        String desc = request.getParameter("description");
        int target = Integer.parseInt(request.getParameter("targetValue"));

        try (Connection con = DBConnection.getConnection()) {
            // 1. Validation Check: Ensure the recipient is NOT an Admin
            String checkRoleSql = "SELECT role_id FROM users WHERE user_id = ?";
            try (PreparedStatement psCheck = con.prepareStatement(checkRoleSql)) {
                psCheck.setInt(1, empId);
                ResultSet rs = psCheck.executeQuery();
                
                if (rs.next()) {
                    int roleId = rs.getInt("role_id");
                    if (roleId == 1) { // 1 is the ID for ADMIN
                        // Block the action and redirect with error
                        response.sendRedirect("assignKPI.jsp?error=Cannot assign goals to Admins");
                        return;
                    }
                }
            }

            // 2. Proceed with Insertion if validation passes
            String sql = "INSERT INTO kpis (employee_id, title, description, target_value, current_value, status) VALUES (?, ?, ?, ?, 0, 'Pending')";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, empId);
            ps.setString(2, title);
            ps.setString(3, desc);
            ps.setInt(4, target);
            
            ps.executeUpdate();
            response.sendRedirect("dashboard.jsp?msg=Goal Assigned Successfully");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}