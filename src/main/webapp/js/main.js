/**
 * CareerLink - Client Scripts & Security Utilities (v2026.5)
 */

// Toggle Password Visibility (Eye Button)
function togglePassword(inputId, buttonElement) {
    const input = document.getElementById(inputId);
    if (!input) return;

    const icon = buttonElement ? buttonElement.querySelector('i') : null;

    if (input.type === 'password') {
        input.type = 'text';
        if (icon) {
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        }
    } else {
        input.type = 'password';
        if (icon) {
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
}

// Toggle Password Visibility via Checkbox (e.g. Google Show Password checkbox)
function togglePasswordCheck(inputId, isChecked) {
    const input = document.getElementById(inputId);
    if (!input) return;
    input.type = isChecked ? 'text' : 'password';
}

// Global OTP Dispatch Handler (Never displays raw OTP in DOM; sends to registered email/mobile)
function sendGlobalPasswordOtp(btn, feedbackId, contextPath) {
    if (!btn) return;
    const feedback = document.getElementById(feedbackId);
    btn.disabled = true;
    const originalText = btn.innerHTML;
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i>Sending OTP...';

    if (feedback) {
        feedback.style.display = 'block';
        feedback.className = 'alert alert-info py-2 small mb-3';
        feedback.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin me-1"></i>Dispatching verification OTP to registered email / mobile...';
    }

    const endpoint = (contextPath || '..') + '/otp-password?action=sendOtp';

    fetch(endpoint, {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(async r => {
        const data = await r.json().catch(() => null);
        if (!data) throw new Error('Server returned invalid response');
        return data;
    })
    .then(data => {
        if (data.status === 'success') {
            if (feedback) {
                feedback.className = 'alert alert-success py-2 small mb-3';
                feedback.innerHTML = '<i class="fa-solid fa-circle-check me-1"></i>' + (data.message || 'Verification OTP sent to your registered email/mobile. Check your inbox.');
            }
            // Start 30s cooldown timer
            let countdown = 30;
            btn.innerHTML = '<i class="fa-solid fa-clock me-1"></i>Resend in ' + countdown + 's';
            const timer = setInterval(() => {
                countdown--;
                if (countdown <= 0) {
                    clearInterval(timer);
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fa-solid fa-rotate-right me-1"></i>Resend OTP';
                } else {
                    btn.innerHTML = '<i class="fa-solid fa-clock me-1"></i>Resend in ' + countdown + 's';
                }
            }, 1000);
        } else {
            if (feedback) {
                feedback.className = 'alert alert-danger py-2 small mb-3';
                feedback.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i>' + (data.message || 'Unable to dispatch OTP.');
            }
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-paper-plane me-1"></i>Retry Send OTP';
        }
    })
    .catch(err => {
        console.error('OTP Send Error:', err);
        if (feedback) {
            feedback.className = 'alert alert-danger py-2 small mb-3';
            feedback.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i>Network error while dispatching OTP. Please try again.';
        }
        btn.disabled = false;
        btn.innerHTML = '<i class="fa-solid fa-paper-plane me-1"></i>Send OTP Code';
    });
}

// Global OTP Verification & Password Change Form Handler
function submitGlobalOtpPassword(event, form, alertId, submitBtnId) {
    if (event) event.preventDefault();
    if (!form) return;

    const alertBox = document.getElementById(alertId);
    const submitBtn = document.getElementById(submitBtnId);

    const otpInput = form.querySelector('[name="otp"]');
    const newPassInput = form.querySelector('[name="newPassword"]');
    const confirmPassInput = form.querySelector('[name="confirmPassword"]');

    const otp = (otpInput ? otpInput.value : '').trim();
    const newPass = (newPassInput ? newPassInput.value : '');
    const confirmPass = (confirmPassInput ? confirmPassInput.value : '');

    // Client-side quick validations
    if (!otp || otp.length !== 6 || !/^\d{6}$/.test(otp)) {
        if (alertBox) {
            alertBox.style.display = 'block';
            alertBox.className = 'alert alert-danger py-2 small mb-3';
            alertBox.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i>Please enter a valid 6-digit numeric OTP code received on your registered email/mobile.';
        }
        if (otpInput) otpInput.focus();
        return;
    }

    if (!newPass || newPass.length < 6) {
        if (alertBox) {
            alertBox.style.display = 'block';
            alertBox.className = 'alert alert-danger py-2 small mb-3';
            alertBox.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i>New password must be at least 6 characters long.';
        }
        if (newPassInput) newPassInput.focus();
        return;
    }

    if (newPass !== confirmPass) {
        if (alertBox) {
            alertBox.style.display = 'block';
            alertBox.className = 'alert alert-danger py-2 small mb-3';
            alertBox.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i>Passwords do not match. Please re-enter identical passwords.';
        }
        if (confirmPassInput) confirmPassInput.focus();
        return;
    }

    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i>Verifying OTP & Updating...';
    }

    const formData = new FormData(form);
    const urlParams = new URLSearchParams(formData);

    // Ensure we resolve the URL correctly without DOM property name collision with <input name="action">
    const actionUrl = form.getAttribute('action') || (typeof form.action === 'string' ? form.action : '../otp-password');

    fetch(actionUrl, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: urlParams.toString()
    })
    .then(async r => {
        const data = await r.json().catch(() => null);
        if (!data) throw new Error('Server returned invalid response');
        return data;
    })
    .then(data => {
        if (data.status === 'success') {
            if (alertBox) {
                alertBox.style.display = 'block';
                alertBox.className = 'alert alert-success py-2 small mb-3';
                alertBox.innerHTML = '<i class="fa-solid fa-circle-check me-1"></i><strong>Success!</strong> ' + (data.message || 'Password changed successfully.');
            }
            form.reset();
            if (submitBtn) {
                submitBtn.innerHTML = '<i class="fa-solid fa-check me-1"></i>Password Updated!';
                submitBtn.className = 'btn btn-success';
            }
            setTimeout(() => {
                window.location.reload();
            }, 1400);
        } else {
            if (alertBox) {
                alertBox.style.display = 'block';
                alertBox.className = 'alert alert-danger py-2 small mb-3';
                alertBox.innerHTML = '<i class="fa-solid fa-circle-xmark me-1"></i><strong>Verification Failed:</strong> ' + (data.message || 'Incorrect OTP or update failed.');
            }
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = 'Update Password';
            }
            if (otpInput) {
                otpInput.focus();
                otpInput.select();
            }
        }
    })
    .catch(err => {
        console.error('Password Update Error:', err);
        if (alertBox) {
            alertBox.style.display = 'block';
            alertBox.className = 'alert alert-danger py-2 small mb-3';
            alertBox.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i>Network or server error during verification. Please try again.';
        }
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Update Password';
        }
    });
}

// Automatic back-forward cache reload to ensure saved changes are always visible
window.addEventListener('pageshow', function (event) {
    if (event.persisted || (window.performance && window.performance.getEntriesByType("navigation")[0]?.type === "back_forward")) {
        window.location.reload();
    }
});
