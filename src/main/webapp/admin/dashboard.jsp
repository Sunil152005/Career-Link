<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.careerlink.dao.CandidateDAO" %>
<%@ page import="com.careerlink.dao.HRDAO" %>
<%@ page import="com.careerlink.dao.JobPostDAO" %>
<%@ page import="com.careerlink.dao.ApplicationDAO" %>
<% 
    String admin = (String) session.getAttribute("admin");
    if (!"true".equals(admin)) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    CandidateDAO candidateDao = new CandidateDAO();
    HRDAO hrDao = new HRDAO();
    JobPostDAO jobDao = new JobPostDAO();
    ApplicationDAO appDao = new ApplicationDAO();
    
    int totalCandidates = candidateDao.listAllCandidates().size();
    int totalHR = hrDao.listAllHR().size();
    int activeJobs = jobDao.countActiveJobs();
    int closedJobs = jobDao.countClosedJobs();
    int totalJobs = activeJobs + closedJobs;
    int totalApplications = appDao.countApplications();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CareerLink</title>
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

    <!-- Dashboard Container with Left Sidebar for Admin -->
    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <div class="sidebar-glass">
            <a href="dashboard.jsp" class="sidebar-link active">
                <i class="fa-solid fa-gauge"></i>Overview
            </a>
            <a href="users.jsp" class="sidebar-link">
                <i class="fa-solid fa-users-gear"></i>Manage Users
            </a>
            <a href="jobs.jsp" class="sidebar-link">
                <i class="fa-solid fa-briefcase"></i>Monitor Jobs
            </a>
            <a href="messages.jsp" class="sidebar-link">
                <i class="fa-solid fa-headset"></i>Support Inquiries
            </a>
        </div>

        <!-- Main Workspace -->
        <main class="dashboard-main-content">
            <div class="container-fluid animate-fade-in">
                <!-- Welcome Section -->
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h2 class="mb-1">Platform Operations Control</h2>
                        <p class="text-secondary small">Analyze system metrics, manage user configurations, and audit vacancies</p>
                    </div>
                </div>

                <% if ("password_changed".equals(request.getParameter("success"))) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i>Admin password successfully updated!
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <!-- Stats Grid -->
                <div class="row g-4 mb-4">
                    <div class="col-md-6 col-lg-4 col-xl-2">
                        <div class="glass-panel stat-card primary h-100">
                            <div class="text-secondary small fw-bold uppercase">Total Candidates</div>
                            <div class="stat-value"><%= totalCandidates %></div>
                            <div class="text-indigo small"><a href="users.jsp" class="text-indigo text-decoration-none">Manage &rarr;</a></div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-2">
                        <div class="glass-panel stat-card secondary h-100">
                            <div class="text-secondary small fw-bold uppercase">Total Recruiters</div>
                            <div class="stat-value"><%= totalHR %></div>
                            <div class="text-pink small"><a href="users.jsp" class="text-pink text-decoration-none">Manage &rarr;</a></div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-2">
                        <div class="glass-panel stat-card success h-100">
                            <div class="text-secondary small fw-bold uppercase">Active Jobs</div>
                            <div class="stat-value"><%= activeJobs %></div>
                            <div class="text-success small"><a href="jobs.jsp" class="text-success text-decoration-none">Audit &rarr;</a></div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-2">
                        <div class="glass-panel stat-card warning h-100" style="--warning-glow: rgba(245, 158, 11, 0.35);">
                            <div class="text-secondary small fw-bold uppercase">Closed Jobs</div>
                            <div class="stat-value"><%= closedJobs %></div>
                            <div class="text-warning small"><a href="jobs.jsp" class="text-warning text-decoration-none">Audit &rarr;</a></div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-4">
                        <div class="glass-panel stat-card info h-100" style="--info-glow: rgba(6, 182, 212, 0.35);">
                            <div class="text-secondary small fw-bold uppercase">Total Applications</div>
                            <div class="stat-value"><%= totalApplications %></div>
                            <div class="text-info small"><i class="fa-solid fa-clock-rotate-left"></i> Global system count</div>
                        </div>
                    </div>
                </div>

                <!-- Admin Dashboard Overview visual blocks -->
                <div class="row g-4">
                    <div class="col-lg-12">
                        <div class="glass-panel p-4">
                            <h4 class="mb-3"><i class="fa-solid fa-triangle-exclamation me-2 text-indigo"></i>Admin Guidelines</h4>
                            <p class="text-secondary">As an administrator, you have complete authority to manage CareerLink platform data. Please perform user deletions and post removals with caution, as they cascade and clean up all foreign key dependencies in the relational database.</p>
                            <ul>
                                <li class="text-secondary mb-2">Deactivating/Deleting a candidate will delete their profile details, job applications history, and scheduled interviews.</li>
                                <li class="text-secondary mb-2">Deleting a Recruiter (HR) will delete their company association, their posted job vacancies, and all matching applications/interviews.</li>
                                <li class="text-secondary">Audit job descriptions to ensure they follow standard professional guidelines.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Admin OTP Change Password Modal -->
    <div class="modal fade" id="otpChangePasswordModal" tabindex="-1" aria-labelledby="otpChangePasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 500px;">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 14px; overflow: hidden; background: #ffffff;">
                <div class="modal-header border-bottom px-4 py-3" style="background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%); color: #ffffff;">
                    <h5 class="modal-title fw-bold text-white mb-0"><i class="fa-solid fa-shield-halved me-2"></i>Admin Password Security</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="../otp-password" method="post" id="otpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'adminOtpAlertBox', 'btnSubmitAdminOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to root administrator email: <strong>admin@careerlink.com</strong>
                        </p>
                        
                        <!-- OTP Dispatch Section -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendAdminOtp" onclick="sendGlobalPasswordOtp(this, 'adminOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="adminOtpFeedback" style="display: none;"></div>
                        <div id="adminOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="adminOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="adminNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('adminNewPassword', this)" type="button">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="adminConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('adminConfirmPassword', this)" type="button">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitAdminOtp">Update Password</button>
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