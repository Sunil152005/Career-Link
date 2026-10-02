<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.careerlink.model.Candidate" %>
<%@ page import="com.careerlink.dao.JobPostDAO" %>
<%@ page import="com.careerlink.dao.ApplicationDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    Candidate candidate = (Candidate) session.getAttribute("candidate");
    if (candidate == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String searchQuery = request.getParameter("searchQuery");
    JobPostDAO jobDao = new JobPostDAO();
    List<Map<String, Object>> jobs;

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        jobs = jobDao.searchJobs(searchQuery);
    } else {
        jobs = jobDao.listAllJobs();
    }

    ApplicationDAO appDao = new ApplicationDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explore Jobs - CareerLink</title>
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
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#candidateNavbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="candidateNavbarNav">
                <!-- Center / Upper Navigation Links -->
                <ul class="navbar-nav ms-auto navbar-nav-links me-3">
                    <li class="nav-item">
                        <a href="dashboard.jsp" class="nav-link-top">
                            <i class="fa-solid fa-gauge"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="jobs.jsp" class="nav-link-top active">
                            <i class="fa-solid fa-briefcase"></i>Search Jobs
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="applications.jsp" class="nav-link-top">
                            <i class="fa-solid fa-file-invoice"></i>My Applications
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="interviews.jsp" class="nav-link-top">
                            <i class="fa-solid fa-calendar-days"></i>My Interviews
                        </a>
                    </li>
                </ul>

                <!-- User Dropdown (Man/Avatar Icon with Settings & Logout) -->
                <div class="dropdown">
                    <button class="user-nav-dropdown-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="avatar-circle">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <span class="d-none d-sm-inline"><%= candidate.getName() %></span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-glass">
                        <li class="dropdown-header-custom">
                            <div class="fw-bold text-primary"><%= candidate.getName() %></div>
                            <div class="small text-muted"><%= candidate.getEmail() %></div>
                            <span class="badge-neon applied mt-1">Job Seeker</span>
                        </li>
                        <li>
                            <a class="dropdown-item" href="profile.jsp">
                                <i class="fa-solid fa-user-pen me-2 text-indigo"></i>Edit Profile
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
        <div class="container-fluid animate-fade-in">
            <!-- Search Bar Section -->
            <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between mb-4 gap-3">
                <div>
                    <h2>Explore Job Openings</h2>
                    <p class="text-secondary small mb-0">Discover opportunities that align with your experience, skillsets, and salary goals</p>
                </div>
                <form action="jobs.jsp" method="get" class="d-flex gap-2" style="max-width: 420px; width: 100%;">
                    <input type="text" name="searchQuery" class="form-control form-control-glass" placeholder="Search by title, skills, location..." value="<%= searchQuery != null ? searchQuery : "" %>">
                    <button type="submit" class="btn-premium px-3"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
            </div>

            <!-- Display Errors -->
            <% if ("already_applied".equals(request.getParameter("error"))) { %>
                <div class="alert alert-warning border-0 mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>You have already applied to this job posting.
                </div>
            <% } %>

            <!-- Jobs Grid -->
            <% if (jobs.isEmpty()) { %>
                <div class="glass-panel text-center py-5">
                    <i class="fa-solid fa-briefcase text-muted fs-1 mb-3"></i>
                    <h4>No Job Openings Found</h4>
                    <p class="text-secondary">Try searching for other keywords or check back soon.</p>
                    <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                        <a href="jobs.jsp" class="btn-secondary-premium mt-2">Clear Search Filter</a>
                    <% } %>
                </div>
            <% } else { %>
                <div class="row g-4">
                    <% for (Map<String, Object> job : jobs) { 
                        int jobId = (Integer) job.get("jobId");
                        boolean alreadyApplied = appDao.hasApplied(candidate.getCandidateId(), jobId);
                    %>
                        <div class="col-lg-6">
                            <div class="glass-panel p-4 h-100 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <h4 class="mb-1 text-primary"><%= job.get("title") %></h4>
                                            <span class="text-secondary small fw-bold"><i class="fa-solid fa-building me-1 text-indigo"></i><%= job.get("companyName") %></span>
                                        </div>
                                        <span class="badge-neon applied"><i class="fa-solid fa-location-dot me-1"></i><%= job.get("location") %></span>
                                    </div>

                                    <div class="mb-3">
                                        <p class="text-secondary small mb-2" style="line-height: 1.5;"><%= job.get("description") %></p>
                                        <div class="d-flex flex-wrap gap-1 mt-2">
                                            <% 
                                                String skillsStr = (String) job.get("skills");
                                                if (skillsStr != null && !skillsStr.trim().isEmpty()) {
                                                    for (String skill : skillsStr.split(",")) {
                                            %>
                                                <span class="skill-tag" style="font-size: 11px;">
                                                    <%= skill.trim() %>
                                                </span>
                                            <%      } 
                                                }
                                            %>
                                        </div>
                                    </div>

                                    <div class="row text-secondary small mb-3 g-2 bg-light p-2 rounded-3">
                                        <div class="col-6">
                                            <i class="fa-solid fa-money-bill-wave me-1 text-success"></i><strong>Salary:</strong> $<%= String.format("%,.2f", job.get("salary")) %>
                                        </div>
                                        <div class="col-6">
                                            <i class="fa-solid fa-user-clock me-1 text-primary"></i><strong>Exp:</strong> <%= (job.get("experience") != null && !((String)job.get("experience")).trim().isEmpty()) ? job.get("experience") : "Not specified" %>
                                        </div>
                                        <div class="col-6">
                                            <i class="fa-solid fa-graduation-cap me-1 text-indigo"></i><strong>Degree:</strong> <%= (job.get("qualification") != null && !((String)job.get("qualification")).trim().isEmpty()) ? job.get("qualification") : "Any" %>
                                        </div>
                                        <div class="col-6">
                                            <i class="fa-solid fa-calendar-xmark me-1 text-danger"></i><strong>Deadline:</strong> <%= job.get("lastDate") %>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex align-items-center justify-content-between pt-3 border-top">
                                    <span class="text-muted small">Job Requisition #<%= jobId %></span>
                                    <% if (alreadyApplied) { %>
                                        <span class="badge-neon shortlisted"><i class="fa-solid fa-circle-check me-1"></i>Already Applied</span>
                                    <% } else { %>
                                        <form action="../apply" method="post" class="m-0">
                                            <input type="hidden" name="action" value="apply">
                                            <input type="hidden" name="jobId" value="<%= jobId %>">
                                            <button type="submit" class="btn-premium py-2 px-4" style="font-size: 13px;">
                                                <i class="fa-solid fa-paper-plane me-1"></i>Apply Now
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
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
                <form action="../otp-password" method="post" id="candJobsOtpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'candJobsOtpAlertBox', 'btnSubmitCandJobsOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to your registered email: <strong><%= candidate.getEmail() %></strong>
                        </p>
                        
                        <!-- OTP Dispatch Button -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendCandJobsOtp" onclick="sendGlobalPasswordOtp(this, 'candJobsOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="candJobsOtpFeedback" style="display: none;"></div>
                        <div id="candJobsOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="candJobsOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="candJobsNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('candJobsNewPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="candJobsConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('candJobsConfirmPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitCandJobsOtp">Update Password</button>
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