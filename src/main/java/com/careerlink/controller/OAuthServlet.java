package com.careerlink.controller;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Map;

import com.careerlink.dao.CandidateDAO;
import com.careerlink.dao.HRDAO;
import com.careerlink.model.Candidate;
import com.careerlink.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/oauth-auth")
public class OAuthServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String provider = request.getParameter("provider"); // "google" or "linkedin"
        String roleType = request.getParameter("roleType"); // "candidate" or "hr"
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String companyName = request.getParameter("companyName");
        String password = request.getParameter("password");
        String isNewRegistration = request.getParameter("isNewRegistration"); // "true" or "false"

        // Social registration is strictly for Candidate and HR
        if (!"candidate".equalsIgnoreCase(roleType) && !"hr".equalsIgnoreCase(roleType)) {
            request.setAttribute("errorMessage", "Social registration is only available for Job Seekers and Recruiters.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Authentication requires a valid email address.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        email = email.trim().toLowerCase();
        HttpSession session = request.getSession();

        if ("hr".equalsIgnoreCase(roleType)) {
            HRDAO hrDao = new HRDAO();
            Map<String, Object> existingHr = hrDao.getHRByEmail(email);

            if (existingHr != null) {
                // If password was submitted, verify it
                if (password != null && !password.trim().isEmpty()) {
                    Map<String, Object> loggedInHr = hrDao.login(email, password);
                    if (loggedInHr == null) {
                        request.setAttribute("errorMessage", "Password authentication failed for " + email + ". Please check credentials.");
                        request.getRequestDispatcher("login.jsp?role=hr").forward(request, response);
                        return;
                    }
                    existingHr = loggedInHr;
                }

                session.setAttribute("hr", existingHr);
                session.setAttribute("role", "HR");
                response.sendRedirect("hr/dashboard.jsp");
                return;
            }

            // Register new HR account via Official Provider
            String finalCompanyName = (companyName != null && !companyName.trim().isEmpty()) 
                    ? companyName.trim() 
                    : (name != null ? name.trim() + " Enterprise" : "Enterprise Partner Inc.");
            String finalHrName = (name != null && !name.trim().isEmpty()) ? name.trim() : email.split("@")[0];
            String initialPassword = (password != null && password.length() >= 6) ? password : generateRandomPassword();

            boolean registered = hrDao.registerHR(finalCompanyName, finalHrName, email, "+1 555-0199", initialPassword);
            if (registered) {
                Map<String, Object> newHr = hrDao.getHRByEmail(email);
                session.setAttribute("hr", newHr);
                session.setAttribute("role", "HR");
                response.sendRedirect("hr/dashboard.jsp?welcome=social");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Email might already exist with another role.");
                request.getRequestDispatcher("register.jsp?role=hr").forward(request, response);
            }
            return;
        }

        // Job Seeker / Candidate
        CandidateDAO candidateDao = new CandidateDAO();
        Candidate existingCandidate = candidateDao.getCandidateByEmail(email);

        if (existingCandidate != null) {
            // If password was submitted, verify it
            if (password != null && !password.trim().isEmpty()) {
                Candidate loggedInCandidate = candidateDao.login(email, password);
                if (loggedInCandidate == null) {
                    request.setAttribute("errorMessage", "Password authentication failed for " + email + ". Please check credentials.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
                existingCandidate = loggedInCandidate;
            }

            session.setAttribute("candidate", existingCandidate);
            session.setAttribute("role", "CANDIDATE");
            response.sendRedirect("candidate/dashboard.jsp");
            return;
        }

        // Register new Candidate via Official Provider
        Candidate candidate = new Candidate();
        String finalName = (name != null && !name.trim().isEmpty()) ? name.trim() : email.split("@")[0];
        candidate.setName(finalName);
        candidate.setEmail(email);
        candidate.setMobile("+1 555-0100");
        candidate.setPassword((password != null && password.length() >= 6) ? password : generateRandomPassword());
        candidate.setEducation("Degree in Engineering / Science / Arts");
        candidate.setSkills("Java, Problem Solving, Teamwork");
        candidate.setExperience("Entry-Level / Experienced");

        boolean registered = candidateDao.registerCandidate(candidate);
        if (registered) {
            Candidate newCandidate = candidateDao.getCandidateByEmail(email);
            session.setAttribute("candidate", newCandidate);
            session.setAttribute("role", "CANDIDATE");
            response.sendRedirect("candidate/dashboard.jsp?welcome=social");
        } else {
            request.setAttribute("errorMessage", "Social registration failed. Email might already exist.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    private String generateRandomPassword() {
        byte[] bytes = new byte[16];
        new SecureRandom().nextBytes(bytes);
        StringBuilder sb = new StringBuilder("CL#");
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
