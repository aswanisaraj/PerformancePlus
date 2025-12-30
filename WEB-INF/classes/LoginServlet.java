import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {

            // --- 1. HANDLING REFRESH LOGIC (For Employee Progress Updates) ---
            if ("refresh".equals(action)) {
                Integer currentUserId = (Integer) session.getAttribute("userId");
                if (currentUserId != null) {
                    loadEmployeeData(session, con, currentUserId);
                    response.sendRedirect("myGoals.jsp");
                    return;
                }
            }

            // --- 2. HANDLING ADMIN ACTION: ADD USER ---
            if ("addUser".equals(action)) {
                handleUserCreation(request, response, con);
                return;
            }

            // --- 3. HANDLE STANDARD LOGIN ---
            UserDAO dao = new UserDAO();
            User validUser = dao.login(user, pass);

            if (validUser != null) {
                int currentUserId = validUser.getUserId();
                String currentUserRole = validUser.getRole();

                // Set primary session identity
                session.setAttribute("userId", currentUserId);
                session.setAttribute("username", validUser.getUsername());
                session.setAttribute("userRole", currentUserRole);

                // --- ROLE-BASED DATA INITIALIZATION ---
                
                if ("ADMIN".equals(currentUserRole)) {
                    loadAdminStats(session, con);
                    loadManagementUserList(session, con);
                    loadAuditLogs(session, con); // Fetch Logs for Admin
                } 
                else if ("MANAGER".equals(currentUserRole)) {
                    loadManagerTeam(session, con, currentUserId);
                    loadTeamReports(session, con, currentUserId); // Fetch Reports for Manager
                } 
                else if ("EMPLOYEE".equals(currentUserRole)) {
                    loadEmployeeData(session, con, currentUserId); // Goals & Feedback
                }

                AuditDAO.logAction(currentUserId, "User Logged In");
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp?error=Invalid Credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); 
        }
    }



    // Loading Goals and Feedback for Employees
    private void loadEmployeeData(HttpSession session, Connection con, int userId) throws SQLException {
        List<Map<String, Object>> goals = new ArrayList<>();
        String kpiSql = "SELECT kpi_id, title, description, target_value, current_value, status FROM kpis WHERE employee_id = ?";
        try (PreparedStatement ps = con.prepareStatement(kpiSql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> goal = new HashMap<>();
                goal.put("kpi_id", rs.getInt("kpi_id"));
                goal.put("title", rs.getString("title"));
                goal.put("description", rs.getString("description"));
                goal.put("target", rs.getInt("target_value"));
                goal.put("current", rs.getInt("current_value"));
                goal.put("status", rs.getString("status"));
                goals.add(goal);
            }
        }
        session.setAttribute("employeeGoals", goals);

        List<String> feedback = new ArrayList<>();
        String feedSql = "SELECT comments FROM feedback WHERE employee_id = ? ORDER BY created_at DESC";
        try (PreparedStatement psFeed = con.prepareStatement(feedSql)) {
            psFeed.setInt(1, userId);
            ResultSet rsFeed = psFeed.executeQuery();
            while (rsFeed.next()) {
                feedback.add(rsFeed.getString("comments"));
            }
        }
        session.setAttribute("employeeFeedback", feedback);
    }

    // Loading Statistics and User List for Admin
    private void loadAdminStats(HttpSession session, Connection con) throws SQLException {
        Statement st = con.createStatement();
        ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM users");
        if (rs1.next()) session.setAttribute("totalUsers", rs1.getInt(1));
        
        ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM roles");
        if (rs2.next()) session.setAttribute("totalRoles", rs2.getInt(1));
    }

    private void loadManagementUserList(HttpSession session, Connection con) throws SQLException {
        List<Map<String, Object>> userList = new ArrayList<>();
        String sql = "SELECT u.user_id, u.username, u.full_name, r.role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.role_id WHERE r.role_name != 'ADMIN'";
        ResultSet rs = con.createStatement().executeQuery(sql);
        while (rs.next()) {
            Map<String, Object> uMap = new HashMap<>();
            uMap.put("user_id", rs.getInt("user_id"));
            uMap.put("username", rs.getString("username"));
            uMap.put("full_name", rs.getString("full_name"));
            uMap.put("role_name", rs.getString("role_name"));
            userList.add(uMap);
        }
        session.setAttribute("managementUserList", userList);
    }

    // Load Audit Logs for Admin
    private void loadAuditLogs(HttpSession session, Connection con) throws SQLException {
        List<Map<String, Object>> logs = new ArrayList<>();
        String sql = "SELECT log_id, user_id, action, timestamp FROM audit_logs ORDER BY timestamp DESC";
        ResultSet rs = con.createStatement().executeQuery(sql);
        while (rs.next()) {
            Map<String, Object> log = new HashMap<>();
            log.put("log_id", rs.getInt("log_id"));
            log.put("user_id", rs.getInt("user_id"));
            log.put("action", rs.getString("action"));
            log.put("timestamp", rs.getTimestamp("timestamp"));
            logs.add(log);
        }
        session.setAttribute("auditLogList", logs);
    }

    // Load Team List and Performance Reports for Manager
    private void loadManagerTeam(HttpSession session, Connection con, int managerId) throws SQLException {
        List<Map<String, Object>> team = new ArrayList<>();
        String sql = "SELECT user_id, full_name FROM users WHERE manager_id = ? AND role_id != 1";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("user_id", rs.getInt("user_id"));
                m.put("full_name", rs.getString("full_name"));
                team.add(m);
            }
        }
        session.setAttribute("myTeamList", team);
    }

    private void loadTeamReports(HttpSession session, Connection con, int managerId) throws SQLException {
        List<Map<String, Object>> reports = new ArrayList<>();
        String sql = "SELECT u.full_name, k.title, k.current_value, k.target_value, k.status " +
                     "FROM kpis k JOIN users u ON k.employee_id = u.user_id " +
                     "WHERE u.manager_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> r = new HashMap<>();
                r.put("employee_name", rs.getString("full_name"));
                r.put("kpi_title", rs.getString("title"));
                r.put("current", rs.getInt("current_value"));
                r.put("target", rs.getInt("target_value"));
                r.put("status", rs.getString("status"));
                reports.add(r);
            }
        }
        session.setAttribute("teamPerformanceReports", reports);
    }

    private void handleUserCreation(HttpServletRequest req, HttpServletResponse res, Connection con) throws IOException, SQLException {
        String u = req.getParameter("newUsername");
        String p = req.getParameter("newPassword");
        String f = req.getParameter("newFullName");
        int r = Integer.parseInt(req.getParameter("newRoleId"));

        String sql = "INSERT INTO users (username, password, full_name, role_id, manager_id) VALUES (?, ?, ?, ?, 1)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u);
            ps.setString(2, p);
            ps.setString(3, f);
            ps.setInt(4, r);
            ps.executeUpdate();
            AuditDAO.logAction((Integer) req.getSession().getAttribute("userId"), "Created User: " + u);
            
            // Refresh the management user list in session
            loadManagementUserList(req.getSession(), con);
            
            res.sendRedirect("manageUsers.jsp?msg=UserCreated");
        }
    }
}