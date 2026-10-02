<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.careerlink.dao.HRDAO" %>
<% 
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    Map<String, Object> hr = (Map<String, Object>) session.getAttribute("hr");
    if (hr == null) {
        response.sendRedirect("../login.jsp?role=hr");
        return;
    }

    int hrId = (Integer) hr.get("hrId");
    HRDAO hrDao = new HRDAO();
    Map<String, Object> freshHr = hrDao.getHRById(hrId);
    if (freshHr != null) {
        hr = freshHr;
        session.setAttribute("hr", freshHr);
    }

    String hrName = (String) hr.get("hrName");
    String companyName = (String) hr.get("companyName");
    String hrEmail = (String) hr.get("email");
    String mobile = (String) hr.get("mobile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Recruiter Profile - CareerLink</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <link href="../css/style.css?v=2026.3" rel="stylesheet">
</head>
<body>

    <!-- Upper Navbar with Right-Shifted Links and User Profile Dropdown -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="../index.jsp">
                <i class="fa-solid fa-link me-2 text-indigo"></i>CareerLink
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#hrNavbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="hrNavbarNav">
                <!-- Navigation Links Right Shifted Near User Icon -->
                <ul class="navbar-nav ms-auto navbar-nav-links me-3">
                    <li class="nav-item">
                        <a href="dashboard.jsp" class="nav-link-top">
                            <i class="fa-solid fa-gauge"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="post-job.jsp" class="nav-link-top">
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

                <!-- User Dropdown (Man/Avatar Icon with Edit Profile & Logout) -->
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
        <div class="container-fluid animate-fade-in" style="max-width: 820px;">

            <div class="mb-4">
                <h2>Manage Corporate Profile</h2>
                <p class="text-secondary small">Update your company details and representative contact information</p>
            </div>

            <!-- Notifications -->
            <% if ("true".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success border-0 mb-4 shadow-sm" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Recruiter profile details have been saved successfully!
                </div>
            <% } %>
            <% if ("true".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger border-0 mb-4 shadow-sm" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Failed to update profile. Please try again.
                </div>
            <% } %>
            <% if ("password_changed".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success border-0 mb-4 shadow-sm" role="alert">
                    <i class="fa-solid fa-shield-check me-2"></i>Account password has been successfully updated with encryption!
                </div>
            <% } %>

            <!-- Profile Form -->
            <div class="glass-panel p-4 p-md-5 mb-4">
                <form action="../hr-profile" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Company Name <span class="text-danger">*</span></label>
                            <input type="text" name="companyName" class="form-control form-control-glass" value="<%= companyName %>" placeholder="e.g. Acme Corp" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">HR Representative Name <span class="text-danger">*</span></label>
                            <input type="text" name="hrName" class="form-control form-control-glass" value="<%= hrName %>" placeholder="e.g. Sarah Jenkins" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Official Email (Read-only)</label>
                            <input type="email" class="form-control form-control-glass bg-light" value="<%= hrEmail %>" readonly style="cursor: not-allowed;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Contact Mobile Number</label>
                            <input type="text" name="mobile" class="form-control form-control-glass" value="<%= mobile != null ? mobile : "" %>" placeholder="+1 234 567 8900">
                        </div>

                        <!-- Account Security Card -->
                        <div class="col-12 mt-4 p-4 rounded-3 border" style="background: rgba(248, 250, 252, 0.8);">
                            <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                                <div>
                                    <div class="fw-bold text-dark mb-1">
                                        <i class="fa-solid fa-shield-halved me-2 text-indigo"></i>Account Security & Password
                                    </div>
                                    <div class="text-muted small">
                                        Password changes require 2-Factor OTP verification sent to your official registered email: <strong><%= hrEmail %></strong>.
                                    </div>
                                </div>
                                <button type="button" class="btn btn-outline-primary px-3 py-2 fw-semibold text-nowrap" data-bs-toggle="modal" data-bs-target="#otpChangePasswordModal">
                                    <i class="fa-solid fa-key me-2"></i>Change Password (OTP)
                                </button>
                            </div>
                        </div>

                        <div class="col-12 text-end pt-3 border-top mt-4">
                            <button type="submit" class="btn-premium px-5 py-3">
                                <i class="fa-solid fa-floppy-disk me-2"></i>Save Profile Changes
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
                <form action="../otp-password" method="post" id="hrOtpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'hrOtpAlertBox', 'btnSubmitHrOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to your registered email: <strong><%= hrEmail %></strong>
                        </p>
                        
                        <!-- OTP Dispatch Button -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendHrOtp" onclick="sendGlobalPasswordOtp(this, 'hrOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="hrOtpFeedback" style="display: none;"></div>
                        <div id="hrOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="hrOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="hrNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('hrNewPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="hrConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('hrConfirmPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitHrOtp">Update Password</button>
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
