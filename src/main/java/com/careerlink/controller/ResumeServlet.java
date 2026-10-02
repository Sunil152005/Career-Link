package com.careerlink.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/viewResume")
public class ResumeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getParameter("path");
        if (path == null || path.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resume path not specified");
            return;
        }

        // Clean path to prevent path traversal
        path = path.replace("\\", "/");
        if (path.startsWith("/")) {
            path = path.substring(1);
        }

        // Try getting file from webapp root
        String appPath = getServletContext().getRealPath("");
        File file = new File(appPath, path);

        // Fallback to persistent home uploads directory if not in webapp
        if (!file.exists()) {
            String homePath = System.getProperty("user.home") + File.separator + ".careerlink_uploads";
            String fileName = path.substring(path.lastIndexOf('/') + 1);
            file = new File(homePath, fileName);
        }

        if (!file.exists()) {
            response.setContentType("text/html");
            response.getWriter().println("<!DOCTYPE html><html><head><title>Resume Not Found</title><link href='css/style.css' rel='stylesheet'></head><body style='font-family:sans-serif; text-align:center; padding:50px;'><h2>Resume File Not Found</h2><p style='color:#64748b;'>The candidate's uploaded resume file is not available on the server. Please ask the candidate to re-upload their resume.</p><button onclick='window.close()' style='padding:10px 20px; background:#4f46e5; color:white; border:none; border-radius:8px; cursor:pointer;'>Close Window</button></body></html>");
            return;
        }

        String mimeType = getServletContext().getMimeType(file.getAbsolutePath());
        if (mimeType == null) {
            if (path.toLowerCase().endsWith(".pdf")) {
                mimeType = "application/pdf";
            } else if (path.toLowerCase().endsWith(".png")) {
                mimeType = "image/png";
            } else if (path.toLowerCase().endsWith(".jpg") || path.toLowerCase().endsWith(".jpeg")) {
                mimeType = "image/jpeg";
            } else if (path.toLowerCase().endsWith(".docx")) {
                mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            } else {
                mimeType = "application/octet-stream";
            }
        }

        response.setContentType(mimeType);
        response.setContentLength((int) file.length());
        response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
