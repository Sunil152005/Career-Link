<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.careerlink.model.Candidate" %>
<%@ page import="com.careerlink.dao.InterviewDAO" %>
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

    InterviewDAO interviewDao = new InterviewDAO();
    List<Map<String, Object>> interviews = interviewDao.getInterviewsByCandidate(candidate.getCandidateId());

    SimpleDateFormat displayDateFormat = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Scheduled Interviews - CareerLink</title>
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
                        <a href="interviews.jsp" class="nav-link-top active">
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
            <!-- Page Title -->
            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h2>Scheduled Interview Rounds</h2>
                    <p class="text-secondary small mb-0">Check upcoming discussions, mode details (Online/Offline), and launch virtual video call rooms directly</p>
                </div>
                <a href="jobs.jsp" class="btn-secondary-premium"><i class="fa-solid fa-magnifying-glass me-2 text-indigo"></i>Explore More Jobs</a>
            </div>

            <!-- Interviews List / Cards -->
            <div class="glass-panel p-4">
                <% if (interviews.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fa-solid fa-calendar-xmark text-muted fs-1 mb-3"></i>
                        <h4>No Scheduled Interviews Yet</h4>
                        <p class="text-secondary mb-4">Once hiring managers review and shortlist your application, interview invitations will appear here.</p>
                        <a href="jobs.jsp" class="btn-premium"><i class="fa-solid fa-briefcase me-2"></i>Browse Active Jobs</a>
                    </div>
                <% } else { %>
                    <div class="table-glass-wrapper">
                        <table class="table-glass">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Job Position</th>
                                    <th>Company & Recruiter</th>
                                    <th>Mode</th>
                                    <th>Timing</th>
                                    <th>Venue / Meeting</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    for (Map<String, Object> it : interviews) { 
                                        int interviewId = (Integer) it.get("interviewId");
                                        String status = (String) it.get("status");
                                        String mode = (String) it.get("mode");
                                        if (mode == null) mode = "Online";
                                        String venue = (String) it.get("venue");
                                        Timestamp ts = (Timestamp) it.get("interviewDate");
                                        String formattedDate = ts != null ? displayDateFormat.format(ts) : "To be confirmed";
                                        String meetingLink = (String) it.get("meetingLink");
                                        if (meetingLink == null || meetingLink.trim().isEmpty()) {
                                            meetingLink = "https://meet.jit.si/CareerLink-Interview-" + interviewId;
                                        }
                                        String notes = (String) it.get("notes");
                                %>
                                    <tr>
                                        <td class="text-secondary small fw-bold">#<%= interviewId %></td>
                                        <td>
                                            <strong><%= it.get("jobTitle") %></strong>
                                            <div class="text-secondary small"><i class="fa-solid fa-location-dot me-1 text-muted"></i><%= it.get("location") %></div>
                                            <% if (notes != null && !notes.trim().isEmpty()) { %>
                                                <div class="text-muted small mt-1"><i class="fa-solid fa-note-sticky me-1 text-warning"></i><%= notes %></div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong class="text-primary"><i class="fa-solid fa-building me-1 text-indigo"></i><%= it.get("companyName") %></strong>
                                            <div class="text-muted small">Recruiter: <%= it.get("hrName") %> (<%= it.get("hrEmail") %>)</div>
                                            <% if (it.get("hrMobile") != null) { %>
                                                <div class="text-muted small"><i class="fa-solid fa-phone me-1"></i><%= it.get("hrMobile") %></div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if ("Offline".equalsIgnoreCase(mode)) { %>
                                                <span class="badge-mode-offline"><i class="fa-solid fa-building me-1"></i>In-Person</span>
                                            <% } else { %>
                                                <span class="badge-mode-online"><i class="fa-solid fa-video me-1"></i>Online</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="fw-semibold text-primary"><i class="fa-regular fa-calendar-check me-2 text-indigo"></i><%= formattedDate %></div>
                                        </td>
                                        <td>
                                            <% if ("Offline".equalsIgnoreCase(mode)) { %>
                                                <div class="small fw-semibold text-dark">
                                                    <i class="fa-solid fa-map-pin me-1 text-danger"></i><%= (venue != null && !venue.trim().isEmpty()) ? venue : "Company Premises" %>
                                                </div>
                                            <% } else { %>
                                                <a href="<%= meetingLink %>" target="_blank" class="btn-meeting-join py-1 px-3" title="Join Video Discussion">
                                                    <i class="fa-solid fa-video me-1"></i>Join Video Call
                                                </a>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="badge-neon <%= "Completed".equalsIgnoreCase(status) ? "completed" : "scheduled" %>">
                                                <%= status %>
                                            </span>
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
                <form action="../otp-password" method="post" id="candInterviewsOtpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'candInterviewsOtpAlertBox', 'btnSubmitCandInterviewsOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to your registered email: <strong><%= candidate.getEmail() %></strong>
                        </p>
                        
                        <!-- OTP Dispatch Button -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendCandInterviewsOtp" onclick="sendGlobalPasswordOtp(this, 'candInterviewsOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="candInterviewsOtpFeedback" style="display: none;"></div>
                        <div id="candInterviewsOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="candInterviewsOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="candInterviewsNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('candInterviewsNewPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="candInterviewsConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('candInterviewsConfirmPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitCandInterviewsOtp">Update Password</button>
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
