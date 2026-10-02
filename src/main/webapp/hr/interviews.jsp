<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.careerlink.dao.InterviewDAO" %>
<%@ page import="com.careerlink.dao.ApplicationDAO" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    Map<String, Object> hr = (Map<String, Object>) session.getAttribute("hr");
    if (hr == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    int hrId = (Integer) hr.get("hrId");
    InterviewDAO interviewDao = new InterviewDAO();
    List<Map<String, Object>> interviews = interviewDao.getInterviewsByHR(hrId);

    ApplicationDAO appDao = new ApplicationDAO();
    List<Map<String, Object>> applicants = appDao.getApplicationsByHR(hrId);
    
    SimpleDateFormat displayDateFormat = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");

    String hrName = (String) hr.get("hrName");
    String companyName = (String) hr.get("companyName");
    String hrEmail = (String) hr.get("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scheduled Interviews - CareerLink</title>
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
                <!-- Center / Upper Navigation Links -->
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
                        <a href="interviews.jsp" class="nav-link-top active">
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
                    <h2>Scheduled Interview Roster</h2>
                    <p class="text-secondary small mb-0">Track upcoming interview slots, launch live video discussions, or manage venue details</p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn-premium" data-bs-toggle="modal" data-bs-target="#scheduleDirectModal">
                        <i class="fa-solid fa-calendar-plus me-2"></i>Schedule Meeting
                    </button>
                    <a href="applicants.jsp" class="btn-secondary-premium"><i class="fa-solid fa-users me-2 text-indigo"></i>View Applicants</a>
                </div>
            </div>

            <!-- Status Alerts -->
            <% if ("true".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success border-0 mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Interview successfully scheduled and confirmed!
                </div>
            <% } else if ("rescheduled".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success border-0 mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Interview slot has been updated successfully!
                </div>
            <% } else if ("cancelled".equals(request.getParameter("success"))) { %>
                <div class="alert alert-info border-0 mb-4" role="alert">
                    <i class="fa-solid fa-circle-info me-2"></i>Interview has been cancelled.
                </div>
            <% } else if ("completed".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success border-0 mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>Interview marked as Completed!
                </div>
            <% } else if ("failed".equals(request.getParameter("error")) || "scheduling_failed".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger border-0 mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Operation could not be performed. Try again.
                </div>
            <% } %>

            <!-- Interviews Table -->
            <div class="glass-panel p-4">
                <% if (interviews.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fa-solid fa-calendar-xmark text-muted fs-1 mb-3"></i>
                        <h4>No Scheduled Interviews</h4>
                        <p class="text-secondary mb-4">Schedule online video call slots or in-person interview meetings for your shortlisted candidates.</p>
                        <button type="button" class="btn-premium" data-bs-toggle="modal" data-bs-target="#scheduleDirectModal">
                            <i class="fa-solid fa-calendar-plus me-2"></i>Schedule Meeting Now
                        </button>
                    </div>
                <% } else { %>
                    <div class="table-glass-wrapper">
                        <table class="table-glass">
                            <thead>
                                <tr>
                                    <th>Interview ID</th>
                                    <th>Candidate Info</th>
                                    <th>Position</th>
                                    <th>Mode</th>
                                    <th>Timing & Location</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    for (Map<String, Object> it : interviews) { 
                                         int interviewId = (Integer) it.get("interviewId");
                                         String status = (String) it.get("status");
                                         String mode = (String) it.get("mode");
                                         if (mode == null || mode.trim().isEmpty()) mode = "Online";
                                         Timestamp ts = (Timestamp) it.get("interviewDate");
                                         String formattedDate = ts != null ? displayDateFormat.format(ts) : "Not Set";
                                         String resumePath = (String) it.get("resumePath");
                                         String meetingLink = (String) it.get("meetingLink");
                                         if (meetingLink == null || meetingLink.trim().isEmpty()) {
                                             meetingLink = "https://meet.jit.si/CareerLink-Interview-" + interviewId;
                                         }
                                         String venue = (String) it.get("venue");
                                         String notes = (String) it.get("notes");
                                %>
                                    <tr>
                                        <td class="text-secondary small fw-bold">#<%= interviewId %></td>
                                        <td>
                                            <strong><%= it.get("candidateName") %></strong>
                                            <div class="text-muted small"><i class="fa-solid fa-envelope me-1"></i><%= it.get("candidateEmail") %></div>
                                            <% if (it.get("candidateMobile") != null) { %>
                                                <div class="text-muted small"><i class="fa-solid fa-phone me-1"></i><%= it.get("candidateMobile") %></div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong><%= it.get("jobTitle") %></strong>
                                            <% if (notes != null && !notes.trim().isEmpty()) { %>
                                                <div class="text-muted small"><i class="fa-solid fa-note-sticky me-1 text-warning"></i><%= notes %></div>
                                            <% } %>
                                            <% if (resumePath != null && !resumePath.trim().isEmpty()) { %>
                                                <div>
                                                    <a href="../viewResume?path=<%= resumePath %>" target="_blank" class="text-indigo text-decoration-none small fw-semibold">
                                                        <i class="fa-solid fa-file-pdf me-1 text-danger"></i>View Resume
                                                    </a>
                                                </div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if ("Offline".equalsIgnoreCase(mode)) { %>
                                                <span class="badge-mode-offline">
                                                    <i class="fa-solid fa-building"></i> In-Person
                                                </span>
                                            <% } else { %>
                                                <span class="badge-mode-online">
                                                    <i class="fa-solid fa-video"></i> Online Call
                                                </span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="fw-semibold text-primary mb-1"><i class="fa-regular fa-calendar-check me-2 text-indigo"></i><%= formattedDate %></div>
                                            <% if ("Offline".equalsIgnoreCase(mode)) { %>
                                                <div class="small text-secondary"><i class="fa-solid fa-location-dot me-1 text-danger"></i><strong>Venue:</strong> <%= venue != null ? venue : "Company Office" %></div>
                                            <% } else { %>
                                                <a href="<%= meetingLink %>" target="_blank" class="btn-meeting-join py-1 px-3" style="font-size: 12px;">
                                                    <i class="fa-solid fa-video me-1"></i>Start Video Call
                                                </a>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="badge-neon <%= "Completed".equalsIgnoreCase(status) ? "completed" : "scheduled" %>">
                                                <%= status %>
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <div class="d-inline-flex gap-2">
                                                <% if (!"Completed".equalsIgnoreCase(status)) { %>
                                                    <button type="button" class="btn-secondary-premium py-1 px-2" style="font-size: 12px;" data-bs-toggle="modal" data-bs-target="#rescheduleModal<%= interviewId %>">
                                                        <i class="fa-solid fa-clock-rotate-left me-1"></i>Reschedule
                                                    </button>
                                                    <a href="../interview?action=complete&interviewId=<%= interviewId %>" class="btn btn-sm btn-outline-success py-1 px-2" style="font-size: 12px;" title="Mark as Finished">
                                                        <i class="fa-solid fa-circle-check me-1"></i>Done
                                                    </a>
                                                <% } %>
                                                <a href="../interview?action=cancel&interviewId=<%= interviewId %>" class="btn btn-sm btn-outline-danger py-1 px-2" style="font-size: 12px;" onclick="return confirm('Are you sure you want to cancel this interview slot?');">
                                                    <i class="fa-solid fa-trash me-1"></i>Cancel
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

    <!-- Reschedule Modals (Rendered at Body Level) -->
    <% 
        for (Map<String, Object> it : interviews) { 
             int interviewId = (Integer) it.get("interviewId");
             String mode = (String) it.get("mode");
             if (mode == null || mode.trim().isEmpty()) mode = "Online";
             Timestamp ts = (Timestamp) it.get("interviewDate");
             String formattedDate = ts != null ? displayDateFormat.format(ts) : "Not Set";
             String meetingLink = (String) it.get("meetingLink");
             String venue = (String) it.get("venue");
             String notes = (String) it.get("notes");
    %>
        <div class="modal fade" id="rescheduleModal<%= interviewId %>" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content modal-content-glass">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold"><i class="fa-solid fa-calendar-days me-2 text-indigo"></i>Reschedule Interview</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="../interview" method="post">
                        <input type="hidden" name="action" value="reschedule">
                        <input type="hidden" name="interviewId" value="<%= interviewId %>">

                        <div class="modal-body p-4 text-start">
                            <div class="bg-indigo-soft p-3 rounded-3 mb-4">
                                <div class="small text-secondary">Candidate: <strong class="text-primary"><%= it.get("candidateName") %></strong></div>
                                <div class="small text-secondary">Job: <strong class="text-primary"><%= it.get("jobTitle") %></strong></div>
                                <div class="small text-secondary">Current Slot: <strong class="text-primary"><%= formattedDate %></strong></div>
                            </div>

                            <!-- Interview Mode Selector -->
                            <div class="mb-3">
                                <label class="form-label-custom">Interview Mode</label>
                                <div class="d-flex gap-3 mt-1">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="interviewMode" id="reschedModeOnline_<%= interviewId %>" value="Online" <%= !"Offline".equalsIgnoreCase(mode) ? "checked" : "" %> onchange="toggleReschedMode(<%= interviewId %>, 'Online')">
                                        <label class="form-check-label fw-semibold" for="reschedModeOnline_<%= interviewId %>">
                                            <i class="fa-solid fa-video me-1 text-primary"></i>Online Video
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="interviewMode" id="reschedModeOffline_<%= interviewId %>" value="Offline" <%= "Offline".equalsIgnoreCase(mode) ? "checked" : "" %> onchange="toggleReschedMode(<%= interviewId %>, 'Offline')">
                                        <label class="form-check-label fw-semibold" for="reschedModeOffline_<%= interviewId %>">
                                            <i class="fa-solid fa-building me-1 text-warning"></i>Offline In-Person
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label-custom">New Interview Date & Time <span class="text-danger">*</span></label>
                                <input type="datetime-local" name="interviewDate" class="form-control form-control-glass" required>
                            </div>

                            <div class="mb-3" id="reschedOnlineGroup_<%= interviewId %>" style="<%= "Offline".equalsIgnoreCase(mode) ? "display: none;" : "display: block;" %>">
                                <label class="form-label-custom">Video Meeting Link</label>
                                <input type="url" name="meetingLink" class="form-control form-control-glass" value="<%= meetingLink != null ? meetingLink : "" %>">
                            </div>

                            <div class="mb-3" id="reschedOfflineGroup_<%= interviewId %>" style="<%= !"Offline".equalsIgnoreCase(mode) ? "display: none;" : "display: block;" %>">
                                <label class="form-label-custom">Venue Address / Office Location</label>
                                <input type="text" name="venue" class="form-control form-control-glass" value="<%= venue != null ? venue : "" %>">
                            </div>

                            <div class="mb-2">
                                <label class="form-label-custom">Notes / Instructions</label>
                                <input type="text" name="notes" class="form-control form-control-glass" value="<%= notes != null ? notes : "" %>" placeholder="e.g. Round 2 Discussion">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn-secondary-premium" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn-premium">Update Schedule</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <% } %>

    <!-- Direct Schedule Modal for Interviews Page -->
    <div class="modal fade" id="scheduleDirectModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-glass">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-calendar-plus me-2 text-indigo"></i>Schedule New Meeting</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="../interview" method="post">
                    <input type="hidden" name="redirectSource" value="interviews">
                    
                    <div class="modal-body p-4 text-start">
                        <% if (applicants.isEmpty()) { %>
                            <div class="alert alert-warning border-0 mb-3">
                                <i class="fa-solid fa-triangle-exclamation me-2"></i>No applicant records found yet. Wait for candidates to apply or review active jobs.
                            </div>
                        <% } else { %>
                            <div class="mb-3">
                                <label class="form-label-custom">Select Candidate Application <span class="text-danger">*</span></label>
                                <select class="form-select form-control-glass" id="directCandidateSelect" onchange="updateDirectFields(this);" required>
                                    <option value="" disabled selected>-- Select an Applicant --</option>
                                    <% for (Map<String, Object> a : applicants) { %>
                                        <option value="<%= a.get("applicationId") %>" 
                                                data-candidate-id="<%= a.get("candidateId") %>" 
                                                data-job-id="<%= a.get("jobId") %>"
                                                data-name="<%= a.get("candidateName") %>">
                                            <%= a.get("candidateName") %> &bull; <%= a.get("jobTitle") %> (Status: <%= a.get("status") %>)
                                        </option>
                                    <% } %>
                                </select>
                            </div>

                            <input type="hidden" name="candidateId" id="directCandidateId" value="">
                            <input type="hidden" name="jobId" id="directJobId" value="">
                            <input type="hidden" name="applicationId" id="directApplicationId" value="">

                            <!-- Mode Selector -->
                            <div class="mb-3">
                                <label class="form-label-custom">Interview Mode <span class="text-danger">*</span></label>
                                <div class="d-flex gap-3 mt-1">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="interviewMode" id="directModeOnline" value="Online" checked onchange="toggleDirectMode('Online')">
                                        <label class="form-check-label fw-semibold" for="directModeOnline">
                                            <i class="fa-solid fa-video me-1 text-primary"></i>Online Video
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="interviewMode" id="directModeOffline" value="Offline" onchange="toggleDirectMode('Offline')">
                                        <label class="form-check-label fw-semibold" for="directModeOffline">
                                            <i class="fa-solid fa-building me-1 text-warning"></i>Offline In-Person
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label-custom">Interview Date & Time <span class="text-danger">*</span></label>
                                <input type="datetime-local" name="interviewDate" class="form-control form-control-glass" required>
                            </div>

                            <div class="mb-3" id="directOnlineGroup">
                                <label class="form-label-custom">Video Meeting Room Link</label>
                                <div class="input-group">
                                    <input type="url" name="meetingLink" id="directMeetingLink" class="form-control form-control-glass" value="https://meet.jit.si/CareerLink-Slot-<%= System.currentTimeMillis() % 100000 %>">
                                    <button type="button" class="btn btn-outline-secondary" onclick="document.getElementById('directMeetingLink').value='https://meet.jit.si/CareerLink-Slot-' + Math.floor(Math.random()*89999+10000);">
                                        <i class="fa-solid fa-rotate"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-3" id="directOfflineGroup" style="display: none;">
                                <label class="form-label-custom">Venue Address / Office Location</label>
                                <input type="text" name="venue" id="directVenue" class="form-control form-control-glass" placeholder="e.g. Building 2, Floor 5, Corporate Headquarters">
                            </div>

                            <div class="mb-2">
                                <label class="form-label-custom">Interview Agenda / Notes</label>
                                <input type="text" name="notes" class="form-control form-control-glass" placeholder="e.g. Technical Screen, Cultural Fit">
                            </div>
                        <% } %>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-secondary-premium" data-bs-dismiss="modal">Cancel</button>
                        <% if (!applicants.isEmpty()) { %>
                            <button type="submit" class="btn-premium"><i class="fa-solid fa-calendar-check me-2"></i>Schedule Meeting</button>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>
    </div>

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
                <form action="../otp-password" method="post" id="hrInterviewsOtpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'hrInterviewsOtpAlertBox', 'btnSubmitHrInterviewsOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to your registered email: <strong><%= hrEmail %></strong>
                        </p>
                        
                        <!-- OTP Dispatch Button -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendHrInterviewsOtp" onclick="sendGlobalPasswordOtp(this, 'hrInterviewsOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="hrInterviewsOtpFeedback" style="display: none;"></div>
                        <div id="hrInterviewsOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="hrInterviewsOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="hrInterviewsNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('hrInterviewsNewPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="hrInterviewsConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('hrInterviewsConfirmPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitHrInterviewsOtp">Update Password</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/main.js?v=2026.5"></script>
    <script>
        function updateDirectFields(selectElem) {
            const opt = selectElem.options[selectElem.selectedIndex];
            document.getElementById('directCandidateId').value = opt.getAttribute('data-candidate-id');
            document.getElementById('directJobId').value = opt.getAttribute('data-job-id');
            document.getElementById('directApplicationId').value = opt.value;
        }

        function toggleDirectMode(mode) {
            const onlineGroup = document.getElementById('directOnlineGroup');
            const offlineGroup = document.getElementById('directOfflineGroup');
            if (mode === 'Offline') {
                onlineGroup.style.display = 'none';
                offlineGroup.style.display = 'block';
            } else {
                onlineGroup.style.display = 'block';
                offlineGroup.style.display = 'none';
            }
        }

        function toggleReschedMode(interviewId, mode) {
            const onlineGroup = document.getElementById('reschedOnlineGroup_' + interviewId);
            const offlineGroup = document.getElementById('reschedOfflineGroup_' + interviewId);
            if (mode === 'Offline') {
                onlineGroup.style.display = 'none';
                offlineGroup.style.display = 'block';
            } else {
                onlineGroup.style.display = 'block';
                offlineGroup.style.display = 'none';
            }
        }
    </script>
</body>
</html>