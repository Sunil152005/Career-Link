package com.careerlink.dao;

import com.careerlink.model.Candidate;
import com.careerlink.util.DBConnection;
import com.careerlink.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CandidateDAO {

    public boolean registerCandidate(Candidate candidate) {

        String sql = """
                INSERT INTO candidate
                (name, email, mobile, password, education, skills, experience, role)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            String hashedPassword =
                    PasswordUtil.hashPassword(candidate.getPassword());

            ps.setString(1, candidate.getName());
            ps.setString(2, candidate.getEmail());
            ps.setString(3, candidate.getMobile());
            ps.setString(4, hashedPassword);
            ps.setString(5, candidate.getEducation());
            ps.setString(6, candidate.getSkills());
            ps.setString(7, candidate.getExperience());

            // Candidate gets candidate role by default
            ps.setString(8, "CANDIDATE");

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
            return false;
        }
    }

    public Candidate login(String email, String password) {

        String sql =
                "SELECT * FROM candidate WHERE email=?";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    String storedPassword =
                            rs.getString("password");

                    boolean validPassword =
                            PasswordUtil.verifyPassword(
                                    password,
                                    storedPassword
                            );

                    if (!validPassword) {
                        return null;
                    }

                    Candidate candidate = new Candidate();

                    candidate.setCandidateId(
                            rs.getInt("candidate_id")
                    );

                    candidate.setName(
                            rs.getString("name")
                    );

                    candidate.setEmail(
                            rs.getString("email")
                    );

                    candidate.setMobile(
                            rs.getString("mobile")
                    );

                    candidate.setRole(
                            rs.getString("role")
                    );

                    return candidate;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    public boolean updateProfile(Candidate candidate) {
        String sql = """
                UPDATE candidate 
                SET name = ?, mobile = ?, education = ?, skills = ?, experience = ?, resume_path = ?
                WHERE candidate_id = ?
                """;
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, candidate.getName());
            ps.setString(2, candidate.getMobile());
            ps.setString(3, candidate.getEducation());
            ps.setString(4, candidate.getSkills());
            ps.setString(5, candidate.getExperience());
            ps.setString(6, candidate.getResumePath());
            ps.setInt(7, candidate.getCandidateId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Candidate getCandidateById(int candidateId) {
        String sql = "SELECT * FROM candidate WHERE candidate_id = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Candidate candidate = new Candidate();
                    candidate.setCandidateId(rs.getInt("candidate_id"));
                    candidate.setName(rs.getString("name"));
                    candidate.setEmail(rs.getString("email"));
                    candidate.setMobile(rs.getString("mobile"));
                    candidate.setEducation(rs.getString("education"));
                    candidate.setSkills(rs.getString("skills"));
                    candidate.setExperience(rs.getString("experience"));
                    candidate.setResumePath(rs.getString("resume_path"));
                    candidate.setRole(rs.getString("role"));
                    return candidate;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public java.util.List<Candidate> listAllCandidates() {
        java.util.List<Candidate> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM candidate WHERE role = 'CANDIDATE' ORDER BY candidate_id DESC";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Candidate candidate = new Candidate();
                candidate.setCandidateId(rs.getInt("candidate_id"));
                candidate.setName(rs.getString("name"));
                candidate.setEmail(rs.getString("email"));
                candidate.setMobile(rs.getString("mobile"));
                candidate.setEducation(rs.getString("education"));
                candidate.setSkills(rs.getString("skills"));
                candidate.setExperience(rs.getString("experience"));
                candidate.setResumePath(rs.getString("resume_path"));
                candidate.setRole(rs.getString("role"));
                list.add(candidate);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteCandidate(int candidateId) {
        String deleteInterviews = "DELETE FROM interview WHERE candidate_id = ?";
        String deleteApps = "DELETE FROM application WHERE candidate_id = ?";
        String deleteCandidate = "DELETE FROM candidate WHERE candidate_id = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try (
                PreparedStatement ps1 = con.prepareStatement(deleteInterviews);
                PreparedStatement ps2 = con.prepareStatement(deleteApps);
                PreparedStatement ps3 = con.prepareStatement(deleteCandidate)
            ) {
                ps1.setInt(1, candidateId);
                ps1.executeUpdate();
                
                ps2.setInt(1, candidateId);
                ps2.executeUpdate();
                
                ps3.setInt(1, candidateId);
                int rows = ps3.executeUpdate();
                
                con.commit();
                return rows > 0;
            } catch (java.sql.SQLException e) {
                con.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT candidate_id FROM candidate WHERE email = ?";
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

    public Candidate getCandidateByEmail(String email) {
        String sql = "SELECT * FROM candidate WHERE email = ?";
        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Candidate candidate = new Candidate();
                    candidate.setCandidateId(rs.getInt("candidate_id"));
                    candidate.setName(rs.getString("name"));
                    candidate.setEmail(rs.getString("email"));
                    candidate.setMobile(rs.getString("mobile"));
                    candidate.setEducation(rs.getString("education"));
                    candidate.setSkills(rs.getString("skills"));
                    candidate.setExperience(rs.getString("experience"));
                    candidate.setResumePath(rs.getString("resume_path"));
                    candidate.setRole(rs.getString("role"));
                    return candidate;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePassword(String email, String plainPassword) {
        String sql = "UPDATE candidate SET password = ? WHERE email = ?";
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
}