package com.careerlink.controller;

import java.io.IOException;
import java.util.Map;

import com.careerlink.dao.CandidateDAO;
import com.careerlink.dao.HRDAO;
import com.careerlink.dao.PasswordResetDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/forgot-password", "/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token != null && !token.trim().isEmpty()) {
            PasswordResetDAO resetDao = new PasswordResetDAO();
            Map<String, Object> tokenData = resetDao.validateToken(token);

            if (tokenData != null) {
                request.setAttribute("token", token);
                request.setAttribute("email", tokenData.get("email"));
                request.setAttribute("roleType", tokenData.get("roleType"));
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("errorMessage", "The password reset link is invalid or has expired. Please request a new one.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
        }

        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        PasswordResetDAO resetDao = new PasswordResetDAO();

        if ("completeReset".equalsIgnoreCase(action)) {
            String token = request.getParameter("token");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (token == null || token.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Invalid reset request token.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }

            if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match. Please re-enter.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }

            Map<String, Object> tokenData = resetDao.validateToken(token);
            if (tokenData == null) {
                request.setAttribute("errorMessage", "This reset link has expired or has already been used. Please request a new link.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }

            String email = (String) tokenData.get("email");
            String roleType = (String) tokenData.get("roleType");

            boolean updated = false;
            if ("HR".equalsIgnoreCase(roleType)) {
                HRDAO hrDao = new HRDAO();
                updated = hrDao.updatePassword(email, newPassword);
            } else {
                CandidateDAO candidateDao = new CandidateDAO();
                updated = candidateDao.updatePassword(email, newPassword);
            }

            if (updated) {
                resetDao.markTokenUsed(token);
                request.setAttribute("successMessage", "Password has been successfully reset with strong encryption! You can now log in.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Could not update password. Please try again.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }
            return;
        }

        // Default Action: Request Reset Link
        String email = request.getParameter("email");
        String roleType = request.getParameter("roleType"); // "candidate" or "hr"

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please provide a valid registered email address.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        boolean exists = false;

        if ("hr".equalsIgnoreCase(roleType)) {
            HRDAO hrDao = new HRDAO();
            exists = hrDao.existsByEmail(email);
        } else {
            CandidateDAO candidateDao = new CandidateDAO();
            exists = candidateDao.existsByEmail(email);
        }

        if (!exists) {
            request.setAttribute("errorMessage", "No registered account found with email: " + email + " for role: " + (roleType != null ? roleType.toUpperCase() : "CANDIDATE"));
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        String rawToken = resetDao.createResetToken(email, roleType != null ? roleType : "candidate");
        if (rawToken != null) {
            String resetUrl = request.getContextPath() + "/reset-password?token=" + rawToken;
            request.setAttribute("successMessage", "Secure password reset authorization generated!");
            request.setAttribute("resetToken", rawToken);
            request.setAttribute("resetUrl", resetUrl);
            request.setAttribute("email", email);
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Unable to generate reset authorization at this moment. Please try again.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
}
