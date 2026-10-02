package com.careerlink.controller;

import java.io.IOException;

import com.careerlink.dao.CandidateDAO;
import com.careerlink.dao.HRDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/adminAction")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("deleteCandidate".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            CandidateDAO dao = new CandidateDAO();
            dao.deleteCandidate(id);
            response.sendRedirect("admin/users.jsp");
            
        } else if ("deleteHR".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            HRDAO dao = new HRDAO();
            dao.deleteHR(id);
            response.sendRedirect("admin/users.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
