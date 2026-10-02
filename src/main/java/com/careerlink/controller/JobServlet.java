package com.careerlink.controller;

import java.io.IOException;
import java.util.Map;

import com.careerlink.dao.JobPostDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/job")
public class JobServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<String, Object> hr = (Map<String, Object>) session.getAttribute("hr");
        
        if (hr == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int hrId = (Integer) hr.get("hrId");

        JobPostDAO jobDao = new JobPostDAO();

        if ("add".equalsIgnoreCase(action)) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String skills = request.getParameter("skills");
            String qualification = request.getParameter("qualification");
            String experience = request.getParameter("experience");
            double salary = 0.0;
            try {
                salary = Double.parseDouble(request.getParameter("salary"));
            } catch (Exception e) {}
            String location = request.getParameter("location");
            String lastDate = request.getParameter("lastDate");

            boolean success = jobDao.addJob(hrId, title, description, skills, qualification, experience, salary, location, lastDate);

            if (success) {
                response.sendRedirect("hr/jobs.jsp");
            } else {
                request.setAttribute("errorMessage", "Failed to add job post");
                request.getRequestDispatcher("hr/post-job.jsp").forward(request, response);
            }

        } else if ("update".equalsIgnoreCase(action)) {
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String skills = request.getParameter("skills");
            String qualification = request.getParameter("qualification");
            String experience = request.getParameter("experience");
            double salary = 0.0;
            try {
                salary = Double.parseDouble(request.getParameter("salary"));
            } catch (Exception e) {}
            String location = request.getParameter("location");
            String lastDate = request.getParameter("lastDate");

            boolean success = jobDao.updateJob(jobId, title, description, skills, qualification, experience, salary, location, lastDate);

            if (success) {
                response.sendRedirect("hr/jobs.jsp");
            } else {
                request.setAttribute("errorMessage", "Failed to update job post");
                request.getRequestDispatcher("hr/post-job.jsp?jobId=" + jobId).forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        JobPostDAO jobDao = new JobPostDAO();

        if ("delete".equalsIgnoreCase(action)) {
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            jobDao.deleteJob(jobId);
            
            if ("ADMIN".equals(role)) {
                response.sendRedirect("admin/jobs.jsp");
            } else {
                response.sendRedirect("hr/jobs.jsp");
            }
        }
    }
}
