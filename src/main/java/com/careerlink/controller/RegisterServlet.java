package com.careerlink.controller;

import java.io.IOException;

import com.careerlink.dao.CandidateDAO;
import com.careerlink.dao.HRDAO;
import com.careerlink.model.Candidate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String roleType = request.getParameter("roleType"); // "candidate" or "hr"

        if ("hr".equalsIgnoreCase(roleType)) {
            String companyName = request.getParameter("companyName");
            String hrName = request.getParameter("hrName");
            String email = request.getParameter("email");
            String mobile = request.getParameter("mobile");
            String password = request.getParameter("password");

            HRDAO hrDao = new HRDAO();
            boolean success = hrDao.registerHR(companyName, hrName, email, mobile, password);

            if (success) {
                request.setAttribute("successMessage", "HR registration successful. Please login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "HR registration failed. Email might already be registered.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            return;
        }

        // Default to Candidate
        Candidate candidate = new Candidate();
        candidate.setName(request.getParameter("name"));
        candidate.setEmail(request.getParameter("email"));
        candidate.setMobile(request.getParameter("mobile"));
        candidate.setPassword(request.getParameter("password"));
        candidate.setEducation(request.getParameter("education"));
        candidate.setSkills(request.getParameter("skills"));
        candidate.setExperience(request.getParameter("experience"));

        CandidateDAO dao = new CandidateDAO();
        boolean success = dao.registerCandidate(candidate);

        if (success) {
            request.setAttribute("successMessage", "Registration successful. Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed. Email might already be registered.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
