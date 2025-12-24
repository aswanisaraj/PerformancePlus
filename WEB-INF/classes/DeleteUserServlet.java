import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        HttpSession session = request.getSession();
        
        try (Connection con = DBConnection.getConnection()) {
            // 1. Delete from Database
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE user_id = ?");
            ps.setInt(1, Integer.parseInt(userId));
            ps.executeUpdate();
            
            // 2. Refresh the Session List (So it disappears immediately)
            List<Map<String, Object>> userList = new ArrayList<>();
            String userSql = "SELECT u.user_id, u.username, u.full_name, r.role_name " +
                             "FROM users u JOIN roles r ON u.role_id = r.role_id " +
                             "WHERE r.role_name != 'ADMIN'";
            Statement st = con.createStatement();
            ResultSet rsUsers = st.executeQuery(userSql);

            while (rsUsers.next()) {
                Map<String, Object> uMap = new HashMap<>();
                uMap.put("user_id", rsUsers.getInt("user_id"));
                uMap.put("username", rsUsers.getString("username"));
                uMap.put("full_name", rsUsers.getString("full_name"));
                uMap.put("role_name", rsUsers.getString("role_name"));
                userList.add(uMap);
            }
            session.setAttribute("managementUserList", userList);
            
            // 3. Update the Total Users count in session
            ResultSet rsCount = st.executeQuery("SELECT COUNT(*) FROM users");
            if (rsCount.next()) session.setAttribute("totalUsers", rsCount.getInt(1));

            // Log the action
            int adminId = (Integer) session.getAttribute("userId");
            AuditDAO.logAction(adminId, "Deleted User ID: " + userId);
            
            response.sendRedirect("manageUsers.jsp?msg=User Deleted Successfully"); 
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}