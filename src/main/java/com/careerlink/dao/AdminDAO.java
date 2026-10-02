package com.careerlink.dao;

import com.careerlink.util.DBConnection;
import com.careerlink.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Data Access Object for Administrator credentials and security settings.
 */
public class AdminDAO {

    public AdminDAO() {
        initTable();
    }

    private void initTable() {
        String sql = """
                CREATE TABLE IF NOT EXISTS admin_credentials (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    email VARCHAR(100) NOT NULL UNIQUE,
                    password_hash VARCHAR(255) NOT NULL,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                )
                """;
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement()) {
            stmt.executeUpdate(sql);

            // Check if default admin account exists, if not seed it
            String checkSql = "SELECT COUNT(*) FROM admin_credentials WHERE email = 'admin@careerlink.com'";
            try (ResultSet rs = stmt.executeQuery(checkSql)) {
                if (rs.next() && rs.getInt(1) == 0) {
                    String seedSql = "INSERT INTO admin_credentials (email, password_hash) VALUES (?, ?)";
                    try (PreparedStatement ps = con.prepareStatement(seedSql)) {
                        ps.setString(1, "admin@careerlink.com");
                        ps.setString(2, PasswordUtil.hashPassword("admin123"));
                        ps.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean validateAdmin(String email, String plainPassword) {
        if (email == null || plainPassword == null) return false;
        String safeEmail = email.trim();

        String sql = "SELECT password_hash FROM admin_credentials WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, safeEmail);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");
                    if (storedHash != null && storedHash.contains(":")) {
                        return PasswordUtil.verifyPassword(plainPassword, storedHash);
                    } else {
                        return plainPassword.equals(storedHash);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fallback default credential check if DB is not populated
        return "admin@careerlink.com".equalsIgnoreCase(safeEmail) && "admin123".equals(plainPassword);
    }

    public boolean updatePassword(String email, String plainPassword) {
        if (email == null || plainPassword == null) return false;
        String safeEmail = email.trim();
        String hashedPassword = PasswordUtil.hashPassword(plainPassword);

        String sql = "UPDATE admin_credentials SET password_hash = ? WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, safeEmail);
            int rows = ps.executeUpdate();
            if (rows == 0) {
                // If row didn't exist, insert it
                String insertSql = "INSERT INTO admin_credentials (email, password_hash) VALUES (?, ?)";
                try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                    insertPs.setString(1, safeEmail);
                    insertPs.setString(2, hashedPassword);
                    return insertPs.executeUpdate() > 0;
                }
            }
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
