package com.careerlink.controller;

import com.careerlink.dao.ContactDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ContactDAO contactDao = new ContactDAO();
        HttpSession session = request.getSession();
        boolean isAdmin = "true".equals(session.getAttribute("admin")) || "ADMIN".equalsIgnoreCase((String) session.getAttribute("role"));
        boolean isAjax = isAjaxRequest(request);
        String cp = request.getContextPath();

        // 1. Resolve Inquiry (Admin Action)
        if ("resolve".equalsIgnoreCase(action)) {
            if (!isAdmin) {
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Administrator session required.\"}");
                } else {
                    response.sendRedirect(cp + "/login.jsp?role=admin");
                }
                return;
            }

            try {
                String idStr = request.getParameter("messageId");
                if (idStr == null || idStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Invalid message ID");
                }
                int messageId = Integer.parseInt(idStr.trim());
                String reply = request.getParameter("reply");
                if (reply == null || reply.trim().isEmpty()) {
                    reply = "Issue investigated and resolved by System Administrator.";
                }

                boolean updated = contactDao.resolveMessage(messageId, reply.trim());
                if (isAjax) {
                    response.setContentType("application/json");
                    if (updated) {
                        response.getWriter().write("{\"status\":\"success\", \"message\":\"Inquiry #" + messageId + " has been marked as Resolved.\", \"reply\":\"" + escapeJson(reply.trim()) + "\"}");
                    } else {
                        response.getWriter().write("{\"status\":\"error\", \"message\":\"Could not update inquiry status in database.\"}");
                    }
                } else {
                    if (updated) {
                        response.sendRedirect(cp + "/admin/messages.jsp?success=resolved");
                    } else {
                        response.sendRedirect(cp + "/admin/messages.jsp?error=update_failed");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                if (isAjax) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid inquiry parameters.\"}");
                } else {
                    response.sendRedirect(cp + "/admin/messages.jsp?error=invalid_id");
                }
            }
            return;
        }

        // 2. Delete Inquiry (Admin Action)
        if ("delete".equalsIgnoreCase(action)) {
            if (!isAdmin) {
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Administrator session required.\"}");
                } else {
                    response.sendRedirect(cp + "/login.jsp?role=admin");
                }
                return;
            }

            try {
                int messageId = Integer.parseInt(request.getParameter("messageId").trim());
                boolean deleted = contactDao.deleteMessage(messageId);
                if (isAjax) {
                    response.setContentType("application/json");
                    if (deleted) {
                        response.getWriter().write("{\"status\":\"success\", \"message\":\"Inquiry #" + messageId + " deleted successfully.\"}");
                    } else {
                        response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to delete inquiry from database.\"}");
                    }
                } else {
                    if (deleted) {
                        response.sendRedirect(cp + "/admin/messages.jsp?success=deleted");
                    } else {
                        response.sendRedirect(cp + "/admin/messages.jsp?error=delete_failed");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                if (isAjax) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Delete operation failed.\"}");
                } else {
                    response.sendRedirect(cp + "/admin/messages.jsp?error=delete_failed");
                }
            }
            return;
        }

        // 3. Handle user contact form submission from index.jsp
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (name != null && email != null && message != null) {
            boolean sent = contactDao.sendMessage(name.trim(), email.trim(), subject != null ? subject.trim() : "Support Inquiry", message.trim());
            if (sent) {
                response.sendRedirect(cp + "/index.jsp?contactSuccess=true#contact-section");
            } else {
                response.sendRedirect(cp + "/index.jsp?contactError=true#contact-section");
            }
        } else {
            response.sendRedirect(cp + "/index.jsp#contact-section");
        }
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
        return text.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
