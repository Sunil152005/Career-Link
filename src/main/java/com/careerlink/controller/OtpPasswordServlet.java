package com.careerlink.controller;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Map;

import com.careerlink.dao.AdminDAO;
import com.careerlink.dao.CandidateDAO;
import com.careerlink.dao.HRDAO;
import com.careerlink.model.Candidate;
import com.careerlink.util.EmailService;
import com.careerlink.util.SmsService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/otp-password")
public class OtpPasswordServlet extends HttpServlet {

    private static final int MAX_OTP_ATTEMPTS = 5;
    private static final long OTP_VALIDITY_MS = 10 * 60 * 1000; // 10 minutes
    private static final long SEND_COOLDOWN_MS = 15 * 1000;      // 15 seconds

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        boolean isAdmin = "true".equals(session.getAttribute("admin")) || "ADMIN".equalsIgnoreCase(role);
        Candidate candidate = (Candidate) session.getAttribute("candidate");
        Map<String, Object> hr = (Map<String, Object>) session.getAttribute("hr");

        boolean isAjax = isAjaxRequest(request);

        if (!isAdmin && (role == null || (candidate == null && hr == null))) {
            if (isAjax) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Session expired. Please refresh the page and log in again.\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        String userEmail;
        String userName;
        String userMobile = null;
        String redirectUrl;

        if (isAdmin) {
            userEmail = "admin@careerlink.com";
            userName = "System Administrator";
            redirectUrl = request.getContextPath() + "/admin/dashboard.jsp";
        } else if ("HR".equalsIgnoreCase(role)) {
            userEmail = (String) hr.get("email");
            userName = (String) hr.get("hrName");
            userMobile = (String) hr.get("mobile");
            redirectUrl = request.getContextPath() + "/hr/profile.jsp";
        } else {
            userEmail = candidate.getEmail();
            userName = candidate.getName();
            userMobile = candidate.getMobile();
            redirectUrl = request.getContextPath() + "/candidate/profile.jsp";
        }

        String action = request.getParameter("action");

        // 1. Dispatch OTP Action
        if ("sendOtp".equalsIgnoreCase(action)) {
            Long lastSent = (Long) session.getAttribute("passwordResetLastSent");
            long now = System.currentTimeMillis();

            if (lastSent != null && (now - lastSent) < SEND_COOLDOWN_MS) {
                long waitSecs = (SEND_COOLDOWN_MS - (now - lastSent)) / 1000;
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Please wait " + (waitSecs + 1) + " seconds before requesting a new OTP.\"}");
                return;
            }

            // Generate cryptographically secure 6-digit OTP
            int otpNum = 100000 + new SecureRandom().nextInt(900000);
            String otpCode = String.valueOf(otpNum);
            long expiryTime = now + OTP_VALIDITY_MS;

            session.setAttribute("passwordResetOtp", otpCode);
            session.setAttribute("passwordResetOtpExpiry", expiryTime);
            session.setAttribute("passwordResetEmail", userEmail);
            session.setAttribute("passwordResetAttempts", 0);
            session.setAttribute("passwordResetLastSent", now);

            // Dispatch to registered Email / Gmail and Mobile
            EmailService.sendOtpEmail(userEmail, userName, otpCode);
            if (userMobile != null && !userMobile.trim().isEmpty()) {
                SmsService.sendOtpSms(userMobile, otpCode);
            }

            String maskedEmail = EmailService.maskEmail(userEmail);
            String maskedMobile = (userMobile != null && !userMobile.trim().isEmpty()) ? EmailService.maskMobile(userMobile) : "";

            response.setContentType("application/json; charset=UTF-8");
            // NOTE: Never return the OTP code itself in the client response for high security!
            String mobileMsg = !maskedMobile.isEmpty() ? " and mobile (" + maskedMobile + ")" : "";
            response.getWriter().write("{\"status\":\"success\", \"message\":\"Verification OTP sent to your registered email (" + maskedEmail + ")" + mobileMsg + ". Check your inbox.\", \"maskedEmail\":\"" + maskedEmail + "\"}");
            return;
        }

        // 2. Verify OTP & Change Password Action
        if ("verifyOtpChange".equalsIgnoreCase(action)) {
            String enteredOtp = request.getParameter("otp");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            String sessionOtp = (String) session.getAttribute("passwordResetOtp");
            Long expiry = (Long) session.getAttribute("passwordResetOtpExpiry");
            Integer attempts = (Integer) session.getAttribute("passwordResetAttempts");
            if (attempts == null) attempts = 0;

            // Validate OTP Expiry or Missing Session OTP
            if (sessionOtp == null || expiry == null || System.currentTimeMillis() > expiry) {
                String errorMsg = "OTP code has expired or was not requested. Please click 'Send OTP Code' to receive a new OTP.";
                if (isAjax) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"" + escapeJson(errorMsg) + "\"}");
                } else {
                    session.setAttribute("flashError", errorMsg);
                    response.sendRedirect(redirectUrl + "?error=otp_expired");
                }
                return;
            }

            // Check max attempts
            if (attempts >= MAX_OTP_ATTEMPTS) {
                session.removeAttribute("passwordResetOtp");
                session.removeAttribute("passwordResetOtpExpiry");
                session.removeAttribute("passwordResetAttempts");
                String errorMsg = "Too many failed attempts. For security, this OTP has been invalidated. Please request a new OTP.";
                if (isAjax) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"" + escapeJson(errorMsg) + "\"}");
                } else {
                    session.setAttribute("flashError", errorMsg);
                    response.sendRedirect(redirectUrl + "?error=max_attempts");
                }
                return;
            }

            // Strictly Validate OTP Match
            String cleanEnteredOtp = enteredOtp != null ? enteredOtp.trim() : "";
            if (!sessionOtp.equals(cleanEnteredOtp)) {
                attempts++;
                session.setAttribute("passwordResetAttempts", attempts);
                int remaining = MAX_OTP_ATTEMPTS - attempts;
                String errorMsg = "Incorrect OTP code. Please enter the valid 6-digit OTP sent to your registered email. (" + remaining + " attempts remaining)";
                if (isAjax) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"" + escapeJson(errorMsg) + "\"}");
                } else {
                    session.setAttribute("flashError", errorMsg);
                    response.sendRedirect(redirectUrl + "?error=invalid_otp");
                }
                return;
            }

            // Validate New Password
            if (newPassword == null || newPassword.trim().length() < 6) {
                String errorMsg = "New password must be at least 6 characters in length.";
                if (isAjax) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"" + escapeJson(errorMsg) + "\"}");
                } else {
                    session.setAttribute("flashError", errorMsg);
                    response.sendRedirect(redirectUrl + "?error=short_password");
                }
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                String errorMsg = "Passwords do not match. Please re-enter identical passwords.";
                if (isAjax) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"" + escapeJson(errorMsg) + "\"}");
                } else {
                    session.setAttribute("flashError", errorMsg);
                    response.sendRedirect(redirectUrl + "?error=password_mismatch");
                }
                return;
            }

            // Execute Password Update in DB
            boolean updated = false;
            if (isAdmin) {
                AdminDAO adminDao = new AdminDAO();
                updated = adminDao.updatePassword("admin@careerlink.com", newPassword.trim());
            } else if ("HR".equalsIgnoreCase(role)) {
                HRDAO hrDao = new HRDAO();
                updated = hrDao.updatePassword(userEmail, newPassword.trim());
            } else {
                CandidateDAO candidateDao = new CandidateDAO();
                updated = candidateDao.updatePassword(userEmail, newPassword.trim());
            }

            if (updated) {
                // Invalidate session OTP immediately
                session.removeAttribute("passwordResetOtp");
                session.removeAttribute("passwordResetOtpExpiry");
                session.removeAttribute("passwordResetAttempts");
                session.removeAttribute("passwordResetLastSent");

                String successMsg = "Account password updated successfully with high-grade PBKDF2 encryption!";
                if (isAjax) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"status\":\"success\", \"message\":\"" + escapeJson(successMsg) + "\"}");
                } else {
                    session.setAttribute("flashSuccess", successMsg);
                    response.sendRedirect(redirectUrl + "?success=password_changed");
                }
            } else {
                String errorMsg = "Database error while updating credentials. Please try again.";
                if (isAjax) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"" + escapeJson(errorMsg) + "\"}");
                } else {
                    session.setAttribute("flashError", errorMsg);
                    response.sendRedirect(redirectUrl + "?error=update_failed");
                }
            }
            return;
        }

        response.sendRedirect(redirectUrl);
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        String format = request.getParameter("format");
        return "XMLHttpRequest".equalsIgnoreCase(requestedWith) 
                || (accept != null && accept.contains("application/json"))
                || "json".equalsIgnoreCase(format);
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
