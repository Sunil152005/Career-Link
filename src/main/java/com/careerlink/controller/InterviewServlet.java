package com.careerlink.controller;

import java.io.IOException;

import com.careerlink.dao.ApplicationDAO;
import com.careerlink.dao.InterviewDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/interview")
public class InterviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (!"HR".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        InterviewDAO interviewDao = new InterviewDAO();

        try {
            if ("reschedule".equalsIgnoreCase(action)) {
                int interviewId = Integer.parseInt(request.getParameter("interviewId"));
                String dateTime = request.getParameter("interviewDate");
                String mode = request.getParameter("interviewMode");
                String meetingLink = request.getParameter("meetingLink");
                String venue = request.getParameter("venue");
                String notes = request.getParameter("notes");

                boolean success = interviewDao.rescheduleInterview(interviewId, dateTime, mode, meetingLink, venue, notes);
                if (success) {
                    response.sendRedirect("hr/interviews.jsp?success=rescheduled");
                } else {
                    response.sendRedirect("hr/interviews.jsp?error=failed");
                }
                return;
            } else if ("cancel".equalsIgnoreCase(action)) {
                int interviewId = Integer.parseInt(request.getParameter("interviewId"));
                boolean success = interviewDao.deleteInterview(interviewId);
                if (success) {
                    response.sendRedirect("hr/interviews.jsp?success=cancelled");
                } else {
                    response.sendRedirect("hr/interviews.jsp?error=failed");
                }
                return;
            } else if ("complete".equalsIgnoreCase(action)) {
                int interviewId = Integer.parseInt(request.getParameter("interviewId"));
                boolean success = interviewDao.updateInterviewStatus(interviewId, "Completed");
                if (success) {
                    response.sendRedirect("hr/interviews.jsp?success=completed");
                } else {
                    response.sendRedirect("hr/interviews.jsp?error=failed");
                }
                return;
            }

            // Default Action: Schedule New Interview
            int candidateId = Integer.parseInt(request.getParameter("candidateId"));
            int jobId = Integer.parseInt(request.getParameter("jobId"));
            String applicationIdStr = request.getParameter("applicationId");
            String dateTime = request.getParameter("interviewDate"); // e.g. "2026-09-05T14:30"
            String mode = request.getParameter("interviewMode"); // "Online" or "Offline"
            String meetingLink = request.getParameter("meetingLink");
            String venue = request.getParameter("venue");
            String notes = request.getParameter("notes");
            String redirectSource = request.getParameter("redirectSource"); // "interviews" or "applicants"

            if (dateTime == null || dateTime.trim().isEmpty()) {
                if ("interviews".equalsIgnoreCase(redirectSource)) {
                    response.sendRedirect("hr/interviews.jsp?error=invalid_date");
                } else {
                    response.sendRedirect("hr/applicants.jsp?error=invalid_date");
                }
                return;
            }

            if (mode == null || mode.trim().isEmpty()) {
                mode = "Online";
            }

            if ("Online".equalsIgnoreCase(mode) && (meetingLink == null || meetingLink.trim().isEmpty())) {
                meetingLink = "https://meet.jit.si/CareerLink-Slot-" + System.currentTimeMillis();
            }

            boolean success = interviewDao.scheduleInterview(candidateId, jobId, dateTime, mode, meetingLink, venue, notes);

            if (success) {
                // Also update the job application status to "Interview Scheduled"
                if (applicationIdStr != null && !applicationIdStr.trim().isEmpty()) {
                    try {
                        int applicationId = Integer.parseInt(applicationIdStr);
                        ApplicationDAO appDao = new ApplicationDAO();
                        appDao.updateStatus(applicationId, "Interview Scheduled");
                    } catch (Exception ignored) {}
                }
                response.sendRedirect("hr/interviews.jsp?success=true");
            } else {
                if ("interviews".equalsIgnoreCase(redirectSource)) {
                    response.sendRedirect("hr/interviews.jsp?error=scheduling_failed");
                } else {
                    response.sendRedirect("hr/applicants.jsp?error=scheduling_failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("hr/applicants.jsp?error=scheduling_failed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
