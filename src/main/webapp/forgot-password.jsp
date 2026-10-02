<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String roleParam = request.getParameter("role");
    boolean isHr = "hr".equalsIgnoreCase(roleParam) || "recruiter".equalsIgnoreCase(roleParam);
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - CareerLink</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <link href="css/style.css?v=2026" rel="stylesheet">
</head>

<body class="d-flex flex-column min-vh-100">

    <!-- Header Navigation -->
    <nav class="navbar navbar-expand-lg navbar-custom navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fa-solid fa-link me-2"></i>CareerLink
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Back to Sign In</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content Form Section -->
    <div class="container my-auto">
        <div class="glass-panel form-glass animate-fade-in my-5" style="max-width: 520px;">
            <div class="text-center mb-4">
                <div class="feature-icon-wrapper mx-auto mb-3" style="width: 54px; height: 54px; font-size: 22px;">
                    <i class="fa-solid fa-key text-indigo"></i>
                </div>
                <h3 class="mb-1">Reset Account Password</h3>
                <p class="text-secondary small">Enter your verified email to receive a strongly encrypted password reset authorization</p>
            </div>

            <!-- Display Messages -->
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger border-0 text-white bg-danger bg-opacity-25 mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <% if (request.getAttribute("resetUrl") != null) { %>
                <div class="alert alert-success border-0 mb-4 p-3" role="alert">
                    <div class="d-flex align-items-center mb-2">
                        <i class="fa-solid fa-circle-check fs-5 me-2"></i>
                        <strong>Password Reset Authorization Generated!</strong>
                    </div>
                    <p class="small text-secondary mb-3">
                        A secure 256-bit cryptographic token was generated for <strong><%= request.getAttribute("email") %></strong>.
                    </p>
                    <a href="<%= request.getAttribute("resetUrl") %>" class="btn-premium d-block text-center py-2 text-decoration-none">
                        <i class="fa-solid fa-arrow-right me-2"></i>Proceed to Reset Password
                    </a>
                </div>
            <% } %>

            <!-- Role Selector Tabs -->
            <div class="tab-header">
                <button type="button" class="tab-btn <%= !isHr ? "active" : "" %>" id="tab-candidate"
                    onclick="switchRole('candidate')">
                    <i class="fa-solid fa-user me-2"></i>Job Seeker
                </button>
                <button type="button" class="tab-btn <%= isHr ? "active" : "" %>" id="tab-hr" onclick="switchRole('hr')">
                    <i class="fa-solid fa-building me-2"></i>Recruiter
                </button>
            </div>

            <form action="forgot-password" method="post">
                <input type="hidden" name="roleType" id="roleType" value="<%= isHr ? "hr" : "candidate" %>">

                <div class="mb-4">
                    <label class="form-label-custom" id="email-label"><%= isHr ? "Registered Recruiter Email" : "Registered Seeker Email" %></label>
                    <input type="email" name="email" class="form-control form-control-glass"
                        placeholder="name@example.com" required>
                    <small class="text-muted">We will verify your registered credentials and generate a safe token.</small>
                </div>

                <button type="submit" class="btn-premium w-100 py-3 mb-3">
                    <i class="fa-solid fa-paper-plane me-2"></i>Generate Reset Token
                </button>

                <div class="text-center">
                    <p class="text-secondary small mb-0">Remembered your credentials?
                        <a href="<%= isHr ? "login.jsp?role=hr" : "login.jsp" %>" class="text-indigo text-decoration-none fw-bold"
                            id="back-login-link">Back to Sign In</a>
                    </p>
                </div>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer class="py-4 text-center text-muted mt-auto" style="border-top: 1px solid var(--border-glass);">
        <div class="container">
            <p class="mb-0">&copy; 2026 CareerLink. All rights reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Role Switching Script -->
    <script>
        function switchRole(role) {
            document.getElementById('roleType').value = role;

            document.getElementById('tab-candidate').classList.remove('active');
            document.getElementById('tab-hr').classList.remove('active');
            document.getElementById('tab-' + role).classList.add('active');

            const emailLabel = document.getElementById('email-label');
            const backLink = document.getElementById('back-login-link');

            if (role === 'hr') {
                emailLabel.innerText = "Registered Recruiter Email";
                backLink.href = "login.jsp?role=hr";
            } else {
                emailLabel.innerText = "Registered Seeker Email";
                backLink.href = "login.jsp";
            }
        }

        window.addEventListener('load', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const role = urlParams.get('role');
            if (role === 'hr' || role === 'recruiter') {
                switchRole('hr');
            }
        });
    </script>
</body>

</html>
