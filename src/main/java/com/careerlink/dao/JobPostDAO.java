package com.careerlink.dao;

import com.careerlink.util.DBConnection;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class JobPostDAO {

    static {
        ensureStatusColumnExists();
    }

    private static synchronized void ensureStatusColumnExists() {
        try (Connection con = DBConnection.getConnection()) {
            DatabaseMetaData meta = con.getMetaData();
            try (ResultSet rs = meta.getColumns(null, null, "job_post", "status")) {
                if (!rs.next()) {
                    try (Statement stmt = con.createStatement()) {
                        stmt.executeUpdate("ALTER TABLE job_post ADD COLUMN status VARCHAR(50) NOT NULL DEFAULT 'Pending'");
                        stmt.executeUpdate("UPDATE job_post SET status = 'Active' WHERE status IS NULL OR status = ''");
                    }
                }
            }
        } catch (Exception ignored) {
        }
    }

    public boolean addJob(int hrId, String title, String description, String skills, String qualification, String experience, double salary, String location, String lastDate) {
        String sql = """
                INSERT INTO job_post (hr_id, job_title, description, skills, qualification, experience, salary, location, last_date, status)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending')
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, hrId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setString(4, skills);
            ps.setString(5, qualification);
            ps.setString(6, experience);
            ps.setDouble(7, salary);
            ps.setString(8, location);
            ps.setDate(9, Date.valueOf(lastDate));

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateJob(int jobId, String title, String description, String skills, String qualification, String experience, double salary, String location, String lastDate) {
        String sql = """
                UPDATE job_post 
                SET job_title = ?, description = ?, skills = ?, qualification = ?, experience = ?, salary = ?, location = ?, last_date = ?
                WHERE job_id = ?
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, skills);
            ps.setString(4, qualification);
            ps.setString(5, experience);
            ps.setDouble(6, salary);
            ps.setString(7, location);
            ps.setDate(8, Date.valueOf(lastDate));
            ps.setInt(9, jobId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean approveJob(int jobId) {
        return updateJobStatus(jobId, "Active");
    }

    public boolean rejectJob(int jobId) {
        return updateJobStatus(jobId, "Rejected");
    }

    public boolean updateJobStatus(int jobId, String status) {
        String sql = "UPDATE job_post SET status = ? WHERE job_id = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, status);
            ps.setInt(2, jobId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteJob(int jobId) {
        String deleteInterviews = "DELETE FROM interview WHERE job_id = ?";
        String deleteApps = "DELETE FROM application WHERE job_id = ?";
        String deleteJob = "DELETE FROM job_post WHERE job_id = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try (
                PreparedStatement ps1 = con.prepareStatement(deleteInterviews);
                PreparedStatement ps2 = con.prepareStatement(deleteApps);
                PreparedStatement ps3 = con.prepareStatement(deleteJob)
            ) {
                ps1.setInt(1, jobId);
                ps1.executeUpdate();
                
                ps2.setInt(1, jobId);
                ps2.executeUpdate();
                
                ps3.setInt(1, jobId);
                int rows = ps3.executeUpdate();
                
                con.commit();
                return rows > 0;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Object> getJobById(int jobId) {
        String sql = """
                SELECT j.*, h.company_name, h.hr_name 
                FROM job_post j
                JOIN hr h ON j.hr_id = h.hr_id
                WHERE j.job_id = ?
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, jobId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Map<String, Object>> listAllJobs() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT j.*, h.company_name, h.hr_name 
                FROM job_post j
                JOIN hr h ON j.hr_id = h.hr_id
                ORDER BY 
                    CASE WHEN j.status = 'Pending' THEN 0 ELSE 1 END,
                    j.job_id DESC
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> listPendingJobs() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT j.*, h.company_name, h.hr_name 
                FROM job_post j
                JOIN hr h ON j.hr_id = h.hr_id
                WHERE j.status = 'Pending'
                ORDER BY j.job_id DESC
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> listActiveJobs() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT j.*, h.company_name, h.hr_name 
                FROM job_post j
                JOIN hr h ON j.hr_id = h.hr_id
                WHERE (j.status = 'Active' OR j.status IS NULL) AND j.last_date >= CURRENT_DATE()
                ORDER BY j.job_id DESC
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> listJobsByHR(int hrId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT j.*, h.company_name, h.hr_name 
                FROM job_post j
                JOIN hr h ON j.hr_id = h.hr_id
                WHERE j.hr_id = ?
                ORDER BY j.job_id DESC
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, hrId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> searchJobs(String query) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT j.*, h.company_name, h.hr_name 
                FROM job_post j
                JOIN hr h ON j.hr_id = h.hr_id
                WHERE (j.status = 'Active' OR j.status IS NULL) AND j.last_date >= CURRENT_DATE()
                  AND (j.job_title LIKE ? OR j.skills LIKE ? OR j.location LIKE ? OR h.company_name LIKE ?)
                ORDER BY j.job_id DESC
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            String wildcard = "%" + (query == null ? "" : query) + "%";
            ps.setString(1, wildcard);
            ps.setString(2, wildcard);
            ps.setString(3, wildcard);
            ps.setString(4, wildcard);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Map<String, Object> mapRow(ResultSet rs) throws SQLException {
        Map<String, Object> job = new HashMap<>();
        job.put("jobId", rs.getInt("job_id"));
        job.put("hrId", rs.getInt("hr_id"));
        job.put("title", rs.getString("job_title"));
        job.put("description", rs.getString("description"));
        job.put("skills", rs.getString("skills"));
        job.put("qualification", rs.getString("qualification"));
        job.put("experience", rs.getString("experience"));
        job.put("salary", rs.getDouble("salary"));
        job.put("location", rs.getString("location"));
        job.put("lastDate", rs.getDate("last_date"));
        job.put("companyName", rs.getString("company_name"));
        job.put("hrName", rs.getString("hr_name"));
        
        String status = "Active";
        try {
            String s = rs.getString("status");
            if (s != null && !s.trim().isEmpty()) {
                status = s;
            }
        } catch (Exception ignored) {}
        job.put("status", status);
        
        return job;
    }

    public List<Map<String, Object>> getRecommendedJobs(String candidateSkills) {
        List<Map<String, Object>> activeJobs = listActiveJobs();
        if (candidateSkills == null || candidateSkills.trim().isEmpty()) {
            return activeJobs.subList(0, Math.min(activeJobs.size(), 3));
        }
        
        List<Map<String, Object>> recommended = new ArrayList<>();
        String[] cSkills = candidateSkills.toLowerCase().split(",");
        
        for (Map<String, Object> job : activeJobs) {
            String jobSkills = (String) job.get("skills");
            if (jobSkills != null) {
                String jobSkillsLower = jobSkills.toLowerCase();
                for (String cSkill : cSkills) {
                    cSkill = cSkill.trim();
                    if (!cSkill.isEmpty() && jobSkillsLower.contains(cSkill)) {
                        recommended.add(job);
                        break;
                    }
                }
            }
        }
        
        if (recommended.isEmpty()) {
            return activeJobs.subList(0, Math.min(activeJobs.size(), 3));
        }
        return recommended;
    }

    public int countPendingJobs() {
        String sql = "SELECT COUNT(*) FROM job_post WHERE status = 'Pending'";
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

    public int countActiveJobs() {
        String sql = "SELECT COUNT(*) FROM job_post WHERE (status = 'Active' OR status IS NULL) AND last_date >= CURRENT_DATE()";
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

    public int countClosedJobs() {
        String sql = "SELECT COUNT(*) FROM job_post WHERE ((status = 'Active' OR status IS NULL) AND last_date < CURRENT_DATE()) OR status = 'Rejected'";
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

    public int countPendingJobsByHR(int hrId) {
        String sql = "SELECT COUNT(*) FROM job_post WHERE hr_id = ? AND status = 'Pending'";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, hrId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countActiveJobsByHR(int hrId) {
        String sql = "SELECT COUNT(*) FROM job_post WHERE hr_id = ? AND (status = 'Active' OR status IS NULL) AND last_date >= CURRENT_DATE()";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, hrId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
