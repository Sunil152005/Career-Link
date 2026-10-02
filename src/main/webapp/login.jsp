<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String roleParam = request.getParameter("role");
    boolean isHr = "hr".equalsIgnoreCase(roleParam) || "recruiter".equalsIgnoreCase(roleParam);
    boolean isAdmin = "admin".equalsIgnoreCase(roleParam);
    String activeRole = isAdmin ? "admin" : (isHr ? "hr" : "candidate");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - CareerLink</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <link href="css/style.css?v=2026.2" rel="stylesheet">
</head>

<body class="d-flex flex-column min-vh-100 bg-light">

    <!-- Header Navigation -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fa-solid fa-link me-2 text-indigo"></i>CareerLink
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Back to Home</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content Form Section (Kaggle Style Welcome Card) -->
    <div class="container my-auto">
        <div class="auth-card-kaggle animate-fade-in my-4">
            
            <!-- Logo & Brand Header -->
            <div class="text-center mb-3">
                <div class="d-inline-flex align-items-center justify-content-center mb-2" style="font-size: 28px; font-weight: 800; color: #4f46e5; letter-spacing: -0.5px;">
                    <i class="fa-solid fa-link me-2 text-indigo"></i>CareerLink
                </div>
                <h3 class="fw-bold mb-3" style="color: #1e293b;">Welcome!</h3>
            </div>

            <!-- Top Sign In / Register Switcher Tabs -->
            <div class="auth-kaggle-tabs">
                <a href="login.jsp<%= isHr ? "?role=hr" : "" %>" class="auth-kaggle-tab active text-decoration-none">Sign In</a>
                <a href="register.jsp<%= isHr ? "?role=hr" : "" %>" class="auth-kaggle-tab text-decoration-none">Register</a>
            </div>

            <!-- Display Messages -->
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger border-0 mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success border-0 mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i>
                    <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>

            <!-- Role Selector Tabs -->
            <div class="tab-header mb-4">
                <button type="button" class="tab-btn <%= "candidate".equals(activeRole) ? "active" : "" %>" id="tab-candidate" onclick="switchRole('candidate')">
                    <i class="fa-solid fa-user me-2"></i>Job Seeker
                </button>
                <button type="button" class="tab-btn <%= "hr".equals(activeRole) ? "active" : "" %>" id="tab-hr" onclick="switchRole('hr')">
                    <i class="fa-solid fa-building me-2"></i>Recruiter
                </button>
                <button type="button" class="tab-btn <%= "admin".equals(activeRole) ? "active" : "" %>" id="tab-admin" onclick="switchRole('admin')">
                    <i class="fa-solid fa-user-shield me-2"></i>Admin
                </button>
            </div>

            <!-- Social Auth Pill Buttons (Seeker & Recruiter) -->
            <div id="social-auth-section" style="<%= isAdmin ? "display: none;" : "display: block;" %>">
                <!-- 1. Google Button -->
                <button type="button" class="btn-pill-auth" onclick="startGoogleAuth()">
                    <svg width="20" height="20" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v4.51h6.6c-.29 1.52-1.14 2.82-2.4 3.68v3.05h3.88c2.27-2.09 3.66-5.17 3.66-9.17z"/>
                        <path fill="#34A853" d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.88-3.05c-1.08.72-2.45 1.16-4.05 1.16-3.12 0-5.77-2.1-6.72-4.93H1.25v3.15C3.26 21.36 7.33 24 12 24z"/>
                        <path fill="#FBBC05" d="M5.28 14.27c-.25-.72-.38-1.49-.38-2.27s.13-1.55.38-2.27V6.58H1.25C.45 8.18 0 10.03 0 12s.45 3.82 1.25 5.42l4.03-3.15z"/>
                        <path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.33 0 3.26 2.64 1.25 6.58l4.03 3.15c.95-2.83 3.6-4.98 6.72-4.98z"/>
                    </svg>
                    <span>Sign in with Google</span>
                </button>

                <!-- 2. LinkedIn Button -->
                <button type="button" class="btn-pill-auth btn-pill-linkedin" onclick="startLinkedInAuth()">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/>
                    </svg>
                    <span>Sign in with LinkedIn</span>
                </button>

                <!-- 3. Toggle Email Sign In Form -->
                <button type="button" class="btn-pill-auth btn-pill-email" id="btnToggleEmailForm" onclick="toggleEmailSection()">
                    <i class="fa-regular fa-envelope me-1"></i>
                    <span>Sign in with Email</span>
                </button>
            </div>

            <!-- Standard Direct Form (Email / Password) -->
            <div id="email-form-section" style="<%= isAdmin ? "display: block;" : "display: none;" %>">
                <div class="social-divider text-uppercase small text-muted text-center my-3" id="email-form-divider">
                    <span>OR SIGN IN WITH CREDENTIALS</span>
                </div>

                <form action="login" method="post" id="mainLoginForm">
                    <input type="hidden" name="roleType" id="roleType" value="<%= activeRole %>">

                    <!-- Email Input -->
                    <div class="mb-3">
                        <label class="form-label-custom" id="email-label"><%= isAdmin ? "Admin Username" : (isHr ? "Recruiter Email" : "Email Address") %></label>
                        <input type="text" name="email" id="loginEmail" class="form-control form-control-glass" placeholder="<%= isAdmin ? "admin@careerlink.com" : "name@example.com" %>" required>
                    </div>

                    <!-- Password Input with Eye Toggle Button -->
                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label class="form-label-custom mb-0">Password</label>
                            <a href="forgot-password.jsp" class="text-indigo text-decoration-none small fw-semibold" id="forgot-link">Forgot Password?</a>
                        </div>
                        <div class="input-group-password">
                            <input type="password" name="password" id="loginPassword" class="form-control form-control-glass" placeholder="••••••••" required>
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('loginPassword', this)" aria-label="Toggle password visibility">
                                <i class="fa-solid fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-premium w-100 py-3 mb-3">
                        Sign In
                    </button>
                </form>
            </div>

            <!-- Redirect to Registration -->
            <div class="text-center mt-3" id="register-redirect" style="<%= isAdmin ? "display: none;" : "display: block;" %>">
                <p class="text-secondary small mb-0">Don't have an account?
                    <a href="<%= isHr ? "register.jsp?role=hr" : "register.jsp" %>" class="text-indigo text-decoration-none fw-bold" id="reg-link">Create one</a>
                </p>
            </div>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- REAL STEP-BY-STEP GOOGLE OAUTH MODAL (Matching User Screenshots 2, 3, 4) -->
    <!-- ========================================================================= -->
    <div class="modal fade google-oauth-modal" id="googleAuthModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 580px;">
            <div class="modal-content">
                
                <!-- Google Modal Header -->
                <div class="google-oauth-header">
                    <div class="d-flex align-items-center gap-2">
                        <svg width="20" height="20" viewBox="0 0 24 24">
                            <path fill="#4285F4" d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v4.51h6.6c-.29 1.52-1.14 2.82-2.4 3.68v3.05h3.88c2.27-2.09 3.66-5.17 3.66-9.17z"/>
                            <path fill="#34A853" d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.88-3.05c-1.08.72-2.45 1.16-4.05 1.16-3.12 0-5.77-2.1-6.72-4.93H1.25v3.15C3.26 21.36 7.33 24 12 24z"/>
                            <path fill="#FBBC05" d="M5.28 14.27c-.25-.72-.38-1.49-.38-2.27s.13-1.55.38-2.27V6.58H1.25C.45 8.18 0 10.03 0 12s.45 3.82 1.25 5.42l4.03-3.15z"/>
                            <path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.33 0 3.26 2.64 1.25 6.58l4.03 3.15c.95-2.83 3.6-4.98 6.72-4.98z"/>
                        </svg>
                        <span class="small fw-semibold text-light">Sign in with Google</span>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <form action="oauth-auth" method="post" id="googleOAuthForm">
                    <input type="hidden" name="provider" value="google">
                    <input type="hidden" name="roleType" id="googleRoleType" value="candidate">
                    <input type="hidden" name="email" id="googleSelectedEmail" value="suniljadhav152005@gmail.com">
                    <input type="hidden" name="name" id="googleSelectedName" value="Sunil Jadhav">

                    <!-- STEP 1: CHOOSE AN ACCOUNT (Screenshot 2) -->
                    <div id="googleStep1" class="google-oauth-body animate-fade-in">
                        <div class="mb-3">
                            <div class="d-inline-flex p-2 rounded-3 mb-2" style="background: #4f46e5; color: #ffffff; font-weight: 800; font-size: 20px;">
                                <i class="fa-solid fa-link"></i>
                            </div>
                            <h3 class="fw-bold text-white mb-1">Choose an account</h3>
                            <p class="text-secondary small mb-0">to continue to <strong class="text-white">CareerLink</strong></p>
                        </div>

                        <div class="google-account-list">
                            <!-- Account 1 -->
                            <div class="google-account-item" onclick="selectGoogleAccount('Sunil Jadhav', 'suniljadhav152005@gmail.com', '#d81b60', 'S')">
                                <div class="google-avatar" style="background: #d81b60;">S</div>
                                <div>
                                    <div class="fw-bold text-white">Sunil Jadhav</div>
                                    <div class="small text-secondary">suniljadhav152005@gmail.com</div>
                                </div>
                            </div>

                            <!-- Account 2 -->
                            <div class="google-account-item" onclick="selectGoogleAccount('Sunil Jadhav', 'sj429012@gmail.com', '#fbc02d', '😊')">
                                <div class="google-avatar" style="background: #fbc02d;">😊</div>
                                <div>
                                    <div class="fw-bold text-white">Sunil Jadhav</div>
                                    <div class="small text-secondary">sj429012@gmail.com</div>
                                </div>
                            </div>

                            <!-- Account 3 (Role Specific Demo User) -->
                            <div class="google-account-item" id="googleRoleAccountItem" onclick="selectGoogleAccount('Aditya Bhosale', 'seeker1@gmail.com', '#00897b', 'A')">
                                <div class="google-avatar" id="googleRoleAvatar" style="background: #00897b;">A</div>
                                <div>
                                    <div class="fw-bold text-white" id="googleRoleName">Aditya Bhosale</div>
                                    <div class="small text-secondary" id="googleRoleEmail">seeker1@gmail.com</div>
                                </div>
                            </div>

                            <!-- Use another account -->
                            <div class="google-account-item" onclick="showGoogleCustomInput()">
                                <div class="google-avatar" style="background: #374151;">
                                    <i class="fa-solid fa-user-plus text-secondary"></i>
                                </div>
                                <div class="fw-semibold text-white">Use another account</div>
                            </div>
                        </div>

                        <!-- Custom Email Input (Hidden by default) -->
                        <div id="googleCustomInputDiv" class="mt-3" style="display: none;">
                            <label class="form-label-custom text-white small">Enter your Google Email</label>
                            <div class="d-flex gap-2">
                                <input type="email" id="googleCustomEmail" class="form-control google-input-outline" placeholder="username@gmail.com">
                                <button type="button" class="btn btn-primary px-3 rounded-3" onclick="applyGoogleCustomEmail()">Next</button>
                            </div>
                        </div>

                        <div class="text-secondary small mt-4" style="font-size: 12px; line-height: 1.5;">
                            Before using this app, you can review CareerLink's <a href="#" class="text-decoration-none" style="color: #8ab4f8;">Privacy Policy</a> and <a href="#" class="text-decoration-none" style="color: #8ab4f8;">Terms of Service</a>.
                        </div>
                    </div>

                    <!-- STEP 2: ENTER PASSWORD (Screenshot 3) -->
                    <div id="googleStep2" class="google-oauth-body animate-fade-in" style="display: none;">
                        <div class="mb-4">
                            <div class="d-inline-flex p-2 rounded-3 mb-2" style="background: #4f46e5; color: #ffffff; font-weight: 800; font-size: 20px;">
                                <i class="fa-solid fa-link"></i>
                            </div>
                            <h3 class="fw-bold text-white mb-2">Welcome</h3>
                            
                            <!-- Chosen account pill -->
                            <div class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill border border-secondary" style="background: rgba(255,255,255,0.05); cursor: pointer;" onclick="goBackToGoogleStep1()" title="Switch Account">
                                <div class="avatar-circle" id="googleStep2Avatar" style="width: 22px; height: 22px; font-size: 11px;">S</div>
                                <span class="small text-white" id="googleStep2Email">suniljadhav152005@gmail.com</span>
                                <i class="fa-solid fa-chevron-down text-secondary ms-1" style="font-size: 10px;"></i>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="text-secondary small mb-1">Enter your password <span class="text-danger">*</span></label>
                            <input type="password" name="password" id="googleAuthPassword" class="form-control google-input-outline" placeholder="Enter your password" required>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="googleShowPassCheck" onchange="togglePasswordCheck('googleAuthPassword', this.checked)">
                            <label class="form-check-label text-secondary small" for="googleShowPassCheck">
                                Show password
                            </label>
                        </div>

                        <div class="d-flex align-items-center justify-content-between pt-3">
                            <button type="button" class="btn-google-text" onclick="proceedToGoogleRegistration()">Try another way</button>
                            <button type="submit" class="btn-google-next">Next</button>
                        </div>
                    </div>

                    <!-- STEP 3: COMPLETE REGISTRATION (Screenshot 4) -->
                    <div id="googleStep3" class="google-oauth-body animate-fade-in" style="display: none;">
                        <div class="text-center mb-4">
                            <div class="d-inline-flex p-3 rounded-4 mb-2" style="background: #4f46e5; color: #ffffff; font-weight: 800; font-size: 24px;">
                                <i class="fa-solid fa-link"></i>
                            </div>
                            <h4 class="fw-bold text-white mb-1">Complete registration</h4>
                            <p class="text-secondary small">Set up your profile to finish creating your account</p>
                        </div>

                        <div class="mb-3">
                            <label class="text-secondary small mb-1 uppercase fw-bold">FULL NAME (DISPLAYED)</label>
                            <input type="text" id="googleRegName" class="form-control google-input-outline" value="Sunil Jadhav" oninput="updateProfileUrlPreview(this.value)">
                        </div>

                        <div class="mb-3">
                            <div class="text-secondary small">Your profile URL</div>
                            <div class="text-white fw-semibold" id="googleProfileUrlPreview">careerlink.com/SunilJadhav</div>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="googleOptInNews" checked>
                            <label class="form-check-label text-secondary small" for="googleOptInNews">
                                Email me CareerLink news and updates<br>
                                <span class="text-muted" style="font-size: 11px;">You can opt out at any time</span>
                            </label>
                        </div>

                        <div class="d-flex align-items-center justify-content-between pt-3">
                            <button type="button" class="btn-google-text" onclick="goBackToGoogleStep1()">Cancel</button>
                            <button type="submit" class="btn-google-next">Next</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- LINKEDIN OAUTH AUTHENTICATION MODAL                                       -->
    <!-- ========================================================================= -->
    <div class="modal fade" id="linkedinAuthModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 480px;">
            <div class="modal-content modal-content-glass">
                <div class="modal-header border-bottom">
                    <div class="d-flex align-items-center gap-2">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="#0a66c2">
                            <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/>
                        </svg>
                        <h5 class="modal-title fw-bold mb-0">LinkedIn Sign In</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="oauth-auth" method="post" id="linkedinOAuthForm">
                    <input type="hidden" name="provider" value="linkedin">
                    <input type="hidden" name="roleType" id="linkedinRoleType" value="candidate">

                    <div class="modal-body p-4">
                        <div class="text-center mb-4">
                            <h5 class="fw-bold mb-1">Sign in to CareerLink</h5>
                            <p class="text-secondary small">Authenticate using your LinkedIn credentials</p>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">Email or Phone <span class="text-danger">*</span></label>
                            <input type="text" name="email" id="linkedinEmailInput" class="form-control form-control-glass" value="seeker1@gmail.com" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">Password <span class="text-danger">*</span></label>
                            <div class="input-group-password">
                                <input type="password" name="password" id="linkedinPasswordInput" class="form-control form-control-glass" placeholder="••••••••" required>
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('linkedinPasswordInput', this)">
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-custom">Display Name</label>
                            <input type="text" name="name" id="linkedinNameInput" class="form-control form-control-glass" value="Sunil Jadhav" required>
                        </div>

                        <div class="p-3 bg-indigo-soft rounded-3 small text-secondary">
                            <i class="fa-solid fa-shield-halved me-1 text-indigo"></i> <strong>Encrypted Security:</strong> Identity credential verified with official OAuth provider.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-secondary-premium" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-premium" style="background: #0a66c2; border-color: #0a66c2;">
                            <i class="fa-brands fa-linkedin me-1"></i>Sign In with LinkedIn
                        </button>
                    </div>
                </form>
            </div>
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

    <!-- Tab Switching & OAuth Flow Scripts -->
    <script>
        function switchRole(role) {
            document.getElementById('roleType').value = role;

            document.getElementById('tab-candidate').classList.remove('active');
            document.getElementById('tab-hr').classList.remove('active');
            document.getElementById('tab-admin').classList.remove('active');
            document.getElementById('tab-' + role).classList.add('active');

            const emailLabel = document.getElementById('email-label');
            const emailInput = document.getElementById('loginEmail');
            const regRedirect = document.getElementById('register-redirect');
            const regLink = document.getElementById('reg-link');
            const socialSection = document.getElementById('social-auth-section');
            const emailFormSection = document.getElementById('email-form-section');
            const forgotLink = document.getElementById('forgot-link');

            // Update modal hidden inputs
            document.getElementById('googleRoleType').value = role;
            document.getElementById('linkedinRoleType').value = role;

            if (role === 'admin') {
                emailLabel.innerText = "Admin Username";
                emailInput.placeholder = "admin@careerlink.com";
                regRedirect.style.display = "none";
                socialSection.style.display = "none";
                emailFormSection.style.display = "block";
                forgotLink.style.display = "none";
            } else if (role === 'hr') {
                emailLabel.innerText = "Recruiter Email";
                emailInput.placeholder = "recruiter@company.com";
                regRedirect.style.display = "block";
                regLink.href = "register.jsp?role=hr";
                socialSection.style.display = "block";
                forgotLink.style.display = "inline";
                forgotLink.href = "forgot-password.jsp?role=hr";

                // Update Google 3rd account demo
                document.getElementById('googleRoleName').innerText = "HR Manager";
                document.getElementById('googleRoleEmail').innerText = "hr@infosys.com";
                document.getElementById('googleRoleAvatar').innerText = "H";
                document.getElementById('linkedinEmailInput').value = "hr@infosys.com";
                document.getElementById('linkedinNameInput').value = "Sarah Jenkins";
            } else {
                emailLabel.innerText = "Email Address";
                emailInput.placeholder = "name@example.com";
                regRedirect.style.display = "block";
                regLink.href = "register.jsp";
                socialSection.style.display = "block";
                forgotLink.style.display = "inline";
                forgotLink.href = "forgot-password.jsp";

                // Update Google 3rd account demo
                document.getElementById('googleRoleName').innerText = "Aditya Bhosale";
                document.getElementById('googleRoleEmail').innerText = "seeker1@gmail.com";
                document.getElementById('googleRoleAvatar').innerText = "A";
                document.getElementById('linkedinEmailInput').value = "seeker1@gmail.com";
                document.getElementById('linkedinNameInput').value = "Aditya Bhosale";
            }
        }

        function toggleEmailSection() {
            const formSection = document.getElementById('email-form-section');
            if (formSection.style.display === 'none' || formSection.style.display === '') {
                formSection.style.display = 'block';
                formSection.scrollIntoView({ behavior: 'smooth' });
            } else {
                formSection.style.display = 'none';
            }
        }

        // ==========================================
        // Google Multi-Step OAuth Modal Functions
        // ==========================================
        function startGoogleAuth() {
            goBackToGoogleStep1();
            const modal = new bootstrap.Modal(document.getElementById('googleAuthModal'));
            modal.show();
        }

        function selectGoogleAccount(name, email, color, initial) {
            document.getElementById('googleSelectedName').value = name;
            document.getElementById('googleSelectedEmail').value = email;
            document.getElementById('googleRegName').value = name;
            updateProfileUrlPreview(name);

            document.getElementById('googleStep2Email').innerText = email;
            const avatar = document.getElementById('googleStep2Avatar');
            avatar.innerText = initial;
            avatar.style.background = color;

            document.getElementById('googleStep1').style.display = 'none';
            document.getElementById('googleStep2').style.display = 'block';
            document.getElementById('googleStep3').style.display = 'none';
            
            setTimeout(() => {
                document.getElementById('googleAuthPassword').focus();
            }, 300);
        }

        function showGoogleCustomInput() {
            const div = document.getElementById('googleCustomInputDiv');
            div.style.display = div.style.display === 'none' ? 'block' : 'none';
        }

        function applyGoogleCustomEmail() {
            const email = document.getElementById('googleCustomEmail').value;
            if (!email || !email.includes('@')) {
                alert('Please enter a valid Google email address.');
                return;
            }
            const name = email.split('@')[0];
            selectGoogleAccount(name, email, '#4f46e5', name.charAt(0).toUpperCase());
        }

        function goBackToGoogleStep1() {
            document.getElementById('googleStep1').style.display = 'block';
            document.getElementById('googleStep2').style.display = 'none';
            document.getElementById('googleStep3').style.display = 'none';
        }

        function proceedToGoogleRegistration() {
            document.getElementById('googleStep1').style.display = 'none';
            document.getElementById('googleStep2').style.display = 'none';
            document.getElementById('googleStep3').style.display = 'block';
        }

        function updateProfileUrlPreview(name) {
            const cleanName = (name || 'User').replace(/[^a-zA-Z0-9]/g, '');
            document.getElementById('googleProfileUrlPreview').innerText = 'careerlink.com/' + cleanName;
        }

        // ==========================================
        // LinkedIn OAuth Modal Functions
        // ==========================================
        function startLinkedInAuth() {
            const modal = new bootstrap.Modal(document.getElementById('linkedinAuthModal'));
            modal.show();
        }

        // Initialize based on URL queries
        window.addEventListener('load', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const role = urlParams.get('role');
            if (role === 'hr' || role === 'recruiter') {
                switchRole('hr');
            } else if (role === 'admin') {
                switchRole('admin');
            } else if (role === 'candidate' || role === 'seeker') {
                switchRole('candidate');
            }
        });
    </script>
</body>

</html>