import java.sql.*;

public class AuditDAO {
    public static void logAction(int userId, String action) {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO audit_logs (user_id, action) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, action);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}