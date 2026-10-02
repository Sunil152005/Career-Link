package com.careerlink.dao;

import com.careerlink.util.DBConnection;
import com.careerlink.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HRDAO {

    public boolean registerHR(String companyName, String hrName, String email, String mobile, String password) {
        String sql = """
                INSERT INTO hr (company_name, hr_name, email, mobile, password)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            String hashedPassword = PasswordUtil.hashPassword(password);
            ps.setString(1, companyName);
            ps.setString(2, hrName);
            ps.setString(3, email);
            ps.setString(4, mobile);
            ps.setString(5, hashedPassword);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Object> login(String email, String password) {
        String sql = "SELECT * FROM hr WHERE email = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    if (PasswordUtil.verifyPassword(password, storedPassword)) {
                        Map<String, Object> hr = new HashMap<>();
                        hr.put("hrId", rs.getInt("hr_id"));
                        hr.put("companyName", rs.getString("company_name"));
                        hr.put("hrName", rs.getString("hr_name"));
                        hr.put("email", rs.getString("email"));
                        hr.put("mobile", rs.getString("mobile"));
                        hr.put("role", "HR");
                        return hr;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map<String, Object> getHRById(int hrId) {
        String sql = "SELECT * FROM hr WHERE hr_id = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, hrId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> hr = new HashMap<>();
                    hr.put("hrId", rs.getInt("hr_id"));
                    hr.put("companyName", rs.getString("company_name"));
                    hr.put("hrName", rs.getString("hr_name"));
                    hr.put("email", rs.getString("email"));
                    hr.put("mobile", rs.getString("mobile"));
                    return hr;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Map<String, Object>> listAllHR() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM hr ORDER BY hr_id DESC";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Map<String, Object> hr = new HashMap<>();
                hr.put("hrId", rs.getInt("hr_id"));
                hr.put("companyName", rs.getString("company_name"));
                hr.put("hrName", rs.getString("hr_name"));
                hr.put("email", rs.getString("email"));
                hr.put("mobile", rs.getString("mobile"));
                list.add(hr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getApplicantsByHR(int hrId) {
        ApplicationDAO appDao = new ApplicationDAO();
        return appDao.getApplicationsByHR(hrId);
    }

    public boolean deleteHR(int hrId) {
        String deleteInterviews = "DELETE FROM interview WHERE job_id IN (SELECT job_id FROM job_post WHERE hr_id = ?)";
        String deleteApps = "DELETE FROM application WHERE job_id IN (SELECT job_id FROM job_post WHERE hr_id = ?)";
        String deleteJobs = "DELETE FROM job_post WHERE hr_id = ?";
        String deleteHr = "DELETE FROM hr WHERE hr_id = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try (
                PreparedStatement ps1 = con.prepareStatement(deleteInterviews);
                PreparedStatement ps2 = con.prepareStatement(deleteApps);
                PreparedStatement ps3 = con.prepareStatement(deleteJobs);
                PreparedStatement ps4 = con.prepareStatement(deleteHr)
            ) {
                ps1.setInt(1, hrId);
                ps1.executeUpdate();
                
                ps2.setInt(1, hrId);
                ps2.executeUpdate();
                
                ps3.setInt(1, hrId);
                ps3.executeUpdate();
                
                ps4.setInt(1, hrId);
                int rows = ps4.executeUpdate();
                
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

    public boolean existsByEmail(String email) {
        String sql = "SELECT hr_id FROM hr WHERE email = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Object> getHRByEmail(String email) {
        String sql = "SELECT * FROM hr WHERE email = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> hr = new HashMap<>();
                    hr.put("hrId", rs.getInt("hr_id"));
                    hr.put("companyName", rs.getString("company_name"));
                    hr.put("hrName", rs.getString("hr_name"));
                    hr.put("email", rs.getString("email"));
                    hr.put("mobile", rs.getString("mobile"));
                    hr.put("role", "HR");
                    return hr;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePassword(String email, String plainPassword) {
        String sql = "UPDATE hr SET password = ? WHERE email = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            String hashedPassword = PasswordUtil.hashPassword(plainPassword);
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProfile(int hrId, String companyName, String hrName, String mobile) {
        String sql = "UPDATE hr SET company_name = ?, hr_name = ?, mobile = ? WHERE hr_id = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, companyName);
            ps.setString(2, hrName);
            ps.setString(3, mobile);
            ps.setInt(4, hrId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

