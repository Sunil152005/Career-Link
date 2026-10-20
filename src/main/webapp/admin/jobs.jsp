<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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

    String filter = request.getParameter("filter");
    if (filter == null || filter.trim().isEmpty()) {
        filter = "all";
    }

    List<Map<String, Object>> displayJobs = new ArrayList<>();
    int pendingCount = 0;
    int activeCount = 0;
    int rejectedCount = 0;

    for (Map<String, Object> j : allJobs) {
        String st = (String) j.get("status");
        if (st == null || st.trim().isEmpty()) st = "Active";
        
        if ("Pending".equalsIgnoreCase(st)) pendingCount++;
        else if ("Active".equalsIgnoreCase(st)) activeCount++;
        else if ("Rejected".equalsIgnoreCase(st)) rejectedCount++;

        if ("pending".equalsIgnoreCase(filter) && "Pending".equalsIgnoreCase(st)) {
            displayJobs.add(j);
        } else if ("active".equalsIgnoreCase(filter) && "Active".equalsIgnoreCase(st)) {
            displayJobs.add(j);
        } else if ("rejected".equalsIgnoreCase(filter) && "Rejected".equalsIgnoreCase(st)) {
            displayJobs.add(j);
        } else if ("all".equalsIgnoreCase(filter)) {
            displayJobs.add(j);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Moderation & Approvals - CareerLink Admin</title>
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
                <% if (pendingCount > 0) { %>
                    <span class="badge bg-warning text-dark ms-auto fw-bold"><%= pendingCount %></span>
                <% } %>
            </a>
            <a href="messages.jsp" class="sidebar-link">
                <i class="fa-solid fa-headset"></i>Support Inquiries
            </a>
        </div>

        <!-- Main Workspace -->
        <main class="dashboard-main-content">
            <div class="container-fluid animate-fade-in">
                <!-- Page Title -->
                <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between mb-4 gap-3">
                    <div>
                        <h2>Job Post Requests & Moderation</h2>
                        <p class="text-secondary small mb-0">Review recruiter job requests, approve vacancies to make them active, or moderate listings</p>
                    </div>
                </div>

                <!-- Notifications -->
                <% if ("true".equals(request.getParameter("approved"))) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 mb-4" role="alert" style="background: rgba(16, 185, 129, 0.15); border-left: 4px solid #10b981 !important;">
                        <i class="fa-solid fa-circle-check text-success me-2 fs-5"></i>
                        <strong>Job Post Approved Successfully!</strong> The job posting is now <strong>Active</strong> and visible to candidates across the portal.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } else if ("true".equals(request.getParameter("rejected"))) { %>
                    <div class="alert alert-warning alert-dismissible fade show shadow-sm border-0 mb-4" role="alert" style="background: rgba(245, 158, 11, 0.15); border-left: 4px solid #f59e0b !important;">
                        <i class="fa-solid fa-circle-xmark text-warning me-2 fs-5"></i>
                        <strong>Job Post Request Rejected.</strong> The job will not appear in candidate search results.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } else if ("true".equals(request.getParameter("deleted"))) { %>
                    <div class="alert alert-info alert-dismissible fade show shadow-sm border-0 mb-4" role="alert">
                        <i class="fa-solid fa-trash text-danger me-2"></i>Job post record and associated dependencies deleted.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <!-- Pending Approval Alert Notice if pending > 0 -->
                <% if (pendingCount > 0 && !"pending".equalsIgnoreCase(filter)) { %>
                    <div class="alert alert-warning border-0 shadow-sm d-flex align-items-center justify-content-between mb-4" style="background: rgba(245, 158, 11, 0.12); border-left: 4px solid #f59e0b !important; border-radius: 12px;">
                        <div>
                            <i class="fa-solid fa-bell text-warning fs-5 me-2"></i>
                            <strong><%= pendingCount %> Job Post Request(s) Awaiting Approval!</strong> Recruiters have submitted new job requisitions for review.
                        </div>
                        <a href="jobs.jsp?filter=pending" class="btn btn-warning btn-sm fw-bold px-3 py-1 text-dark">Review Pending Requests &rarr;</a>
                    </div>
                <% } %>

                <!-- Filter Pills -->
                <div class="d-flex flex-wrap gap-2 mb-4">
                    <a href="jobs.jsp?filter=all" class="btn btn-sm <%= "all".equalsIgnoreCase(filter) ? "btn-primary" : "btn-light border" %> px-3 py-2 fw-semibold" style="border-radius: 20px;">
                        All Postings <span class="badge <%= "all".equalsIgnoreCase(filter) ? "bg-white text-primary" : "bg-secondary" %> ms-1"><%= allJobs.size() %></span>
                    </a>
                    <a href="jobs.jsp?filter=pending" class="btn btn-sm <%= "pending".equalsIgnoreCase(filter) ? "btn-warning text-dark" : "btn-light border" %> px-3 py-2 fw-semibold" style="border-radius: 20px;">
                        <i class="fa-solid fa-clock-rotate-left me-1 text-warning"></i>Pending Approval
                        <span class="badge <%= "pending".equalsIgnoreCase(filter) ? "bg-dark text-warning" : "bg-warning text-dark" %> ms-1"><%= pendingCount %></span>
                    </a>
                    <a href="jobs.jsp?filter=active" class="btn btn-sm <%= "active".equalsIgnoreCase(filter) ? "btn-success" : "btn-light border" %> px-3 py-2 fw-semibold" style="border-radius: 20px;">
                        <i class="fa-solid fa-circle-check me-1 text-success"></i>Active Jobs
                        <span class="badge <%= "active".equalsIgnoreCase(filter) ? "bg-white text-success" : "bg-success text-white" %> ms-1"><%= activeCount %></span>
                    </a>
                    <a href="jobs.jsp?filter=rejected" class="btn btn-sm <%= "rejected".equalsIgnoreCase(filter) ? "btn-danger" : "btn-light border" %> px-3 py-2 fw-semibold" style="border-radius: 20px;">
                        <i class="fa-solid fa-circle-xmark me-1 text-danger"></i>Rejected
                        <span class="badge <%= "rejected".equalsIgnoreCase(filter) ? "bg-white text-danger" : "bg-danger text-white" %> ms-1"><%= rejectedCount %></span>
                    </a>
                </div>

                <!-- Jobs Table List -->
                <div class="glass-panel p-4">
                    <% if (displayJobs.isEmpty()) { %>
                        <div class="text-center py-5">
                            <i class="fa-solid fa-folder-open text-muted fs-1 mb-3"></i>
                            <h4>No Jobs Found</h4>
                            <p class="text-secondary mb-0">No job posts match the selected "<%= filter %>" filter.</p>
                            <% if (!"all".equalsIgnoreCase(filter)) { %>
                                <a href="jobs.jsp?filter=all" class="btn btn-outline-primary btn-sm mt-3">View All Jobs</a>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="table-glass-wrapper">
                            <table class="table-glass">
                                <thead>
                                    <tr>
                                        <th>Job ID</th>
                                        <th>Job Title</th>
                                        <th>Recruiter / Company</th>
                                        <th>Location</th>
                                        <th>Salary (Annum)</th>
                                        <th>Deadline</th>
                                        <th>Status</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> job : displayJobs) {
                                        int jobId = (Integer) job.get("jobId");
                                        String status = (String) job.get("status");
                                        if (status == null || status.trim().isEmpty()) status = "Active";
                                    %>
                                        <tr style="<%= "Pending".equalsIgnoreCase(status) ? "background: rgba(245, 158, 11, 0.05);" : "" %>">
                                            <td class="text-secondary small">#<%= jobId %></td>
                                            <td>
                                                <strong><%= job.get("title") %></strong>
                                                <% if ("Pending".equalsIgnoreCase(status)) { %>
                                                    <span class="badge bg-warning text-dark ms-1 small" style="font-size: 10px;">Awaiting Review</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <div class="text-indigo fw-bold"><i class="fa-solid fa-building me-1"></i><%= job.get("companyName") %></div>
                                                <div class="small text-muted"><%= job.get("hrName") %></div>
                                            </td>
                                            <td><span class="text-secondary"><i class="fa-solid fa-location-dot me-1 text-danger"></i><%= job.get("location") %></span></td>
                                            <td>$<%= String.format("%,.2f", job.get("salary")) %></td>
                                            <td class="text-secondary"><%= job.get("lastDate") %></td>
                                            <td>
                                                <% if ("Pending".equalsIgnoreCase(status)) { %>
                                                    <span class="badge" style="background: rgba(245, 158, 11, 0.15); color: #d97706; border: 1px solid rgba(245, 158, 11, 0.3); padding: 6px 12px; border-radius: 20px; font-weight: 600;">
                                                        <i class="fa-solid fa-clock-rotate-left me-1"></i>Pending
                                                    </span>
                                                <% } else if ("Active".equalsIgnoreCase(status)) { %>
                                                    <span class="badge" style="background: rgba(16, 185, 129, 0.15); color: #059669; border: 1px solid rgba(16, 185, 129, 0.3); padding: 6px 12px; border-radius: 20px; font-weight: 600;">
                                                        <i class="fa-solid fa-circle-check me-1"></i>Active
                                                    </span>
                                                <% } else if ("Rejected".equalsIgnoreCase(status)) { %>
                                                    <span class="badge" style="background: rgba(239, 68, 68, 0.15); color: #dc2626; border: 1px solid rgba(239, 68, 68, 0.3); padding: 6px 12px; border-radius: 20px; font-weight: 600;">
                                                        <i class="fa-solid fa-circle-xmark me-1"></i>Rejected
                                                    </span>
                                                <% } else { %>
                                                    <span class="badge bg-secondary"><%= status %></span>
                                                <% } %>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-inline-flex gap-2 align-items-center">
                                                    <% if ("Pending".equalsIgnoreCase(status)) { %>
                                                        <!-- Direct Approve Action -->
                                                        <a href="../job?action=approve&jobId=<%= jobId %>" class="btn btn-sm btn-success px-3 fw-bold" style="background: #10b981; border: none; font-size: 13px;" onclick="return confirm('Approve this job post? It will become active and available for candidates to apply.');">
                                                            <i class="fa-solid fa-check me-1"></i>Approve
                                                        </a>
                                                        <!-- Reject Action -->
                                                        <a href="../job?action=reject&jobId=<%= jobId %>" class="btn btn-sm btn-outline-warning px-2" style="font-size: 13px;" onclick="return confirm('Reject this job post request?');">
                                                            <i class="fa-solid fa-xmark me-1"></i>Reject
                                                        </a>
                                                    <% } else if ("Active".equalsIgnoreCase(status)) { %>
                                                        <!-- Option to Revoke/Reject -->
                                                        <a href="../job?action=reject&jobId=<%= jobId %>" class="btn btn-sm btn-outline-warning px-2" style="font-size: 12px;" onclick="return confirm('Suspend/Reject this active job post?');">
                                                            <i class="fa-solid fa-ban me-1"></i>Reject
                                                        </a>
                                                    <% } else if ("Rejected".equalsIgnoreCase(status)) { %>
                                                        <!-- Option to Re-Approve -->
                                                        <a href="../job?action=approve&jobId=<%= jobId %>" class="btn btn-sm btn-outline-success px-2" style="font-size: 12px;" onclick="return confirm('Re-approve this job post?');">
                                                            <i class="fa-solid fa-rotate-left me-1"></i>Approve
                                                        </a>
                                                    <% } %>

                                                    <!-- Delete Action -->
                                                    <a href="../job?action=delete&jobId=<%= jobId %>" class="btn btn-danger py-1 px-3 small border-0" style="font-size: 13px; background: rgba(239, 68, 68, 0.2); color: #f87171;" onclick="return confirm('Are you sure you want to delete this job post? It will permanently delete all matching applications.');">
                                                        <i class="fa-solid fa-trash me-1"></i>Delete
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
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