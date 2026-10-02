package com.careerlink.controller;

import java.io.IOException;

import com.careerlink.dao.ApplicationDAO;
import com.careerlink.model.Candidate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/apply")
public class ApplicationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        ApplicationDAO appDao = new ApplicationDAO();

        if ("apply".equalsIgnoreCase(action)) {
            Candidate candidate = (Candidate) session.getAttribute("candidate");
            if (candidate == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            boolean success = appDao.applyForJob(candidate.getCandidateId(), jobId);

            if (success) {
                response.sendRedirect("candidate/applications.jsp?success=true");
            } else {
                response.sendRedirect("candidate/jobs.jsp?error=already_applied");
            }

        } else if ("updateStatus".equalsIgnoreCase(action)) {
            if (!"HR".equals(role)) {
                response.sendRedirect("login.jsp");
                return;
            }
            int applicationId = Integer.parseInt(request.getParameter("applicationId"));
            String status = request.getParameter("status"); // "Shortlisted", "Rejected"

            appDao.updateStatus(applicationId, status);
            response.sendRedirect("hr/applicants.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
