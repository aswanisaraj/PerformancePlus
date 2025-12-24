import java.sql.*;

public class UserDAO {
    public User login(String username, String password) {
        User user = null;
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.out.println("DEBUG: Database connection failed! Check DBConnection.java");
                return null;
            }

            // Using the column names exactly as seen in your SQLyog screenshot
            String sql = "SELECT u.user_id, u.username, r.role_name FROM users u " +
                         "JOIN roles r ON u.role_id = r.role_id " +
                         "WHERE u.username=? AND u.password=?";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            
            System.out.println("DEBUG: Executing query for user: " + username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role_name"));
                System.out.println("DEBUG: User found! Role: " + user.getRole());
            } else {
                System.out.println("DEBUG: No user found in database with those credentials.");
            }
        } catch (Exception e) {
            System.out.println("DEBUG: Exception occurred: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return user;
    }
}