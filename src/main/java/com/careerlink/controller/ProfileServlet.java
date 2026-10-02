package com.careerlink.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import com.careerlink.dao.CandidateDAO;
import com.careerlink.model.Candidate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class ProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Candidate sessionCandidate = (Candidate) session.getAttribute("candidate");

        if (sessionCandidate == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String education = request.getParameter("education");
        String skills = request.getParameter("skills");
        String experience = request.getParameter("experience");

        Candidate candidate = new Candidate();
        candidate.setCandidateId(sessionCandidate.getCandidateId());
        candidate.setName(name);
        candidate.setMobile(mobile);
        candidate.setEducation(education);
        candidate.setSkills(skills);
        candidate.setExperience(experience);
        candidate.setResumePath(sessionCandidate.getResumePath()); // Default to existing

        // Handling File Upload for Resume
        try {
            Part filePart = request.getPart("resumeFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9._-]", "_");

                // 1. Save into webapp uploads folder
                String applicationPath = request.getServletContext().getRealPath("");
                if (applicationPath != null) {
                    String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
                    File uploadFolder = new File(uploadFilePath);
                    if (!uploadFolder.exists()) {
                        uploadFolder.mkdirs();
                    }
                    filePart.write(uploadFilePath + File.separator + uniqueFileName);
                }

                // 2. Also save into persistent user home directory to survive WAR redeploys
                try {
                    String homeFolder = System.getProperty("user.home") + File.separator + ".careerlink_uploads";
                    File persistentDir = new File(homeFolder);
                    if (!persistentDir.exists()) {
                        persistentDir.mkdirs();
                    }
                    File persistentFile = new File(persistentDir, uniqueFileName);
                    try (InputStream in = filePart.getInputStream();
                         OutputStream out = new FileOutputStream(persistentFile)) {
                        byte[] buf = new byte[4096];
                        int len;
                        while ((len = in.read(buf)) > 0) {
                            out.write(buf, 0, len);
                        }
                    }
                } catch (Exception ignored) {}

                // Save relative path to DB
                candidate.setResumePath(UPLOAD_DIR + "/" + uniqueFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        CandidateDAO dao = new CandidateDAO();
        boolean success = dao.updateProfile(candidate);



        if (success) {
            // Update candidate details in session
            Candidate updated = dao.getCandidateById(sessionCandidate.getCandidateId());
            session.setAttribute("candidate", updated);
            response.sendRedirect("candidate/profile.jsp?success=true");
        } else {
            response.sendRedirect("candidate/profile.jsp?error=true");
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf("=") + 2, token.length() - 1);
                return new File(name).getName();
            }
        }
        return "resume.pdf";
    }
}
