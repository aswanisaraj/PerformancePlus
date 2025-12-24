import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class UpdateProgressServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if session exists to prevent NullPointerException
        Object userObj = session.getAttribute("userId");
        if (userObj == null) {
            response.sendRedirect("index.jsp?error=Session expired, please login again");
            return;
        }
    

        int userId = (Integer) userObj;
        String kpiIdRaw = request.getParameter("kpiId");
        String progressRaw = request.getParameter("newProgress");

        // Validate that parameters are not null
        if (kpiIdRaw == null || progressRaw == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        int kpiId = Integer.parseInt(kpiIdRaw);
        int newProgress = Integer.parseInt(progressRaw);

        try (Connection con = DBConnection.getConnection()) {
            // 1. Update progress value
            String sql = "UPDATE kpis SET current_value = ? WHERE kpi_id = ? AND employee_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, newProgress);
                ps.setInt(2, kpiId);
                ps.setInt(3, userId);
                ps.executeUpdate();
            }

            // 2. Auto-complete logic
            String statusSql = "UPDATE kpis SET status = 'Completed' WHERE kpi_id = ? AND current_value >= target_value";
            try (PreparedStatement psStatus = con.prepareStatement(statusSql)) {
                psStatus.setInt(1, kpiId);
                psStatus.executeUpdate();
            }

            // 3. REFRESH: This hits LoginServlet's doGet/doPost with action=refresh
            response.sendRedirect("login?action=refresh");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); 
        }
    }
}