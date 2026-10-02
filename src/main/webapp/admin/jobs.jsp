<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.careerlink.dao.JobPostDAO" %>
<% 
    String admin = (String) session.getAttribute("admin");
    if (!"true".equals(admin)) {
        response.sendRedirect("../login.jsp");
        return;
    }
    JobPostDAO jobDao = new JobPostDAO();
    List<Map<String, Object>> allJobs = jobDao.listAllJobs();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monitor Jobs - CareerLink Admin</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <link href="../css/style.css?v=2026" rel="stylesheet">
</head>
<body>

    <!-- Header Navigation with User Avatar Dropdown -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="../index.jsp">
                <i class="fa-solid fa-link me-2 text-indigo"></i>CareerLink Admin
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="adminNavbarNav">
                <div class="ms-auto dropdown">
                    <button class="user-nav-dropdown-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="avatar-circle">
                            <i class="fa-solid fa-user-shield"></i>
                        </div>
                        <span class="d-none d-sm-inline">System Administrator</span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-glass">
                        <li class="dropdown-header-custom">
                            <div class="fw-bold text-primary">System Administrator</div>
                            <div class="small text-muted">admin@careerlink.com</div>
                            <span class="badge-neon selected mt-1">Platform Admin</span>
                        </li>
                        <li>
                            <a class="dropdown-item" href="dashboard.jsp">
                                <i class="fa-solid fa-user-gear me-2 text-indigo"></i>Admin Overview
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="messages.jsp">
                                <i class="fa-solid fa-headset me-2 text-info"></i>Support Inquiries
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

    <!-- Dashboard Container with Sidebar -->
    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <div class="sidebar-glass">
            <a href="dashboard.jsp" class="sidebar-link">
                <i class="fa-solid fa-gauge"></i>Overview
            </a>
            <a href="users.jsp" class="sidebar-link">
                <i class="fa-solid fa-users-gear"></i>Manage Users
            </a>
            <a href="jobs.jsp" class="sidebar-link active">
                <i class="fa-solid fa-briefcase"></i>Monitor Jobs
            </a>
            <a href="messages.jsp" class="sidebar-link">
                <i class="fa-solid fa-headset"></i>Support Inquiries
            </a>
        </div>

        <!-- Main Workspace -->
        <main class="dashboard-main-content">
            <div class="container-fluid animate-fade-in">
                <!-- Page Title -->
                <div class="mb-4">
                    <h2>Platform Job Audit</h2>
                    <p class="text-secondary small">Review, analyze, and moderate open vacancy postings published on CareerLink</p>
                </div>

                <!-- Jobs Table List -->
                <div class="glass-panel p-4">
                    <% if (allJobs.isEmpty()) { %>
                        <div class="text-center py-5">
                            <i class="fa-solid fa-folder-open text-muted fs-1 mb-3"></i>
                            <h4>No Jobs Published Yet</h4>
                            <p class="text-secondary mb-0">Currently there are no vacancies posted on the system.</p>
                        </div>
                    <% } else { %>
                        <div class="table-glass-wrapper">
                            <table class="table-glass">
                                <thead>
                                    <tr>
                                        <th>Job ID</th>
                                        <th>Job Title</th>
                                        <th>Company</th>
                                        <th>Location</th>
                                        <th>Salary (Annum)</th>
                                        <th>Deadline Date</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> job : allJobs) {
                                        int jobId = (Integer) job.get("jobId");
                                    %>
                                        <tr>
                                            <td class="text-secondary small">#<%= jobId %></td>
                                            <td><strong><%= job.get("title") %></strong></td>
                                            <td><span class="text-indigo fw-bold"><i class="fa-solid fa-building me-1"></i><%= job.get("companyName") %></span></td>
                                            <td><span class="text-secondary"><i class="fa-solid fa-location-dot me-1 text-danger"></i><%= job.get("location") %></span></td>
                                            <td>$<%= String.format("%,.2f", job.get("salary")) %></td>
                                            <td class="text-secondary"><%= job.get("lastDate") %></td>
                                            <td class="text-end">
                                                <a href="../job?action=delete&jobId=<%= jobId %>" class="btn btn-danger py-1 px-3 small border-0" style="font-size: 13px; background: rgba(239, 68, 68, 0.2); color: #f87171;" onclick="return confirm('Are you sure you want to delete this job post? It will delete all matching candidate applications.');">
                                                    <i class="fa-solid fa-trash me-1"></i>Delete Post
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
    <!-- Admin OTP Change Password Modal -->
    <div class="modal fade" id="otpChangePasswordModal" tabindex="-1" aria-labelledby="otpChangePasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 500px;">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 14px; overflow: hidden; background: #ffffff;">
                <div class="modal-header border-bottom px-4 py-3" style="background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%); color: #ffffff;">
                    <h5 class="modal-title fw-bold text-white mb-0"><i class="fa-solid fa-shield-halved me-2"></i>Admin Password Security</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="../otp-password" method="post" id="otpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'jobsAdminOtpAlertBox', 'btnSubmitJobsAdminOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to root administrator email: <strong>admin@careerlink.com</strong>
                        </p>
                        
                        <!-- OTP Dispatch Section -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendJobsAdminOtp" onclick="sendGlobalPasswordOtp(this, 'jobsAdminOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="jobsAdminOtpFeedback" style="display: none;"></div>
                        <div id="jobsAdminOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="jobsAdminOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="jobsAdminNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('jobsAdminNewPassword', this)" type="button">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="jobsAdminConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('jobsAdminConfirmPassword', this)" type="button">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitJobsAdminOtp">Update Password</button>
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