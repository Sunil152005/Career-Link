package com.careerlink.dao;

import com.careerlink.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ApplicationDAO {

    public boolean applyForJob(int candidateId, int jobId) {
        // Prevent duplicate applications
        if (hasApplied(candidateId, jobId)) {
            return false;
        }
        String sql = """
                INSERT INTO application (candidate_id, job_id, apply_date, status)
                VALUES (?, ?, ?, ?)
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, candidateId);
            ps.setInt(2, jobId);
            ps.setDate(3, Date.valueOf(LocalDate.now()));
            ps.setString(4, "Applied");

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasApplied(int candidateId, int jobId) {
        String sql = "SELECT 1 FROM application WHERE candidate_id = ? AND job_id = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, candidateId);
            ps.setInt(2, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(int applicationId, String status) {
        String sql = "UPDATE application SET status = ? WHERE application_id = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, status);
            ps.setInt(2, applicationId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getApplicationsByCandidate(int candidateId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT a.*, j.job_title, j.location, h.company_name 
                FROM application a
                JOIN job_post j ON a.job_id = j.job_id
                JOIN hr h ON j.hr_id = h.hr_id
                WHERE a.candidate_id = ?
                ORDER BY a.application_id DESC
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> app = new HashMap<>();
                    app.put("applicationId", rs.getInt("application_id"));
                    app.put("candidateId", rs.getInt("candidate_id"));
                    app.put("jobId", rs.getInt("job_id"));
                    app.put("applyDate", rs.getDate("apply_date"));
                    app.put("status", rs.getString("status"));
                    app.put("jobTitle", rs.getString("job_title"));
                    app.put("location", rs.getString("location"));
                    app.put("companyName", rs.getString("company_name"));
                    list.add(app);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getApplicationsByHR(int hrId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT a.*, j.job_title, c.name AS candidate_name, c.email AS candidate_email, 
                       c.mobile AS candidate_mobile, c.education, c.skills, c.experience, c.resume_path
                FROM application a
                JOIN job_post j ON a.job_id = j.job_id
                JOIN candidate c ON a.candidate_id = c.candidate_id
                WHERE j.hr_id = ?
                ORDER BY a.application_id DESC
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, hrId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> app = new HashMap<>();
                    app.put("applicationId", rs.getInt("application_id"));
                    app.put("candidateId", rs.getInt("candidate_id"));
                    app.put("jobId", rs.getInt("job_id"));
                    app.put("applyDate", rs.getDate("apply_date"));
                    app.put("status", rs.getString("status"));
                    app.put("jobTitle", rs.getString("job_title"));
                    app.put("candidateName", rs.getString("candidate_name"));
                    app.put("candidateEmail", rs.getString("candidate_email"));
                    app.put("candidateMobile", rs.getString("candidate_mobile"));
                    app.put("education", rs.getString("education"));
                    app.put("skills", rs.getString("skills"));
                    app.put("experience", rs.getString("experience"));
                    app.put("resumePath", rs.getString("resume_path"));
                    list.add(app);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countApplications() {
        String sql = "SELECT COUNT(*) FROM application";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
