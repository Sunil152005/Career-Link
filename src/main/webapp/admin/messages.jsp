<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.careerlink.dao.ContactDAO" %>
<%
    String admin = (String) session.getAttribute("admin");
    String role = (String) session.getAttribute("role");
    if (!"true".equals(admin) && !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?role=admin");
        return;
    }

    ContactDAO contactDao = new ContactDAO();
    List<Map<String, Object>> messages = contactDao.getAllMessages();

    int totalMessages = messages.size();
    int pendingCount = 0;
    int resolvedCount = 0;
    for (Map<String, Object> m : messages) {
        String status = (String) m.get("status");
        if ("Resolved".equalsIgnoreCase(status)) {
            resolvedCount++;
        } else {
            pendingCount++;
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy - hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support Inquiries & Helpdesk - CareerLink Admin</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <link href="../css/style.css?v=2026.4" rel="stylesheet">
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
            <a href="jobs.jsp" class="sidebar-link">
                <i class="fa-solid fa-briefcase"></i>Monitor Jobs
            </a>
            <a href="messages.jsp" class="sidebar-link active">
                <i class="fa-solid fa-headset"></i>Support Inquiries
                <% if (pendingCount > 0) { %>
                    <span class="badge bg-danger rounded-pill ms-auto" id="sidebarPendingBadge"><%= pendingCount %></span>
                <% } %>
            </a>
        </div>

        <!-- Main Workspace -->
        <main class="dashboard-main-content">
            <div class="container-fluid animate-fade-in">
                <!-- Header -->
                <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between mb-4 gap-3">
                    <div>
                        <h2 class="mb-1">Support Inquiries & User Helpdesk</h2>
                        <p class="text-secondary small mb-0">Review messages submitted by job seekers, hiring managers, and visitors. Resolve reported issues directly.</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <button class="btn btn-sm btn-outline-secondary" onclick="window.location.reload();">
                            <i class="fa-solid fa-rotate me-1"></i>Refresh
                        </button>
                    </div>
                </div>

                <% if ("resolved".equals(request.getParameter("success"))) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i>Inquiry has been successfully marked as <strong>Resolved</strong>.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <% if ("deleted".equals(request.getParameter("success"))) { %>
                    <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fa-solid fa-trash-can me-2"></i>Inquiry message has been removed from system records.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i>Operation failed. Please try again.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <!-- Stats summary cards -->
                <div class="row g-3 mb-4">
                    <div class="col-sm-4">
                        <div class="glass-panel p-3 text-center">
                            <div class="text-muted small fw-bold text-uppercase">Total Inquiries</div>
                            <div class="fs-3 fw-bold text-dark" id="statTotal"><%= totalMessages %></div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="glass-panel p-3 text-center" style="border-left: 4px solid #ef4444;">
                            <div class="text-danger small fw-bold text-uppercase">Pending Issues</div>
                            <div class="fs-3 fw-bold text-danger" id="statPending"><%= pendingCount %></div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="glass-panel p-3 text-center" style="border-left: 4px solid #10b981;">
                            <div class="text-success small fw-bold text-uppercase">Resolved Queries</div>
                            <div class="fs-3 fw-bold text-success" id="statResolved"><%= resolvedCount %></div>
                        </div>
                    </div>
                </div>

                <!-- Filter and Search Toolbar -->
                <div class="glass-panel p-3 mb-4">
                    <div class="row g-3 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                                <input type="text" id="messageSearchInput" class="form-control border-start-0" placeholder="Search by name, email, subject, or issue..." onkeyup="filterMessages()">
                            </div>
                        </div>
                        <div class="col-md-7 text-md-end">
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-sm btn-outline-primary active" id="btnFilterAll" onclick="setFilter('all', this)">All (<span id="countFilterAll"><%= totalMessages %></span>)</button>
                                <button type="button" class="btn btn-sm btn-outline-danger" id="btnFilterPending" onclick="setFilter('pending', this)">Pending (<span id="countFilterPending"><%= pendingCount %></span>)</button>
                                <button type="button" class="btn btn-sm btn-outline-success" id="btnFilterResolved" onclick="setFilter('resolved', this)">Resolved (<span id="countFilterResolved"><%= resolvedCount %></span>)</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Messages Grid / List -->
                <% if (messages.isEmpty()) { %>
                    <div class="glass-panel text-center py-5">
                        <i class="fa-solid fa-envelope-open text-muted mb-3" style="font-size: 3rem;"></i>
                        <h5>No inquiries recorded yet</h5>
                        <p class="text-secondary small">Messages submitted through the Home Page "Contact Admin" section will appear here.</p>
                    </div>
                <% } else { %>
                    <div class="row g-4" id="messagesContainer">
                        <% for (Map<String, Object> msg : messages) { 
                            int msgId = (Integer) msg.get("messageId");
                            String name = (String) msg.get("name");
                            String email = (String) msg.get("email");
                            String subject = (String) msg.get("subject");
                            String body = (String) msg.get("message");
                            String status = (String) msg.get("status");
                            String reply = (String) msg.get("reply");
                            Object createdObj = msg.get("createdAt");
                            String dateStr = createdObj != null ? sdf.format(createdObj) : "Recently";
                            boolean isResolved = "Resolved".equalsIgnoreCase(status);
                        %>
                            <div class="col-12 message-card-item" id="msgCard_<%= msgId %>" data-status="<%= status != null ? status.toLowerCase() : "pending" %>" data-search="<%= (name + " " + email + " " + subject + " " + body).toLowerCase() %>">
                                <div class="glass-panel p-4 h-100 shadow-sm transition-hover">
                                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start gap-2 mb-3">
                                        <div>
                                            <div class="d-flex align-items-center gap-2 mb-1" id="badgeContainer_<%= msgId %>">
                                                <h5 class="fw-bold mb-0 text-dark"><%= subject %></h5>
                                                <% if (isResolved) { %>
                                                    <span class="badge-neon selected"><i class="fa-solid fa-circle-check me-1"></i>Resolved</span>
                                                <% } else { %>
                                                    <span class="badge-neon rejected"><i class="fa-solid fa-clock me-1"></i>Pending Review</span>
                                                <% } %>
                                            </div>
                                            <div class="small text-secondary">
                                                <i class="fa-solid fa-user me-1 text-muted"></i><strong><%= name %></strong> &bull; 
                                                <i class="fa-solid fa-envelope me-1 text-muted"></i><a href="mailto:<%= email %>" class="text-secondary text-decoration-none"><%= email %></a> &bull; 
                                                <i class="fa-solid fa-calendar-day me-1 text-muted"></i><%= dateStr %>
                                            </div>
                                        </div>

                                        <div class="d-flex gap-2 align-items-center">
                                            <div id="resolveActionBox_<%= msgId %>">
                                                <% if (!isResolved) { %>
                                                    <button class="btn btn-sm btn-success px-3 shadow-sm" type="button" onclick="openResolveModal('<%= msgId %>', '<%= subject.replace("'", "\\'").replace("\"", "&quot;") %>', '<%= name.replace("'", "\\'").replace("\"", "&quot;") %>', '<%= email.replace("'", "\\'").replace("\"", "&quot;") %>')">
                                                        <i class="fa-solid fa-check me-1"></i>Resolve Issue
                                                    </button>
                                                <% } %>
                                            </div>
                                            <form action="../contact" method="POST" onsubmit="return confirm('Are you sure you want to permanently delete this inquiry message?');" class="d-inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="messageId" value="<%= msgId %>">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete inquiry">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Message Body Box -->
                                    <div class="p-3 rounded-3 mb-3" style="background: rgba(241, 245, 249, 0.7); border: 1px solid var(--border-glass);">
                                        <div class="text-dark small" style="white-space: pre-wrap; font-size: 0.95rem;"><%= body %></div>
                                    </div>

                                    <!-- Admin Resolution Remarks Box -->
                                    <div id="replyBox_<%= msgId %>" style="<%= (isResolved && reply != null && !reply.isEmpty()) ? "" : "display: none;" %>">
                                        <div class="p-3 rounded-3" style="background: rgba(16, 185, 129, 0.08); border-left: 3px solid #10b981;">
                                            <div class="small fw-bold text-success mb-1">
                                                <i class="fa-solid fa-shield-halved me-1"></i>Admin Resolution Remarks:
                                            </div>
                                            <div class="small text-secondary" id="replyText_<%= msgId %>"><%= (reply != null) ? reply : "" %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <!-- Unified Resolve Issue Modal (Crisp, High-Z-Index, No Viewport Clipping) -->
    <div class="modal fade" id="resolveInquiryModal" tabindex="-1" aria-labelledby="resolveInquiryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 540px;">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 14px; overflow: hidden; background: #ffffff;">
                <div class="modal-header border-bottom px-4 py-3" style="background: linear-gradient(135deg, #059669 0%, #10b981 100%); color: #ffffff;">
                    <h5 class="modal-title fw-bold text-white mb-0" id="resolveInquiryModalLabel">
                        <i class="fa-solid fa-circle-check me-2"></i>Resolve Inquiry #<span id="resolveModalMsgIdText"></span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="../contact" method="POST" id="resolveInquiryForm" onsubmit="submitResolveInquiry(event, this)">
                    <input type="hidden" name="action" value="resolve">
                    <input type="hidden" name="messageId" id="resolveModalMsgId">
                    <div class="modal-body p-4 text-start">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary mb-1">Inquiry Subject</label>
                            <input type="text" id="resolveModalSubject" class="form-control bg-light" readonly style="border-radius: 8px; font-weight: 600; color: #1e293b;">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary mb-1">Submitted By</label>
                            <input type="text" id="resolveModalUser" class="form-control bg-light" readonly style="border-radius: 8px; color: #475569;">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-dark mb-1">Admin Resolution Remarks / Follow-up Note <span class="text-danger">*</span></label>
                            <textarea name="reply" id="resolveModalReply" class="form-control" rows="3" placeholder="Explain the resolution action taken (e.g. 'Issue investigated and resolved by Admin.')" style="border-radius: 8px;" required>Issue investigated and resolved by Admin.</textarea>
                            <small class="text-muted">This note will be saved in the system record as the official resolution remark.</small>
                        </div>
                    </div>
                    <div class="modal-footer border-top p-3 d-flex justify-content-end gap-2" style="background: #f8fafc;">
                        <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success px-4 fw-bold shadow-sm" id="btnSubmitResolve">
                            <i class="fa-solid fa-circle-check me-1"></i>Mark as Resolved
                        </button>
                    </div>
                </form>
            </div>
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
                <form action="../otp-password" method="post" id="otpPasswordForm" onsubmit="submitGlobalOtpPassword(event, this, 'otpAlertBox', 'btnSubmitOtp')">
                    <input type="hidden" name="action" value="verifyOtpChange">
                    <div class="modal-body p-4 text-start">
                        <p class="small text-secondary mb-3">
                            A verification OTP will be sent securely to root administrator email: <strong>admin@careerlink.com</strong>
                        </p>
                        
                        <!-- OTP Dispatch Section -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-sm btn-outline-primary fw-semibold" id="btnSendOtp" onclick="sendGlobalPasswordOtp(this, 'otpFeedback', '..')">
                                <i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code
                            </button>
                        </div>

                        <!-- Feedback Message Box (No OTP displayed on screen) -->
                        <div id="otpFeedback" style="display: none;"></div>
                        <div id="otpAlertBox" style="display: none;"></div>

                        <div class="mb-3">
                            <label class="form-label-custom">Enter 6-Digit OTP <span class="text-danger">*</span></label>
                            <input type="text" name="otp" id="otpInput" class="form-control form-control-glass text-center letter-spacing-lg fw-bold" placeholder="• • • • • •" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required>
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
                        <button type="submit" class="btn btn-primary px-4 fw-bold" id="btnSubmitOtp">Update Password</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/main.js?v=2026.5"></script>
    <script>
        let currentStatusFilter = 'all';

        function setFilter(status, btn) {
            currentStatusFilter = status;
            document.querySelectorAll('.btn-group button').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            filterMessages();
        }

        function filterMessages() {
            const query = (document.getElementById('messageSearchInput').value || '').toLowerCase().trim();
            const items = document.querySelectorAll('.message-card-item');

            items.forEach(item => {
                const itemStatus = item.getAttribute('data-status');
                const itemSearch = item.getAttribute('data-search');

                const matchesStatus = currentStatusFilter === 'all' || itemStatus === currentStatusFilter;
                const matchesSearch = query === '' || itemSearch.includes(query);

                if (matchesStatus && matchesSearch) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }

        // Open Resolve Issue Modal dynamically
        function openResolveModal(msgId, subject, name, email) {
            document.getElementById('resolveModalMsgId').value = msgId;
            document.getElementById('resolveModalMsgIdText').innerText = msgId;
            document.getElementById('resolveModalSubject').value = subject;
            document.getElementById('resolveModalUser').value = name + ' (' + email + ')';
            document.getElementById('resolveModalReply').value = 'Issue investigated and resolved by Admin.';
            
            const submitBtn = document.getElementById('btnSubmitResolve');
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="fa-solid fa-circle-check me-1"></i>Mark as Resolved';
            }

            const modalEl = document.getElementById('resolveInquiryModal');
            const bsModal = bootstrap.Modal.getOrCreateInstance(modalEl);
            bsModal.show();
        }

        // Handle Resolve Inquiry Form Submit via AJAX with instantaneous UI update
        function submitResolveInquiry(event, form) {
            if (event) event.preventDefault();
            const btn = document.getElementById('btnSubmitResolve');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i>Resolving...';
            }

            const msgId = document.getElementById('resolveModalMsgId').value;
            const reply = document.getElementById('resolveModalReply').value;
            const formData = new FormData(form);
            const params = new URLSearchParams(formData);

            const actionUrl = form.getAttribute('action') || '../contact';
            fetch(actionUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: params.toString()
            })
            .then(r => r.json())
            .then(data => {
                if (data.status === 'success') {
                    // Update DOM element directly for instant feedback
                    const card = document.getElementById('msgCard_' + msgId);
                    if (card) {
                        card.setAttribute('data-status', 'resolved');
                        const badgeContainer = document.getElementById('badgeContainer_' + msgId);
                        if (badgeContainer) {
                            const badge = badgeContainer.querySelector('.badge-neon');
                            if (badge) {
                                badge.className = 'badge-neon selected';
                                badge.innerHTML = '<i class="fa-solid fa-circle-check me-1"></i>Resolved';
                            }
                        }
                        const actionBox = document.getElementById('resolveActionBox_' + msgId);
                        if (actionBox) actionBox.innerHTML = '';

                        const replyBox = document.getElementById('replyBox_' + msgId);
                        const replyText = document.getElementById('replyText_' + msgId);
                        if (replyBox && replyText) {
                            replyText.innerText = reply;
                            replyBox.style.display = 'block';
                        }
                    }

                    // Close modal
                    const modalEl = document.getElementById('resolveInquiryModal');
                    const bsModal = bootstrap.Modal.getInstance(modalEl);
                    if (bsModal) bsModal.hide();

                    // Reload page to refresh counters cleanly
                    window.location.href = 'messages.jsp?success=resolved';
                } else {
                    alert('Resolution failed: ' + (data.message || 'Please try again.'));
                    if (btn) {
                        btn.disabled = false;
                        btn.innerHTML = '<i class="fa-solid fa-circle-check me-1"></i>Mark as Resolved';
                    }
                }
            })
            .catch(err => {
                console.error('Resolve Error:', err);
                // Fallback normal submission
                form.submit();
            });
        }
    </script>
</body>
</html>
