package com.careerlink.dao;

import com.careerlink.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ContactDAO {

    public ContactDAO() {
        initTable();
    }

    private void initTable() {
        String createTableSql = """
                CREATE TABLE IF NOT EXISTS contact_messages (
                    message_id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(100) NOT NULL,
                    email VARCHAR(100) NOT NULL,
                    subject VARCHAR(200) NOT NULL,
                    message TEXT NOT NULL,
                    status VARCHAR(30) DEFAULT 'Pending',
                    reply TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
                """;
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement()) {
            stmt.executeUpdate(createTableSql);

            // Ensure columns exist if table was previously created with older schema
            String[] alterCols = {
                "ALTER TABLE contact_messages ADD COLUMN status VARCHAR(30) DEFAULT 'Pending'",
                "ALTER TABLE contact_messages ADD COLUMN reply TEXT",
                "ALTER TABLE contact_messages ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
            };
            for (String alterSql : alterCols) {
                try (PreparedStatement ps = con.prepareStatement(alterSql)) {
                    ps.executeUpdate();
                } catch (Exception ignored) {
                    // Column already exists or MySQL syntax handled gracefully
                }
            }
        } catch (Exception e) {
            System.err.println("Note on contact_messages table initialization: " + e.getMessage());
        }
    }

    public boolean sendMessage(String name, String email, String subject, String message) {
        String sql = "INSERT INTO contact_messages (name, email, subject, message, status) VALUES (?, ?, ?, ?, 'Pending')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, message);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getAllMessages() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_messages ORDER BY message_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("messageId", rs.getInt("message_id"));
                map.put("name", rs.getString("name"));
                map.put("email", rs.getString("email"));
                map.put("subject", rs.getString("subject"));
                map.put("message", rs.getString("message"));
                
                String status = null;
                try {
                    status = rs.getString("status");
                } catch (Exception ignored) {}
                map.put("status", status != null ? status : "Pending");

                String reply = null;
                try {
                    reply = rs.getString("reply");
                } catch (Exception ignored) {}
                map.put("reply", reply);

                Object createdAt = null;
                try {
                    createdAt = rs.getTimestamp("created_at");
                } catch (Exception ignored) {}
                map.put("createdAt", createdAt);

                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean resolveMessage(int messageId, String reply) {
        String sql = "UPDATE contact_messages SET status = 'Resolved', reply = ? WHERE message_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, reply != null && !reply.trim().isEmpty() ? reply.trim() : "Issue analyzed and resolved by System Administrator.");
            ps.setInt(2, messageId);
            int updatedRows = ps.executeUpdate();
            return updatedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteMessage(int messageId) {
        String sql = "DELETE FROM contact_messages WHERE message_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countPendingMessages() {
        String sql = "SELECT COUNT(*) FROM contact_messages WHERE status = 'Pending' OR status IS NULL";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
