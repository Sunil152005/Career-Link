<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.careerlink.dao.JobPostDAO" %>
<% 
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    Map<String, Object> hr = (Map<String, Object>) session.getAttribute("hr");
    if (hr == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String jobIdStr = request.getParameter("jobId");
    Map<String, Object> job = null;
    boolean isEdit = false;

    if (jobIdStr != null && !jobIdStr.trim().isEmpty()) {
        try {
            int jobId = Integer.parseInt(jobIdStr);
            JobPostDAO jobDao = new JobPostDAO();
            job = jobDao.getJobById(jobId);
            if (job != null) {
                isEdit = true;
            }
        } catch (Exception e) {}
    }

    String hrName = (String) hr.get("hrName");
    String companyName = (String) hr.get("companyName");
    String hrEmail = (String) hr.get("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Job" : "Post a Job" %> - CareerLink</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <link href="../css/style.css?v=2026" rel="stylesheet">
</head>
<body>

    <!-- Upper Navbar with Links and User Profile Dropdown -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="../index.jsp">
                <i class="fa-solid fa-link me-2 text-indigo"></i>CareerLink
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#hrNavbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="hrNavbarNav">
                <!-- Center / Right Shifted Navigation Links -->
                <ul class="navbar-nav ms-auto navbar-nav-links me-3">
                    <li class="nav-item">
                        <a href="dashboard.jsp" class="nav-link-top">
                            <i class="fa-solid fa-gauge"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="post-job.jsp" class="nav-link-top active">
                            <i class="fa-solid fa-plus"></i>Post a Job
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="jobs.jsp" class="nav-link-top">
                            <i class="fa-solid fa-briefcase"></i>Manage Jobs
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="applicants.jsp" class="nav-link-top">
                            <i class="fa-solid fa-users"></i>Applicants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="interviews.jsp" class="nav-link-top">
                            <i class="fa-solid fa-calendar-days"></i>Interviews
                        </a>
                    </li>
                </ul>

                <!-- User Dropdown (Man/Avatar Icon with Settings & Logout) -->
                <div class="dropdown">
                    <button class="user-nav-dropdown-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="avatar-circle">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <span class="d-none d-sm-inline"><%= companyName %> (<%= hrName %>)</span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-glass">
                        <li class="dropdown-header-custom">
                            <div class="fw-bold text-primary"><%= companyName %></div>
                            <div class="small text-muted"><%= hrEmail %></div>
                            <span class="badge-neon applied mt-1">Recruiter</span>
                        </li>
                        <li>
                            <a class="dropdown-item" href="profile.jsp">
                                <i class="fa-solid fa-building-user me-2 text-indigo"></i>Edit Profile
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#otpChangePasswordModal">
                                <i class="fa-solid fa-key me-2 text-warning"></i>Change Password (OTP)
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item text-danger" href="../logout">
                                <i class="fa-solid fa-right-from-bracket me-2"></i>Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Workspace (Full Width Top Nav Layout) -->
    <main class="dashboard-top-nav-main">
        <div class="container-fluid animate-fade-in" style="max-width: 860px;">

            <div class="mb-4">
                <h2><%= isEdit ? "Edit Job Posting" : "Create Job Opportunity" %></h2>
                <p class="text-secondary small">Provide specific details to attract matching candidates for your team</p>
            </div>

            <!-- Post Job Form -->
            <div class="glass-panel p-4 p-md-5">
                <form action="../job" method="post">
                    <!-- Hidden controls -->
                    <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
                    <% if (isEdit) { %>
                        <input type="hidden" name="jobId" value="<%= jobIdStr %>">
                    <% } %>

                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label-custom">Job Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control form-control-glass" value="<%= isEdit && job.get("title") != null ? job.get("title") : "" %>" placeholder="e.g. Senior Java Developer" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label-custom">Job Description <span class="text-danger">*</span></label>
                            <textarea name="description" class="form-control form-control-glass" rows="5" placeholder="Specify roles, responsibilities, and team environment..." required><%= isEdit && job.get("description") != null ? job.get("description") : "" %></textarea>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Required Qualification</label>
                            <input type="text" name="qualification" class="form-control form-control-glass" value="<%= isEdit && job.get("qualification") != null ? job.get("qualification") : "" %>" placeholder="e.g. B.Tech in CS, MCA">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Required Experience</label>
                            <input type="text" name="experience" class="form-control form-control-glass" value="<%= isEdit && job.get("experience") != null ? job.get("experience") : "" %>" placeholder="e.g. 2-5 Years">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Job Location <span class="text-danger">*</span></label>
                            <input type="text" name="location" class="form-control form-control-glass" value="<%= isEdit && job.get("location") != null ? job.get("location") : "" %>" placeholder="e.g. New York, Remote" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Estimated Salary (USD / Annum)</label>
                            <input type="number" step="0.01" name="salary" class="form-control form-control-glass" value="<%= isEdit && job.get("salary") != null ? job.get("salary") : "" %>" placeholder="e.g. 95000">
                        </div>

                        <div class="col-12">
                            <label class="form-label-custom">Key Skills Required (Comma separated) <span class="text-danger">*</span></label>
                            <input type="text" name="skills" class="form-control form-control-glass" value="<%= isEdit && job.get("skills") != null ? job.get("skills") : "" %>" placeholder="e.g. Java, Spring Boot, Hibernate, REST APIs" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Application Deadline (Last Date) <span class="text-danger">*</span></label>
                            <input type="date" name="lastDate" class="form-control form-control-glass" value="<%= isEdit && job.get("lastDate") != null ? job.get("lastDate") : "" %>" required>
                        </div>

                        <div class="col-12 text-end mt-4">
                            <a href="jobs.jsp" class="btn-secondary-premium me-2 py-3 px-4">Cancel</a>
                            <button type="submit" class="btn-premium py-3 px-5">
                                <i class="fa-solid fa-cloud-arrow-up me-2"></i><%= isEdit ? "Save Changes" : "Publish Job" %>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <!-- OTP Change Password Modal -->
    <div class="modal fade" id="otpChangePasswordModal" tabindex="-1" aria-labelledby="otpChangePasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 500px;">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 14px; overflow: hidden; background: #ffffff;">
                <div class="modal-header border-bottom px-4 py-3" style="background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%); color: #ffffff;">
                    <h5 class="modal-title fw-bold text-white mb-0" id="otpChangePasswordModalLabel">
                        <i class="fa-solid fa-key me-2"></i>Change Password (OTP)
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="../otp-password" method="post" id="hrPostJobOtpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'hrPostJobOtpAlertBox', 'btnSubmitHrPostJobOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to your registered email: <strong><%= hrEmail %></strong>
                        </p>
                        
                        <!-- OTP Dispatch Button -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendHrPostJobOtp" onclick="sendGlobalPasswordOtp(this, 'hrPostJobOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="hrPostJobOtpFeedback" style="display: none;"></div>
                        <div id="hrPostJobOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="hrPostJobOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="hrPostJobNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('hrPostJobNewPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="hrPostJobConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('hrPostJobConfirmPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitHrPostJobOtp">Update Password</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/main.js?v=2026.5"></script>
</body>
</html>