<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.careerlink.dao.CandidateDAO" %>
<%@ page import="com.careerlink.dao.HRDAO" %>
<%@ page import="com.careerlink.model.Candidate" %>
<%
    String admin = (String) session.getAttribute("admin");
    if (!"true".equals(admin)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    CandidateDAO candidateDao = new CandidateDAO();
    List<Candidate> candidates = candidateDao.listAllCandidates();

    HRDAO hrDao = new HRDAO();
    List<Map<String, Object>> recruiters = hrDao.listAllHR();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Platform Users - CareerLink Admin</title>
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
            <a href="users.jsp" class="sidebar-link active">
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
                <!-- Page Title -->
                <div class="mb-4">
                    <h2>User Account Administration</h2>
                    <p class="text-secondary small">Review registered candidates and corporate recruiter credentials</p>
                </div>

                <!-- Candidates Section -->
                <div class="glass-panel p-4 mb-4">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h4 class="mb-0"><i class="fa-solid fa-graduation-cap me-2 text-indigo"></i>Job Seekers (Candidates)</h4>
                        <span class="badge-neon applied"><%= candidates.size() %> Total</span>
                    </div>
                    <% if (candidates.isEmpty()) { %>
                        <p class="text-secondary mb-0">No job seeker accounts registered.</p>
                    <% } else { %>
                        <div class="table-glass-wrapper">
                            <table class="table-glass">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Mobile</th>
                                        <th>Education</th>
                                        <th>Experience</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Candidate c : candidates) { %>
                                        <tr>
                                            <td class="text-secondary small fw-bold">#<%= c.getCandidateId() %></td>
                                            <td><strong><%= c.getName() %></strong></td>
                                            <td><span class="text-secondary"><%= c.getEmail() %></span></td>
                                            <td><%= (c.getMobile() != null && !c.getMobile().trim().isEmpty()) ? c.getMobile() : "N/A" %></td>
                                            <td><%= (c.getEducation() != null && !c.getEducation().trim().isEmpty()) ? c.getEducation() : "N/A" %></td>
                                            <td><%= (c.getExperience() != null && !c.getExperience().trim().isEmpty()) ? c.getExperience() : "N/A" %></td>
                                            <td class="text-end">
                                                <a href="../adminAction?action=deleteCandidate&id=<%= c.getCandidateId() %>" class="btn btn-sm btn-outline-danger py-1 px-3" style="font-size: 12px;" onclick="return confirm('Are you sure you want to delete this candidate account? It will delete their applications and scheduled interviews.');">
                                                    <i class="fa-solid fa-trash me-1"></i>Delete
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>

                <!-- Recruiters Section -->
                <div class="glass-panel p-4" id="hr-section">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h4 class="mb-0"><i class="fa-solid fa-building me-2 text-violet"></i>Recruiters (Corporate HR)</h4>
                        <span class="badge-neon scheduled"><%= recruiters.size() %> Companies</span>
                    </div>
                    <% if (recruiters.isEmpty()) { %>
                        <p class="text-secondary mb-0">No recruiter accounts registered.</p>
                    <% } else { %>
                        <div class="table-glass-wrapper">
                            <table class="table-glass">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Company Name</th>
                                        <th>Representative</th>
                                        <th>Email</th>
                                        <th>Mobile</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> hr : recruiters) { %>
                                        <tr>
                                            <td class="text-secondary small fw-bold">#<%= hr.get("hrId") %></td>
                                            <td><strong class="text-primary"><%= hr.get("companyName") %></strong></td>
                                            <td><%= hr.get("hrName") %></td>
                                            <td><span class="text-secondary"><%= hr.get("email") %></span></td>
                                            <td><%= (hr.get("mobile") != null) ? hr.get("mobile") : "N/A" %></td>
                                            <td class="text-end">
                                                <a href="../adminAction?action=deleteHR&id=<%= hr.get("hrId") %>" class="btn btn-sm btn-outline-danger py-1 px-3" style="font-size: 12px;" onclick="return confirm('Are you sure you want to delete this recruiter account? It will delete all their job vacancies, applications, and scheduled interviews.');">
                                                    <i class="fa-solid fa-trash me-1"></i>Delete
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
                <form action="../otp-password" method="post" id="otpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'usersAdminOtpAlertBox', 'btnSubmitUsersAdminOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to root administrator email: <strong>admin@careerlink.com</strong>
                        </p>
                        
                        <!-- OTP Dispatch Section -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendUsersAdminOtp" onclick="sendGlobalPasswordOtp(this, 'usersAdminOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="usersAdminOtpFeedback" style="display: none;"></div>
                        <div id="usersAdminOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="usersAdminOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="usersAdminNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('usersAdminNewPassword', this)" type="button">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="usersAdminConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('usersAdminConfirmPassword', this)" type="button">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitUsersAdminOtp">Update Password</button>
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