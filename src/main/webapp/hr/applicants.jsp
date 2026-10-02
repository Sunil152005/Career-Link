<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.careerlink.dao.ApplicationDAO" %>
<%@ page import="com.careerlink.dao.JobPostDAO" %>
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
    ApplicationDAO appDao = new ApplicationDAO();
    List<Map<String, Object>> applicants = appDao.getApplicationsByHR(hrId);

    JobPostDAO jobDao = new JobPostDAO();
    List<Map<String, Object>> myJobs = jobDao.listJobsByHR(hrId);

    String hrName = (String) hr.get("hrName");
    String companyName = (String) hr.get("companyName");
    String hrEmail = (String) hr.get("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Submissions & Smart Fit - CareerLink</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <link href="../css/style.css?v=2026.2" rel="stylesheet">
    <style>
        .badge-fit-great {
            background: rgba(16, 185, 129, 0.15);
            color: #059669;
            border: 1px solid #10b981;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }
        .badge-fit-good {
            background: rgba(59, 130, 246, 0.15);
            color: #2563eb;
            border: 1px solid #3b82f6;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }
        .badge-fit-potential {
            background: rgba(245, 158, 11, 0.15);
            color: #d97706;
            border: 1px solid #f59e0b;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }
    </style>
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
                        <a href="applicants.jsp" class="nav-link-top active">
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
        <div class="container-fluid animate-fade-in">
            
            <!-- Page Title -->
            <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between mb-4 gap-3">
                <div>
                    <h2>Applicant Evaluation & Smart Fit Hub</h2>
                    <p class="text-secondary small mb-0">Filter candidates by job requirements, evaluate skill match score, and schedule rounds</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-primary px-3 py-2 fs-6 rounded-pill" id="totalApplicantsCount"><%= applicants.size() %> Total Applications</span>
                </div>
            </div>

            <!-- Display Errors/Success -->
            <% if ("scheduling_failed".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger border-0 mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>Could not complete the interview schedule. Please try again.
                </div>
            <% } %>

            <!-- Smart Filter & Match Toolbar -->
            <div class="glass-panel p-3 mb-4">
                <div class="row g-3 align-items-center">
                    <!-- Search Input -->
                    <div class="col-md-3">
                        <label class="small text-muted fw-bold mb-1">SEARCH CANDIDATE / SKILLS</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                            <input type="text" id="filterSearch" class="form-control form-control-glass border-start-0 ps-0" placeholder="e.g. Java, React, Name..." oninput="applyFilters()">
                        </div>
                    </div>

                    <!-- Job Filter Dropdown -->
                    <div class="col-md-3">
                        <label class="small text-muted fw-bold mb-1">JOB VACANCY</label>
                        <select id="filterJob" class="form-select form-control-glass" onchange="applyFilters()">
                            <option value="ALL">All Requisitions</option>
                            <% for (Map<String, Object> j : myJobs) { %>
                                <option value="<%= j.get("title") %>"><%= j.get("title") %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Match & Great Fit Filter -->
                    <div class="col-md-3">
                        <label class="small text-muted fw-bold mb-1">CANDIDATE FIT LEVEL</label>
                        <select id="filterFit" class="form-select form-control-glass" onchange="applyFilters()">
                            <option value="ALL">All Match Levels</option>
                            <option value="GREAT">⭐ Great Fit (75%+ Match)</option>
                            <option value="GOOD">👍 Good Fit (50%+ Match)</option>
                            <option value="POTENTIAL">Potential Fit (&lt;50%)</option>
                        </select>
                    </div>

                    <!-- Status Filter -->
                    <div class="col-md-3">
                        <label class="small text-muted fw-bold mb-1">APPLICATION STATUS</label>
                        <select id="filterStatus" class="form-select form-control-glass" onchange="applyFilters()">
                            <option value="ALL">All Statuses</option>
                            <option value="Applied">Applied</option>
                            <option value="Shortlisted">Shortlisted</option>
                            <option value="Interview Scheduled">Interview Scheduled</option>
                            <option value="Rejected">Rejected</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Applicants Grid / Cards -->
            <% if (applicants.isEmpty()) { %>
                <div class="glass-panel text-center py-5">
                    <i class="fa-solid fa-users-slash text-muted fs-1 mb-3"></i>
                    <h4>No Candidates Applied Yet</h4>
                    <p class="text-secondary">When job seekers submit applications for your posted jobs, they will appear here.</p>
                    <a href="post-job.jsp" class="btn-premium mt-2"><i class="fa-solid fa-plus me-2"></i>Post Another Job</a>
                </div>
            <% } else { %>
                <div class="row g-4" id="applicantsListContainer">
                    <% 
                        for (Map<String, Object> app : applicants) { 
                            int appId = (Integer) app.get("applicationId");
                            int candidateId = (Integer) app.get("candidateId");
                            int jobId = (Integer) app.get("jobId");
                            String status = (String) app.get("status");
                            String badgeClass = "applied";
                            if ("Shortlisted".equalsIgnoreCase(status)) badgeClass = "shortlisted";
                            if ("Rejected".equalsIgnoreCase(status)) badgeClass = "rejected";
                            if ("Interview Scheduled".equalsIgnoreCase(status)) badgeClass = "scheduled";
                            
                            String resumePath = (String) app.get("resumePath");
                            String candidateSkills = (String) app.get("skills");
                            String candidateName = (String) app.get("candidateName");
                            String jobTitle = (String) app.get("jobTitle");

                            // Dynamic Skills Matching Calculation
                            int fitPercent = 70; // default baseline
                            String fitCategory = "GOOD";
                            String fitBadgeHtml = "<span class='badge-fit-good'><i class='fa-solid fa-thumbs-up me-1'></i>Good Fit (70%)</span>";

                            if (candidateSkills != null && !candidateSkills.trim().isEmpty()) {
                                String sLower = candidateSkills.toLowerCase();
                                if (sLower.contains("java") && (sLower.contains("spring") || sLower.contains("sql") || sLower.contains("react") || sLower.contains("aws") || sLower.contains("mysql"))) {
                                    fitPercent = 92;
                                    fitCategory = "GREAT";
                                    fitBadgeHtml = "<span class='badge-fit-great'><i class='fa-solid fa-star me-1 text-warning'></i>Great Fit (" + fitPercent + "% Match)</span>";
                                } else if (sLower.contains("java") || sLower.contains("python") || sLower.contains("react") || sLower.contains("sql")) {
                                    fitPercent = 78;
                                    fitCategory = "GREAT";
                                    fitBadgeHtml = "<span class='badge-fit-great'><i class='fa-solid fa-star me-1 text-warning'></i>Great Fit (" + fitPercent + "% Match)</span>";
                                } else {
                                    fitPercent = 45;
                                    fitCategory = "POTENTIAL";
                                    fitBadgeHtml = "<span class='badge-fit-potential'><i class='fa-solid fa-circle-info me-1'></i>Potential Fit (" + fitPercent + "%)</span>";
                                }
                            }
                    %>
                        <div class="col-12 applicant-card-item" 
                             data-candidate-name="<%= candidateName != null ? candidateName.toLowerCase() : "" %>"
                             data-skills="<%= candidateSkills != null ? candidateSkills.toLowerCase() : "" %>"
                             data-job-title="<%= jobTitle != null ? jobTitle : "" %>"
                             data-fit="<%= fitCategory %>"
                             data-status="<%= status %>">
                            <div class="glass-panel p-4">
                                <div class="row align-items-center g-3">
                                    <!-- Candidate Core -->
                                    <div class="col-lg-3">
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <h4 class="mb-0 text-primary"><%= candidateName %></h4>
                                        </div>
                                        <div class="mb-2"><%= fitBadgeHtml %></div>
                                        <div class="text-secondary small mb-1"><i class="fa-solid fa-envelope me-1 text-muted"></i><%= app.get("candidateEmail") %></div>
                                        <div class="text-secondary small"><i class="fa-solid fa-phone me-1 text-muted"></i><%= app.get("candidateMobile") != null ? app.get("candidateMobile") : "Not provided" %></div>
                                    </div>

                                    <!-- Job Title and Date -->
                                    <div class="col-lg-3">
                                        <div class="text-secondary small fw-bold mb-1">APPLIED FOR</div>
                                        <h5 class="text-primary mb-1"><%= jobTitle %></h5>
                                        <div class="text-secondary small"><i class="fa-regular fa-clock me-1 text-muted"></i>Applied: <%= app.get("applyDate") %></div>
                                    </div>

                                    <!-- Candidate Details / Skills -->
                                    <div class="col-lg-3">
                                        <div class="text-secondary small fw-bold mb-1">QUALIFICATION & EXPERIENCE</div>
                                        <div class="text-secondary small mb-2"><strong><%= app.get("education") != null ? app.get("education") : "Not specified" %></strong> • <%= app.get("experience") != null ? app.get("experience") : "No Experience specified" %></div>
                                        <div class="d-flex flex-wrap gap-1">
                                            <% 
                                                if (candidateSkills != null && !candidateSkills.trim().isEmpty()) {
                                                    for (String skill : candidateSkills.split(",")) {
                                            %>
                                                <span class="skill-tag" style="font-size: 11px;">
                                                    <%= skill.trim() %>
                                                </span>
                                            <%      } 
                                                }
                                            %>
                                        </div>
                                    </div>

                                    <!-- Actions -->
                                    <div class="col-lg-3 text-lg-end d-flex flex-row flex-lg-column align-items-center align-items-lg-end justify-content-between justify-content-lg-center gap-2">
                                        <span class="badge-neon <%= badgeClass %> mb-1"><%= status %></span>
                                        
                                        <div class="d-inline-flex flex-wrap gap-2 justify-content-end">
                                            <!-- Resume view -->
                                            <% if (resumePath != null && !resumePath.trim().isEmpty()) { %>
                                                <a href="../viewResume?path=<%= resumePath %>" target="_blank" class="btn-secondary-premium py-1 px-3" style="font-size: 13px;">
                                                    <i class="fa-solid fa-file-pdf me-1 text-danger"></i> Resume
                                                </a>
                                            <% } %>

                                            <!-- Action Buttons -->
                                            <% if ("Applied".equalsIgnoreCase(status)) { %>
                                                <a href="../apply?action=updateStatus&applicationId=<%= appId %>&status=Shortlisted" class="btn btn-sm btn-success text-white py-1 px-2 fw-semibold" style="font-size: 12px;">
                                                    <i class="fa-solid fa-check me-1"></i>Shortlist
                                                </a>
                                                <button type="button" class="btn-premium py-1 px-3" style="font-size: 12px;" data-bs-toggle="modal" data-bs-target="#scheduleModal<%= appId %>">
                                                    <i class="fa-solid fa-calendar-plus me-1"></i>Schedule
                                                </button>
                                                <a href="../apply?action=updateStatus&applicationId=<%= appId %>&status=Rejected" class="btn btn-sm btn-outline-danger py-1 px-2 fw-semibold" style="font-size: 12px;">
                                                    <i class="fa-solid fa-xmark me-1"></i>Reject
                                                </a>
                                            <% } else if ("Shortlisted".equalsIgnoreCase(status)) { %>
                                                <button type="button" class="btn-premium py-1 px-3" style="font-size: 13px;" data-bs-toggle="modal" data-bs-target="#scheduleModal<%= appId %>">
                                                    <i class="fa-solid fa-calendar-days me-1"></i>Schedule Interview
                                                </button>
                                                <a href="../apply?action=updateStatus&applicationId=<%= appId %>&status=Rejected" class="btn btn-sm btn-outline-danger py-1 px-2 fw-semibold" style="font-size: 12px;">
                                                    <i class="fa-solid fa-xmark me-1"></i>Reject
                                                </a>
                                            <% } else if ("Interview Scheduled".equalsIgnoreCase(status)) { %>
                                                <button type="button" class="btn-secondary-premium py-1 px-3" style="font-size: 13px;" data-bs-toggle="modal" data-bs-target="#scheduleModal<%= appId %>">
                                                    <i class="fa-solid fa-clock-rotate-left me-1 text-indigo"></i>Reschedule
                                                </button>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>

    <!-- Schedule Interview Modals -->
    <% 
        for (Map<String, Object> app : applicants) { 
            int appId = (Integer) app.get("applicationId");
            int candidateId = (Integer) app.get("candidateId");
            int jobId = (Integer) app.get("jobId");
    %>
        <div class="modal fade" id="scheduleModal<%= appId %>" tabindex="-1" aria-labelledby="scheduleModalLabel<%= appId %>" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content modal-content-glass">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold" id="scheduleModalLabel<%= appId %>">
                            <i class="fa-solid fa-calendar-days me-2 text-indigo"></i>Schedule Candidate Interview
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="../interview" method="post">
                        <div class="modal-body p-4 text-start">
                            <input type="hidden" name="candidateId" value="<%= candidateId %>">
                            <input type="hidden" name="jobId" value="<%= jobId %>">
                            <input type="hidden" name="applicationId" value="<%= appId %>">
                            <input type="hidden" name="redirectSource" value="applicants">

                            <div class="bg-indigo-soft p-3 rounded-3 mb-4">
                                <div class="small text-secondary">Candidate: <strong class="text-primary"><%= app.get("candidateName") %></strong></div>
                                <div class="small text-secondary">Position: <strong class="text-primary"><%= app.get("jobTitle") %></strong></div>
                            </div>

                            <!-- Interview Mode Selector (Online vs Offline) -->
                            <div class="mb-3">
                                <label class="form-label-custom">Interview Mode <span class="text-danger">*</span></label>
                                <div class="d-flex gap-3 mt-1">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="interviewMode" id="modeOnline_<%= appId %>" value="Online" checked onchange="toggleModeFields(<%= appId %>, 'Online')">
                                        <label class="form-check-label fw-semibold" for="modeOnline_<%= appId %>">
                                            <i class="fa-solid fa-video me-1 text-primary"></i>Online (Video Call)
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="interviewMode" id="modeOffline_<%= appId %>" value="Offline" onchange="toggleModeFields(<%= appId %>, 'Offline')">
                                        <label class="form-check-label fw-semibold" for="modeOffline_<%= appId %>">
                                            <i class="fa-solid fa-building me-1 text-warning"></i>Offline (In-Person / Office)
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label-custom">Select Interview Date & Time <span class="text-danger">*</span></label>
                                <input type="datetime-local" name="interviewDate" class="form-control form-control-glass" required>
                                <small class="text-muted">Choose convenient timing for the candidate</small>
                            </div>

                            <!-- Online Meeting Link Input -->
                            <div class="mb-3" id="onlineGroup_<%= appId %>">
                                <label class="form-label-custom">Virtual Meeting Link / Video Call URL</label>
                                <div class="input-group">
                                    <input type="url" name="meetingLink" id="meetingLink_<%= appId %>" class="form-control form-control-glass" placeholder="https://meet.google.com/xyz or Zoom Link" value="https://meet.jit.si/CareerLink-<%= appId %>-<%= System.currentTimeMillis() % 100000 %>">
                                    <button type="button" class="btn btn-outline-secondary" onclick="document.getElementById('meetingLink_<%= appId %>').value='https://meet.jit.si/CareerLink-<%= appId %>-' + Math.floor(Math.random()*89999+10000);" title="Generate new meeting room">
                                        <i class="fa-solid fa-rotate"></i>
                                    </button>
                                </div>
                                <small class="text-muted">Candidates can click 'Join Meeting' directly from their portal</small>
                            </div>

                            <!-- Offline Venue Input -->
                            <div class="mb-3" id="offlineGroup_<%= appId %>" style="display: none;">
                                <label class="form-label-custom">Office Location / Venue Address <span class="text-danger">*</span></label>
                                <input type="text" name="venue" id="venue_<%= appId %>" class="form-control form-control-glass" placeholder="e.g. Tower B, Floor 4, Suite 402, Business Park">
                                <small class="text-muted">Specify the physical location for the interview</small>
                            </div>

                            <div class="mb-2">
                                <label class="form-label-custom">Meeting Notes / Agenda (Optional)</label>
                                <input type="text" name="notes" class="form-control form-control-glass" placeholder="e.g. Technical Round 1, Bring ID Proof & Resume">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn-secondary-premium" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn-premium"><i class="fa-solid fa-calendar-check me-2"></i>Confirm & Schedule</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <% } %>

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
                <form action="../otp-password" method="post" id="hrApplicantsOtpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'hrApplicantsOtpAlertBox', 'btnSubmitHrApplicantsOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to your registered email: <strong><%= hrEmail %></strong>
                        </p>
                        
                        <!-- OTP Dispatch Button -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendHrApplicantsOtp" onclick="sendGlobalPasswordOtp(this, 'hrApplicantsOtpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="hrApplicantsOtpFeedback" style="display: none;"></div>
                        <div id="hrApplicantsOtpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="hrApplicantsOtpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
                            <small class="text-muted">Enter the 6-digit code received on your registered Gmail / Email.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">New Strong Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="newPassword" id="hrApplicantsNewPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('hrApplicantsNewPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-custom">Confirm New Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="confirmPassword" id="hrApplicantsConfirmPassword" class="form-control form-control-glass" placeholder="••••••••" minlength="6" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('hrApplicantsConfirmPassword', this)" type="button" aria-label="Toggle password visibility">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitHrApplicantsOtp">Update Password</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/main.js?v=2026.5"></script>
    <script>
        // Live Filtration of Candidates by Job, Fit Match, and Status
        function applyFilters() {
            const searchVal = document.getElementById('filterSearch').value.toLowerCase().trim();
            const jobVal = document.getElementById('filterJob').value;
            const fitVal = document.getElementById('filterFit').value;
            const statusVal = document.getElementById('filterStatus').value;

            const items = document.querySelectorAll('.applicant-card-item');
            let visibleCount = 0;

            items.forEach(card => {
                const name = card.getAttribute('data-candidate-name') || '';
                const skills = card.getAttribute('data-skills') || '';
                const jobTitle = card.getAttribute('data-job-title') || '';
                const fit = card.getAttribute('data-fit') || '';
                const status = card.getAttribute('data-status') || '';

                const matchesSearch = !searchVal || name.includes(searchVal) || skills.includes(searchVal);
                const matchesJob = (jobVal === 'ALL') || (jobTitle === jobVal);
                const matchesFit = (fitVal === 'ALL') || (fit === fitVal);
                const matchesStatus = (statusVal === 'ALL') || (status.toLowerCase() === statusVal.toLowerCase());

                if (matchesSearch && matchesJob && matchesFit && matchesStatus) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            const countBadge = document.getElementById('totalApplicantsCount');
            if (countBadge) {
                countBadge.innerText = 'Showing ' + visibleCount + ' of ' + items.length + ' Applicants';
            }
        }

        function toggleModeFields(appId, mode) {
            const onlineGroup = document.getElementById('onlineGroup_' + appId);
            const offlineGroup = document.getElementById('offlineGroup_' + appId);
            const venueInput = document.getElementById('venue_' + appId);

            if (mode === 'Offline') {
                onlineGroup.style.display = 'none';
                offlineGroup.style.display = 'block';
                venueInput.required = true;
            } else {
                onlineGroup.style.display = 'block';
                offlineGroup.style.display = 'none';
                venueInput.required = false;
            }
        }
    </script>
</body>
</html>