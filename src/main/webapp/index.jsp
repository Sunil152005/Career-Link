<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CareerLink - Online Job Portal & Recruitment Management System</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- FontAwesome Icons -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <!-- Custom Styles -->
        <link href="css/style.css" rel="stylesheet">
    </head>

    <body>

        <!-- Header Navigation -->
        <nav class="navbar navbar-expand-lg navbar-custom navbar-dark fixed-top">
            <div class="container">
                <a class="navbar-brand" href="index.jsp">
                    <i class="fa-solid fa-link me-2"></i>CareerLink
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item">
                            <a class="nav-link me-3" href="index.jsp">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link me-3" href="login.jsp">Find Jobs</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link me-3" href="register.jsp?role=hr">Post a Job</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link me-4" href="#contact-section">Contact Admin</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn-premium py-2 px-4" href="login.jsp">Sign In</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <section class="hero-section text-center text-lg-start">
            <div class="container">
                <div class="row align-items-center min-vh-100">
                    <div class="col-lg-6 mb-5 mb-lg-0 animate-fade-in">
                        <span class="badge-neon applied mb-3">🔥 Next-Generation Hiring</span>
                        <h1 class="hero-title">Connect. Interview. Get Hired.</h1>
                        <p class="hero-subtitle">
                            CareerLink streamlines the recruitment lifecycle. Whether you're a candidate looking for
                            your next challenge or an HR specialist searching for exceptional talent, we build the
                            bridge.
                        </p>
                        <div class="d-flex flex-column flex-sm-row gap-3">
                            <a class="btn-premium d-inline-flex align-items-center justify-content-center"
                                href="register.jsp?role=candidate">
                                <i class="fa-solid fa-user-tie me-2"></i>I'm Looking for a Job
                            </a>
                            <a class="btn-outline-glass d-inline-flex align-items-center justify-content-center"
                                href="register.jsp?role=hr">
                                <i class="fa-solid fa-building me-2"></i>I'm Hiring Talent
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-6 animate-fade-in text-center">
                        <div class="glass-panel p-5 d-inline-block shadow-lg" style="max-width: 480px; width: 100%;">
                            <div class="d-flex align-items-center justify-content-between mb-4 pb-3"
                                style="border-bottom: 1px solid var(--border-glass);">
                                <div class="text-start">
                                    <div class="fw-bold text-dark">Live Job Statistics</div>
                                    <div class="small text-secondary">Updated Real-Time</div>
                                </div>
                                <span class="badge-neon selected">Active</span>
                            </div>
                            <div class="row g-3 text-start">
                                <div class="col-6">
                                    <div class="p-3 rounded-3" style="background: rgba(99, 102, 241, 0.08);">
                                        <div class="fs-4 fw-bold text-indigo">100+</div>
                                        <div class="small text-secondary">Verified Openings</div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="p-3 rounded-3" style="background: rgba(236, 72, 153, 0.08);">
                                        <div class="fs-4 fw-bold text-pink">50+</div>
                                        <div class="small text-secondary">Top Companies</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Matrix -->
        <section class="py-5" style="border-top: 1px solid var(--border-glass);">
            <div class="container py-5">
                <div class="text-center mb-5">
                    <span class="badge-neon scheduled mb-2">Capabilities</span>
                    <h2 class="display-6 fw-bold">Engineered for Modern Talent Acquisition</h2>
                    <p class="text-secondary">Comprehensive toolset built for job seekers, recruitment teams, and system admins</p>
                </div>

                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="glass-panel p-4 h-100 d-flex flex-column">
                            <div class="feature-icon mb-4" style="color: var(--primary-indigo);">
                                <i class="fa-solid fa-magnifying-glass-chart"></i>
                            </div>
                            <h4 class="mb-3">Job Seekers</h4>
                            <p class="text-secondary mb-0">
                                Discover curated opportunities, submit instant applications, track hiring stages, and join live online/offline interviews directly.
                            </p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="glass-panel p-4 h-100 d-flex flex-column">
                            <div class="feature-icon mb-4" style="color: var(--accent-pink);">
                                <i class="fa-solid fa-users-viewfinder"></i>
                            </div>
                            <h4 class="mb-3">Recruiters</h4>
                            <p class="text-secondary mb-0">
                                Publish listings, review applicants with smart candidate match fit scoring, manage schedules, and coordinate seamless interviews.
                            </p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="glass-panel p-4 h-100 d-flex flex-column">
                            <div class="feature-icon mb-4" style="color: #10b981;">
                                <i class="fa-solid fa-user-gear"></i>
                            </div>
                            <h4 class="mb-3">Administrators</h4>
                            <p class="text-secondary mb-0">
                                Monitor job-posting operations, manage Candidate and HR credentials, analyze reports, and resolve user support inquiries.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Contact Us & Admin Helpdesk Section -->
        <section id="contact-section" class="py-5" style="background: linear-gradient(180deg, rgba(248,250,252,0) 0%, rgba(241,245,249,0.7) 100%); border-top: 1px solid var(--border-glass);">
            <div class="container py-5">
                <div class="text-center mb-5 animate-fade-in">
                    <span class="badge-neon applied mb-2"><i class="fa-solid fa-headset me-1"></i> 24/7 Support Desk</span>
                    <h2 class="display-6 fw-bold">Contact Administrator & Helpdesk</h2>
                    <p class="text-secondary" style="max-width: 600px; margin: 0 auto;">
                        Facing issues while navigating CareerLink or have questions regarding hiring and applications? Contact our System Admin directly for swift problem resolution.
                    </p>
                </div>

                <% if ("true".equals(request.getParameter("contactSuccess"))) { %>
                    <div class="alert alert-success alert-dismissible fade show text-center mb-4 shadow-sm mx-auto" style="max-width: 800px; border-radius: 12px;" role="alert">
                        <i class="fa-solid fa-circle-check me-2 fs-5 align-middle"></i>
                        <strong>Message Sent Successfully!</strong> The System Administrator has received your inquiry and will review and resolve your issue shortly.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <% if ("true".equals(request.getParameter("contactError"))) { %>
                    <div class="alert alert-danger alert-dismissible fade show text-center mb-4 shadow-sm mx-auto" style="max-width: 800px; border-radius: 12px;" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2 fs-5 align-middle"></i>
                        <strong>Submission Failed.</strong> Please ensure all fields are correctly filled and try again.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <div class="row g-4 justify-content-center">
                    <!-- Admin Contact Details Card -->
                    <div class="col-lg-5">
                        <div class="glass-panel p-4 p-md-5 h-100 shadow-sm d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex align-items-center mb-4">
                                    <div class="stat-icon-wrapper me-3" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-indigo); width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                                        <i class="fa-solid fa-user-shield fs-4"></i>
                                    </div>
                                    <div>
                                        <h5 class="fw-bold mb-0">System Admin Desk</h5>
                                        <div class="text-muted small">Direct Platform Operations & Support</div>
                                    </div>
                                </div>

                                <p class="text-secondary small mb-4">
                                    Our dedicated administrative team is available to assist Candidates, HR Recruiters, and Guests with any account, interview, or platform issues.
                                </p>

                                <div class="d-flex flex-column gap-3">
                                    <div class="d-flex align-items-start">
                                        <div class="text-indigo me-3 mt-1"><i class="fa-solid fa-envelope fs-5"></i></div>
                                        <div>
                                            <div class="fw-bold small text-dark">Admin Email Address</div>
                                            <a href="mailto:admin@careerlink.com" class="text-secondary text-decoration-none small">admin@careerlink.com</a>
                                            <div class="text-muted small">support@careerlink.com</div>
                                        </div>
                                    </div>

                                    <div class="d-flex align-items-start">
                                        <div class="text-pink me-3 mt-1"><i class="fa-solid fa-phone fs-5"></i></div>
                                        <div>
                                            <div class="fw-bold small text-dark">Helpline & WhatsApp Support</div>
                                            <div class="text-secondary small">+91 98765 43210 / 1800-202-LINK</div>
                                            <div class="text-muted small">Mon - Sat: 9:00 AM - 7:00 PM IST</div>
                                        </div>
                                    </div>

                                    <div class="d-flex align-items-start">
                                        <div class="text-success me-3 mt-1"><i class="fa-solid fa-location-dot fs-5"></i></div>
                                        <div>
                                            <div class="fw-bold small text-dark">Headquarters & Tech Center</div>
                                            <div class="text-secondary small">CareerLink Tower, Narhe Pune, Maharashtra, India - 411041</div>
                                        </div>
                                    </div>

                                    <div class="d-flex align-items-start">
                                        <div class="text-warning me-3 mt-1"><i class="fa-solid fa-clock fs-5"></i></div>
                                        <div>
                                            <div class="fw-bold small text-dark">Average Resolution Time</div>
                                            <div class="text-secondary small">&lt; 2 Hours for Active Queries</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="pt-4 mt-4 border-top">
                                <span class="badge-neon selected py-2 px-3 d-inline-block">
                                    <i class="fa-solid fa-bolt me-1"></i> Admin Portal Active & Monitoring
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Inquiry Form -->
                    <div class="col-lg-7">
                        <div class="glass-panel p-4 p-md-5 shadow-sm">
                            <h4 class="fw-bold mb-2">Send Inquiry / Report Problem</h4>
                            <p class="text-secondary small mb-4">Fill out the form below to reach the administrator directly. Your query will appear instantly in the Admin Control Center.</p>

                            <form action="contact" method="POST">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-dark">Your Name <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-user text-muted"></i></span>
                                            <input type="text" name="name" class="form-control border-start-0" placeholder="e.g. John Doe" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-dark">Your Email Address <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-envelope text-muted"></i></span>
                                            <input type="email" name="email" class="form-control border-start-0" placeholder="e.g. user@example.com" required>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label small fw-bold text-dark">Subject / Issue Category <span class="text-danger">*</span></label>
                                        <select name="subject" class="form-select" required>
                                            <option value="" disabled selected>Select issue category...</option>
                                            <option value="Account & Login Assistance">Account & Login Assistance</option>
                                            <option value="Candidate Application & Interview Support">Candidate Application & Interview Support</option>
                                            <option value="Recruiter Job Posting & Fit Filtration Query">Recruiter Job Posting & Fit Filtration Query</option>
                                            <option value="Technical Issue or Bug Report">Technical Issue or Bug Report</option>
                                            <option value="Feature Feedback / General Inquiry">Feature Feedback / General Inquiry</option>
                                        </select>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label small fw-bold text-dark">Detailed Message / Problem Description <span class="text-danger">*</span></label>
                                        <textarea name="message" class="form-control" rows="4" placeholder="Describe the issue you encountered or what you need assistance with..." required></textarea>
                                    </div>

                                    <div class="col-12 text-end mt-4">
                                        <button type="submit" class="btn-premium py-2 px-4 shadow">
                                            <i class="fa-solid fa-paper-plane me-2"></i>Submit to Admin
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="py-4 text-center text-muted" style="border-top: 1px solid var(--border-glass);">
            <div class="container">
                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center">
                    <p class="mb-2 mb-sm-0">&copy; 2026 CareerLink. All rights reserved.</p>
                    <div class="small">
                        <a href="login.jsp" class="text-muted text-decoration-none me-3">Login</a>
                        <a href="register.jsp" class="text-muted text-decoration-none me-3">Register</a>
                        <a href="#contact-section" class="text-muted text-decoration-none me-3">Admin Support</a>
                        <a href="login.jsp?role=admin" class="text-muted text-decoration-none">Admin Login</a>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Bootstrap Bundle JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>