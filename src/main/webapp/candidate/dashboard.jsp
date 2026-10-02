<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.careerlink.model.Candidate" %>
<%@ page import="com.careerlink.dao.ApplicationDAO" %>
<%@ page import="com.careerlink.dao.InterviewDAO" %>
<%@ page import="com.careerlink.dao.JobPostDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    Candidate candidate = (Candidate) session.getAttribute("candidate");
    if (candidate == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ApplicationDAO appDao = new ApplicationDAO();
    List<Map<String, Object>> applications = appDao.getApplicationsByCandidate(candidate.getCandidateId());
    
    InterviewDAO interviewDao = new InterviewDAO();
    List<Map<String, Object>> interviews = interviewDao.getInterviewsByCandidate(candidate.getCandidateId());

    JobPostDAO jobDao = new JobPostDAO();
    List<Map<String, Object>> recommendedJobs = jobDao.getRecommendedJobs(candidate.getSkills());

    int totalApplied = applications.size();
    int totalInterviews = interviews.size();

    SimpleDateFormat displayDateFormat = new SimpleDateFormat("MMM dd, yyyy - hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Seeker Dashboard - CareerLink</title>
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
                        <a href="dashboard.jsp" class="nav-link-top active">
                            <i class="fa-solid fa-gauge"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="jobs.jsp" class="nav-link-top">
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
            <!-- Flash Alerts -->
            <% if ("password_changed".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success border-0 mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Password has been updated successfully with strong encryption!
                </div>
            <% } %>

            <!-- Welcome Section -->
            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h2>Welcome back, <%= candidate.getName().split(" ")[0] %>!</h2>
                    <p class="text-secondary small mb-0">Track your job applications, upcoming interview schedules, and personalized job matches</p>
                </div>
                <a href="jobs.jsp" class="btn-premium"><i class="fa-solid fa-magnifying-glass me-2"></i>Explore Vacancies</a>
            </div>

            <!-- Stats Grid -->
            <div class="row g-4 mb-4">
                <div class="col-md-6 col-lg-4">
                    <div class="glass-panel stat-card primary">
                        <div class="text-secondary small fw-bold uppercase">Applications Submitted</div>
                        <div class="stat-value"><%= totalApplied %></div>
                        <div class="text-indigo small"><a href="applications.jsp" class="text-indigo text-decoration-none fw-semibold">View Applications &rarr;</a></div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="glass-panel stat-card accent">
                        <div class="text-secondary small fw-bold uppercase">Scheduled Interviews</div>
                        <div class="stat-value"><%= totalInterviews %></div>
                        <div class="text-pink small"><a href="interviews.jsp" class="text-pink text-decoration-none fw-semibold"><i class="fa-solid fa-calendar-days me-1"></i>View Schedule &rarr;</a></div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="glass-panel stat-card success">
                        <div class="text-secondary small fw-bold uppercase">Profile Status</div>
                        <div class="stat-value text-success" style="font-size: 26px;">Active & Ready</div>
                        <div class="text-success small"><a href="profile.jsp" class="text-success text-decoration-none fw-semibold">Manage Profile &rarr;</a></div>
                    </div>
                </div>
            </div>

            <!-- Live Interviews and Recent Submissions Grid -->
            <div class="row g-4 mb-4">
                <!-- Upcoming Interviews Box -->
                <div class="col-lg-6">
                    <div class="glass-panel p-4 h-100">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <h4 class="mb-0"><i class="fa-solid fa-calendar-check me-2 text-pink"></i>Upcoming Interviews</h4>
                            <a href="interviews.jsp" class="text-pink text-decoration-none small fw-semibold">View All &rarr;</a>
                        </div>
                        <% if (interviews.isEmpty()) { %>
                            <div class="text-center py-5">
                                <i class="fa-solid fa-calendar-xmark text-muted fs-1 mb-3"></i>
                                <p class="text-secondary mb-0">No interviews scheduled yet. Continue applying to open roles!</p>
                            </div>
                        <% } else { %>
                            <div class="table-glass-wrapper">
                                <table class="table-glass">
                                    <thead>
                                        <tr>
                                            <th>Position</th>
                                            <th>Company</th>
                                            <th>Mode</th>
                                            <th>Date & Time</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                            int count = 0;
                                            for (Map<String, Object> it : interviews) { 
                                                if (count++ >= 4) break;
                                                int itId = (Integer) it.get("interviewId");
                                                String mode = (String) it.get("mode");
                                                if (mode == null) mode = "Online";
                                                Timestamp ts = (Timestamp) it.get("interviewDate");
                                                String formattedDate = ts != null ? displayDateFormat.format(ts) : "Scheduled";
                                                String meetingLink = (String) it.get("meetingLink");
                                                if (meetingLink == null || meetingLink.trim().isEmpty()) {
                                                    meetingLink = "https://meet.jit.si/CareerLink-Interview-" + itId;
                                                }
                                        %>
                                            <tr>
                                                <td><strong><%= it.get("jobTitle") %></strong></td>
                                                <td><span class="text-secondary"><%= it.get("companyName") %></span></td>
                                                <td>
                                                    <% if ("Offline".equalsIgnoreCase(mode)) { %>
                                                        <span class="badge-mode-offline"><i class="fa-solid fa-building"></i> Offline</span>
                                                    <% } else { %>
                                                        <a href="<%= meetingLink %>" target="_blank" class="btn-meeting-join py-1 px-2" style="font-size: 11px;">
                                                            <i class="fa-solid fa-video me-1"></i>Join
                                                        </a>
                                                    <% } %>
                                                </td>
                                                <td><span class="text-primary fw-semibold small"><%= formattedDate %></span></td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Recommended Opportunities Grid -->
                <div class="col-lg-6">
                    <div class="glass-panel p-4 h-100">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <h4 class="mb-0"><i class="fa-solid fa-wand-magic-sparkles me-2 text-indigo"></i>Matching Opportunities</h4>
                            <a href="jobs.jsp" class="text-indigo text-decoration-none small fw-semibold">Search All &rarr;</a>
                        </div>
                        <% if (recommendedJobs.isEmpty()) { %>
                            <div class="text-center py-5">
                                <i class="fa-solid fa-briefcase text-muted fs-1 mb-3"></i>
                                <p class="text-secondary mb-0">No matching jobs found. Update your profile skills to get tailored recommendations!</p>
                            </div>
                        <% } else { %>
                            <div class="d-flex flex-column gap-3">
                                <% 
                                    int jobCount = 0;
                                    for (Map<String, Object> rJob : recommendedJobs) { 
                                        if (jobCount++ >= 3) break;
                                        int jobId = (Integer) rJob.get("jobId");
                                %>
                                    <div class="p-3 rounded-3 border bg-white d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="mb-1 text-primary fw-bold"><%= rJob.get("title") %></h6>
                                            <div class="text-muted small"><%= rJob.get("companyName") %> • <%= rJob.get("location") %></div>
                                        </div>
                                        <a href="jobs.jsp?searchQuery=<%= rJob.get("title") %>" class="btn-secondary-premium py-1 px-3" style="font-size: 13px;">
                                            View Post
                                        </a>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                </div>
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
                <form action="../otp-password" method="post" id="candDashOtpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'candDashOtpAlertBox', 'btnSubmitCandDashOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to your registered email: <strong><%= candidate.getEmail() %></strong>
                        </p>
                        
                        <!-- OTP Dispatch Button -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendCandDashOtp" onclick="sendGlobalPasswordOtp(this, 'candDashOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="candDashOtpFeedback" style="display: none;"></div>
                        <div id="candDashOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="candDashOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="candDashNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('candDashNewPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="candDashConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('candDashConfirmPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitCandDashOtp">Update Password</button>
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