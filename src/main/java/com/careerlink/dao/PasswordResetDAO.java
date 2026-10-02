package com.careerlink.dao;

import com.careerlink.util.DBConnection;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

public class PasswordResetDAO {

    static {
        ensureTableExists();
    }

    public static void ensureTableExists() {
        String sql = """
                CREATE TABLE IF NOT EXISTS password_reset_token (
                    token_id INT AUTO_INCREMENT PRIMARY KEY,
                    email VARCHAR(255) NOT NULL,
                    role_type VARCHAR(50) NOT NULL,
                    token_hash VARCHAR(128) NOT NULL,
                    expiry_time TIMESTAMP NOT NULL,
                    is_used BOOLEAN DEFAULT FALSE,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Notice on password_reset_token table check: " + e.getMessage());
        }
    }

    private static String hashToken(String rawToken) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(rawToken.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error hashing token", e);
        }
    }

    public String createResetToken(String email, String roleType) {
        ensureTableExists();

        // Invalidate any previous unused tokens for this email
        String invalidateSql = "UPDATE password_reset_token SET is_used = TRUE WHERE email = ? AND is_used = FALSE";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement invPs = con.prepareStatement(invalidateSql)
        ) {
            invPs.setString(1, email);
            invPs.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Generate 32 bytes cryptographically secure random token
        byte[] randomBytes = new byte[32];
        new SecureRandom().nextBytes(randomBytes);
        StringBuilder sb = new StringBuilder();
        for (byte b : randomBytes) {
            sb.append(String.format("%02x", b));
        }
        String rawToken = sb.toString();
        String tokenHash = hashToken(rawToken);

        // 15 minutes validity
        Timestamp expiry = new Timestamp(System.currentTimeMillis() + (15 * 60 * 1000));

        String sql = """
                INSERT INTO password_reset_token (email, role_type, token_hash, expiry_time, is_used)
                VALUES (?, ?, ?, ?, FALSE)
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, email);
            ps.setString(2, roleType.toUpperCase());
            ps.setString(3, tokenHash);
            ps.setTimestamp(4, expiry);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                return rawToken;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map<String, Object> validateToken(String rawToken) {
        ensureTableExists();
        if (rawToken == null || rawToken.trim().isEmpty()) {
            return null;
        }

        String tokenHash = hashToken(rawToken.trim());
        String sql = """
                SELECT * FROM password_reset_token 
                WHERE token_hash = ? AND is_used = FALSE AND expiry_time > NOW()
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, tokenHash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("tokenId", rs.getInt("token_id"));
                    data.put("email", rs.getString("email"));
                    data.put("roleType", rs.getString("role_type"));
                    data.put("expiryTime", rs.getTimestamp("expiry_time"));
                    return data;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean markTokenUsed(String rawToken) {
        ensureTableExists();
        if (rawToken == null || rawToken.trim().isEmpty()) {
            return false;
        }

        String tokenHash = hashToken(rawToken.trim());
        String sql = "UPDATE password_reset_token SET is_used = TRUE WHERE token_hash = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, tokenHash);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
