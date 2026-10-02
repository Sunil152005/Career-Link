package com.careerlink.controller;

import java.io.IOException;
import java.util.Map;

import com.careerlink.dao.CandidateDAO;
import com.careerlink.dao.HRDAO;
import com.careerlink.model.Candidate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleType = request.getParameter("roleType"); // "candidate", "hr", "admin"

        HttpSession session = request.getSession();

        // 1. Admin Login Check
        if ("admin".equalsIgnoreCase(roleType)) {
            com.careerlink.dao.AdminDAO adminDao = new com.careerlink.dao.AdminDAO();
            if (adminDao.validateAdmin(email, password)) {
                session.setAttribute("admin", "true");
                session.setAttribute("role", "ADMIN");
                response.sendRedirect("admin/dashboard.jsp");
                return;
            } else {
                request.setAttribute("errorMessage", "Invalid Admin credentials");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
        }

        // 2. HR Login Check
        if ("hr".equalsIgnoreCase(roleType)) {
            HRDAO hrDao = new HRDAO();
            Map<String, Object> hr = hrDao.login(email, password);
            if (hr != null) {
                session.setAttribute("hr", hr);
                session.setAttribute("role", "HR");
                response.sendRedirect("hr/dashboard.jsp");
                return;
            } else {
                request.setAttribute("errorMessage", "Invalid HR email or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
        }

        // 3. Candidate Login Check
        CandidateDAO candidateDao = new CandidateDAO();
        Candidate candidate = candidateDao.login(email, password);

        if (candidate != null) {
            session.setAttribute("candidate", candidate);
            session.setAttribute("role", "CANDIDATE");
            response.sendRedirect("candidate/dashboard.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid email or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
