package com.careerlink.dao;

import com.careerlink.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InterviewDAO {

    static {
        ensureTableExists();
    }

    public static void ensureTableExists() {
        String createTableSql = """
                CREATE TABLE IF NOT EXISTS interview (
                    interview_id INT AUTO_INCREMENT PRIMARY KEY,
                    candidate_id INT NOT NULL,
                    job_id INT NOT NULL,
                    interview_date DATETIME NOT NULL,
                    interview_status VARCHAR(50) DEFAULT 'Scheduled',
                    interview_mode VARCHAR(50) DEFAULT 'Online',
                    meeting_link VARCHAR(500),
                    venue VARCHAR(500),
                    notes TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(createTableSql)
        ) {
            ps.executeUpdate();

            // Attempt to add columns if table previously existed without them
            String[] cols = {
                "ALTER TABLE interview ADD COLUMN interview_mode VARCHAR(50) DEFAULT 'Online'",
                "ALTER TABLE interview ADD COLUMN meeting_link VARCHAR(500)",
                "ALTER TABLE interview ADD COLUMN venue VARCHAR(500)",
                "ALTER TABLE interview ADD COLUMN notes TEXT"
            };
            for (String colSql : cols) {
                try (PreparedStatement psCol = con.prepareStatement(colSql)) {
                    psCol.executeUpdate();
                } catch (Exception ignored) {}
            }

        } catch (Exception e) {
            System.err.println("Note on interview table check: " + e.getMessage());
        }
    }

    private Timestamp parseTimestamp(String dateTimeString) {
        if (dateTimeString == null || dateTimeString.trim().isEmpty()) {
            return new Timestamp(System.currentTimeMillis());
        }
        String clean = dateTimeString.trim().replace("T", " ");
        
        try {
            if (clean.length() == 10) { // yyyy-MM-dd
                clean += " 10:00:00";
            } else if (clean.length() == 16) { // yyyy-MM-dd HH:mm
                clean += ":00";
            }
            return Timestamp.valueOf(clean);
        } catch (Exception e) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm[:ss]");
                LocalDateTime ldt = LocalDateTime.parse(clean, formatter);
                return Timestamp.valueOf(ldt);
            } catch (Exception ex) {
                System.err.println("Could not parse date '" + dateTimeString + "', using current timestamp: " + ex.getMessage());
                return new Timestamp(System.currentTimeMillis());
            }
        }
    }

    public boolean scheduleInterview(int candidateId, int jobId, String dateTimeString) {
        return scheduleInterview(candidateId, jobId, dateTimeString, "Online", null, null, null);
    }

    public boolean scheduleInterview(int candidateId, int jobId, String dateTimeString, String meetingLink, String notes) {
        return scheduleInterview(candidateId, jobId, dateTimeString, "Online", meetingLink, null, notes);
    }

    public boolean scheduleInterview(int candidateId, int jobId, String dateTimeString, String mode, String meetingLink, String venue, String notes) {
        ensureTableExists();
        Timestamp ts = parseTimestamp(dateTimeString);

        if (mode == null || mode.trim().isEmpty()) {
            mode = "Online";
        }

        if ("Online".equalsIgnoreCase(mode)) {
            if (meetingLink == null || meetingLink.trim().isEmpty()) {
                meetingLink = "https://meet.jit.si/CareerLink-Slot-" + System.currentTimeMillis();
            }
        } else {
            if (venue == null || venue.trim().isEmpty()) {
                venue = "Company Corporate Office, Recruitment Wing";
            }
        }

        // Check if an interview already exists for this candidate & job
        String checkSql = "SELECT interview_id FROM interview WHERE candidate_id = ? AND job_id = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement checkPs = con.prepareStatement(checkSql)
        ) {
            checkPs.setInt(1, candidateId);
            checkPs.setInt(2, jobId);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    int existingId = rs.getInt("interview_id");
                    String updateSql = """
                            UPDATE interview 
                            SET interview_date = ?, interview_status = 'Scheduled', interview_mode = ?, meeting_link = ?, venue = ?, notes = ? 
                            WHERE interview_id = ?
                            """;
                    try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                        updatePs.setTimestamp(1, ts);
                        updatePs.setString(2, mode);
                        updatePs.setString(3, meetingLink);
                        updatePs.setString(4, venue);
                        updatePs.setString(5, notes);
                        updatePs.setInt(6, existingId);
                        return updatePs.executeUpdate() > 0;
                    }
                }
            }

            // Otherwise insert new record
            String insertSql = """
                    INSERT INTO interview (candidate_id, job_id, interview_date, interview_status, interview_mode, meeting_link, venue, notes)
                    VALUES (?, ?, ?, 'Scheduled', ?, ?, ?, ?)
                    """;
            try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                insertPs.setInt(1, candidateId);
                insertPs.setInt(2, jobId);
                insertPs.setTimestamp(3, ts);
                insertPs.setString(4, mode);
                insertPs.setString(5, meetingLink);
                insertPs.setString(6, venue);
                insertPs.setString(7, notes);
                return insertPs.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rescheduleInterview(int interviewId, String dateTimeString) {
        return rescheduleInterview(interviewId, dateTimeString, "Online", null, null, null);
    }

    public boolean rescheduleInterview(int interviewId, String dateTimeString, String meetingLink, String notes) {
        return rescheduleInterview(interviewId, dateTimeString, "Online", meetingLink, null, notes);
    }

    public boolean rescheduleInterview(int interviewId, String dateTimeString, String mode, String meetingLink, String venue, String notes) {
        ensureTableExists();
        Timestamp ts = parseTimestamp(dateTimeString);
        
        String sql = """
                UPDATE interview 
                SET interview_date = ?, interview_status = 'Scheduled', interview_mode = ?, meeting_link = ?, venue = ?, notes = ?
                WHERE interview_id = ?
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setTimestamp(1, ts);
            ps.setString(2, mode != null ? mode : "Online");
            ps.setString(3, meetingLink);
            ps.setString(4, venue);
            ps.setString(5, notes);
            ps.setInt(6, interviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateInterviewStatus(int interviewId, String status) {
        ensureTableExists();
        String sql = "UPDATE interview SET interview_status = ? WHERE interview_id = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, status);
            ps.setInt(2, interviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteInterview(int interviewId) {
        ensureTableExists();
        String sql = "DELETE FROM interview WHERE interview_id = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, interviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getInterviewsByCandidate(int candidateId) {
        ensureTableExists();
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT i.*, j.job_title, j.location, h.company_name, h.hr_name, h.email AS hr_email, h.mobile AS hr_mobile
                FROM interview i
                JOIN job_post j ON i.job_id = j.job_id
                JOIN hr h ON j.hr_id = h.hr_id
                WHERE i.candidate_id = ?
                ORDER BY i.interview_date DESC
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> it = new HashMap<>();
                    it.put("interviewId", rs.getInt("interview_id"));
                    it.put("candidateId", rs.getInt("candidate_id"));
                    it.put("jobId", rs.getInt("job_id"));
                    it.put("interviewDate", rs.getTimestamp("interview_date"));
                    it.put("status", rs.getString("interview_status"));
                    it.put("mode", rs.getString("interview_mode") != null ? rs.getString("interview_mode") : "Online");
                    it.put("meetingLink", rs.getString("meeting_link"));
                    it.put("venue", rs.getString("venue"));
                    it.put("notes", rs.getString("notes"));
                    it.put("jobTitle", rs.getString("job_title"));
                    it.put("location", rs.getString("location"));
                    it.put("companyName", rs.getString("company_name"));
                    it.put("hrName", rs.getString("hr_name"));
                    it.put("hrEmail", rs.getString("hr_email"));
                    it.put("hrMobile", rs.getString("hr_mobile"));
                    list.add(it);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getInterviewsByHR(int hrId) {
        ensureTableExists();
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT i.*, j.job_title, c.name AS candidate_name, c.email AS candidate_email, c.mobile AS candidate_mobile, c.resume_path
                FROM interview i
                JOIN job_post j ON i.job_id = j.job_id
                JOIN candidate c ON i.candidate_id = c.candidate_id
                WHERE j.hr_id = ?
                ORDER BY i.interview_date DESC
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, hrId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> it = new HashMap<>();
                    it.put("interviewId", rs.getInt("interview_id"));
                    it.put("candidateId", rs.getInt("candidate_id"));
                    it.put("jobId", rs.getInt("job_id"));
                    it.put("interviewDate", rs.getTimestamp("interview_date"));
                    it.put("status", rs.getString("interview_status"));
                    it.put("mode", rs.getString("interview_mode") != null ? rs.getString("interview_mode") : "Online");
                    it.put("meetingLink", rs.getString("meeting_link"));
                    it.put("venue", rs.getString("venue"));
                    it.put("notes", rs.getString("notes"));
                    it.put("jobTitle", rs.getString("job_title"));
                    it.put("candidateName", rs.getString("candidate_name"));
                    it.put("candidateEmail", rs.getString("candidate_email"));
                    it.put("candidateMobile", rs.getString("candidate_mobile"));
                    it.put("resumePath", rs.getString("resume_path"));
                    list.add(it);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
