<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String token = (String) request.getAttribute("token");
    if (token == null || token.trim().isEmpty()) {
        token = request.getParameter("token");
    }
    String email = (String) request.getAttribute("email");
    if (email == null) {
        email = request.getParameter("email");
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set New Password - CareerLink</title>
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
                <div class="feature-icon-wrapper mx-auto mb-3" style="width: 54px; height: 54px; font-size: 22px; color: var(--success); background: rgba(5, 150, 105, 0.1);">
                    <i class="fa-solid fa-lock text-success"></i>
                </div>
                <h3 class="mb-1">Create New Password</h3>
                <p class="text-secondary small">Your new credentials will be secured with PBKDF2-HMAC-SHA256 encryption</p>
            </div>

            <!-- Display Messages -->
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger border-0 text-white bg-danger bg-opacity-25 mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <% if (email != null && !email.trim().isEmpty()) { %>
                <div class="p-3 bg-indigo-soft rounded-3 mb-4 text-center">
                    <span class="text-secondary small">Resetting password for: <strong class="text-primary"><%= email %></strong></span>
                </div>
            <% } %>

            <form action="reset-password" method="post" onsubmit="return validatePasswords();">
                <input type="hidden" name="action" value="completeReset">
                <input type="hidden" name="token" value="<%= token != null ? token : "" %>">

                <!-- New Password with Eye Toggle Button -->
                <div class="mb-3">
                    <label class="form-label-custom">New Strong Password</label>
                    <div class="input-group-password">
                        <input type="password" name="newPassword" id="newPassword" class="form-control form-control-glass"
                            placeholder="Enter new password (min. 6 characters)" minlength="6" required oninput="checkStrength();">
                        <button type="button" class="password-toggle-btn" data-target="newPassword" onclick="togglePassword('newPassword', this)" aria-label="Toggle password visibility">
                            <i class="fa-solid fa-eye"></i>
                        </button>
                    </div>
                    <div class="progress mt-2" style="height: 4px;">
                        <div id="strengthBar" class="progress-bar bg-danger" role="progressbar" style="width: 0%"></div>
                    </div>
                    <small id="strengthText" class="text-muted" style="font-size: 11px;">Password strength: Empty</small>
                </div>

                <!-- Confirm Password with Eye Toggle Button -->
                <div class="mb-4">
                    <label class="form-label-custom">Confirm New Password</label>
                    <div class="input-group-password">
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control form-control-glass"
                            placeholder="Re-type new password" minlength="6" required>
                        <button type="button" class="password-toggle-btn" data-target="confirmPassword" onclick="togglePassword('confirmPassword', this)" aria-label="Toggle password visibility">
                            <i class="fa-solid fa-eye"></i>
                        </button>
                    </div>
                    <small id="matchFeedback" class="text-danger" style="display: none; font-size: 12px;">Passwords do not match!</small>
                </div>

                <button type="submit" class="btn-premium w-100 py-3 mb-3">
                    <i class="fa-solid fa-shield-check me-2"></i>Save Encrypted Password
                </button>

                <div class="text-center">
                    <a href="login.jsp" class="text-indigo text-decoration-none small fw-semibold">
                        Cancel & Return to Sign In
                    </a>
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
    <script src="js/main.js?v=2026.5"></script>

    <!-- Validation & Strength Script -->
    <script>
        function checkStrength() {
            const pwd = document.getElementById('newPassword').value;
            const bar = document.getElementById('strengthBar');
            const txt = document.getElementById('strengthText');

            let score = 0;
            if (pwd.length >= 6) score += 25;
            if (pwd.length >= 10) score += 25;
            if (/[A-Z]/.test(pwd) && /[0-9]/.test(pwd)) score += 25;
            if (/[^A-Za-z0-9]/.test(pwd)) score += 25;

            bar.style.width = score + '%';
            if (score <= 25) {
                bar.className = 'progress-bar bg-danger';
                txt.innerText = 'Password strength: Weak (use letters, numbers, symbols)';
            } else if (score <= 50) {
                bar.className = 'progress-bar bg-warning';
                txt.innerText = 'Password strength: Medium';
            } else if (score <= 75) {
                bar.className = 'progress-bar bg-info';
                txt.innerText = 'Password strength: Strong';
            } else {
                bar.className = 'progress-bar bg-success';
                txt.innerText = 'Password strength: Very Strong (Optimal Security)';
            }
        }

        function validatePasswords() {
            const p1 = document.getElementById('newPassword').value;
            const p2 = document.getElementById('confirmPassword').value;
            const feedback = document.getElementById('matchFeedback');

            if (p1 !== p2) {
                feedback.style.display = 'block';
                return false;
            }
            feedback.style.display = 'none';
            return true;
        }
    </script>
</body>

</html>
