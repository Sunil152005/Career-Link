package com.careerlink.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * High-Security Email Service for CareerLink.
 * Dispatches verification OTPs and security alerts to registered Gmail / Email addresses.
 * 
 * Supports Gmail SMTP (smtp.gmail.com:587) with App Passwords, Custom SMTP, 
 * and local secure console logging.
 */
public class EmailService {

    private static final ExecutorService mailExecutor = Executors.newCachedThreadPool();

    /**
     * Loads SMTP configuration dynamically from:
     * 1. Classpath (src/main/resources/email.properties)
     * 2. User home config (~/.careerlink/email.properties)
     * 3. System Properties (careerlink.smtp.*)
     * 4. Environment Variables (SMTP_USER, SMTP_PASSWORD, GMAIL_USER, GMAIL_APP_PASSWORD)
     */
    public static Properties loadEmailConfig() {
        Properties props = new Properties();

        // Default settings
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        props.put("mail.smtp.sender_name", "CareerLink Security");
        props.put("mail.smtp.user", "");
        props.put("mail.smtp.password", "");

        // 1. Try reading from classpath
        try (InputStream is = EmailService.class.getClassLoader().getResourceAsStream("email.properties")) {
            if (is != null) {
                props.load(is);
            }
        } catch (Exception e) {
            // Silently continue to fallback
        }

        // 2. Try reading from user home (~/.careerlink/email.properties)
        try {
            String userHome = System.getProperty("user.home");
            File externalConfig = new File(userHome, ".careerlink/email.properties");
            if (externalConfig.exists() && externalConfig.canRead()) {
                try (FileInputStream fis = new FileInputStream(externalConfig)) {
                    props.load(fis);
                }
            }
        } catch (Exception e) {
            // Silently continue
        }

        // 3. Override from System Properties if set
        if (System.getProperty("careerlink.smtp.host") != null) props.put("mail.smtp.host", System.getProperty("careerlink.smtp.host"));
        if (System.getProperty("careerlink.smtp.port") != null) props.put("mail.smtp.port", System.getProperty("careerlink.smtp.port"));
        if (System.getProperty("careerlink.smtp.user") != null) props.put("mail.smtp.user", System.getProperty("careerlink.smtp.user"));
        if (System.getProperty("careerlink.smtp.password") != null) props.put("mail.smtp.password", System.getProperty("careerlink.smtp.password"));

        // 4. Override from Environment Variables if set
        String envUser = System.getenv("GMAIL_USER");
        if (envUser == null) envUser = System.getenv("SMTP_USER");
        if (envUser == null) envUser = System.getenv("CAREERLINK_EMAIL");
        if (envUser != null && !envUser.trim().isEmpty()) {
            props.put("mail.smtp.user", envUser.trim());
        }

        String envPass = System.getenv("GMAIL_APP_PASSWORD");
        if (envPass == null) envPass = System.getenv("SMTP_PASSWORD");
        if (envPass == null) envPass = System.getenv("CAREERLINK_EMAIL_PASSWORD");
        if (envPass != null && !envPass.trim().isEmpty()) {
            props.put("mail.smtp.password", envPass.trim());
        }

        return props;
    }

    /**
     * Dispatches an OTP verification email to the user's registered email address.
     */
    public static void sendOtpEmail(String recipientEmail, String recipientName, String otpCode) {
        if (recipientEmail == null || recipientEmail.trim().isEmpty()) {
            return;
        }

        final String safeRecipient = recipientEmail.trim();
        final String safeName = (recipientName != null && !recipientName.trim().isEmpty()) ? recipientName.trim() : "CareerLink User";

        // Dispatch in background thread for instantaneous web request response
        mailExecutor.submit(() -> {
            Properties config = loadEmailConfig();
            String host = config.getProperty("mail.smtp.host", "smtp.gmail.com").trim();
            String port = config.getProperty("mail.smtp.port", "587").trim();
            String user = config.getProperty("mail.smtp.user", "").trim();
            String pass = config.getProperty("mail.smtp.password", "").trim();
            String senderName = config.getProperty("mail.smtp.sender_name", "CareerLink Security").trim();

            boolean hasCredentials = !user.isEmpty() && !pass.isEmpty();

            if (hasCredentials) {
                try {
                    Properties mailProps = new Properties();
                    mailProps.put("mail.smtp.auth", "true");
                    mailProps.put("mail.smtp.starttls.enable", "true");
                    mailProps.put("mail.smtp.host", host);
                    mailProps.put("mail.smtp.port", port);
                    mailProps.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
                    mailProps.put("mail.smtp.connectiontimeout", "7000");
                    mailProps.put("mail.smtp.timeout", "7000");

                    Session session = Session.getInstance(mailProps, new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(user, pass);
                        }
                    });

                    Message message = new MimeMessage(session);
                    message.setFrom(new InternetAddress(user, senderName));
                    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(safeRecipient));
                    message.setSubject("🔒 " + otpCode + " is your CareerLink Security Verification OTP");

                    String htmlContent = buildOtpHtmlBody(safeName, safeRecipient, otpCode);
                    message.setContent(htmlContent, "text/html; charset=UTF-8");

                    Transport.send(message);
                    System.out.println("[CareerLink Security] ✓ Successfully sent verification OTP to " + maskEmail(safeRecipient) + " via SMTP (" + host + ").");
                    return;
                } catch (Exception e) {
                    System.err.println("[CareerLink Security] SMTP Transmission failed for " + safeRecipient + ": " + e.getMessage());
                }
            }

            // Always display clear secure server log for development / debugging
            System.out.println("\n================================================================================");
            System.out.println("[CareerLink Security System - OTP Dispatched]");
            System.out.println("Recipient Name : " + safeName);
            System.out.println("Recipient Email: " + safeRecipient + " (" + maskEmail(safeRecipient) + ")");
            System.out.println("VERIFICATION OTP: [ " + otpCode + " ] (Valid for 10 minutes)");
            if (!hasCredentials) {
                System.out.println("Note: SMTP credentials not set in email.properties. (Using local security dispatcher)");
            }
            System.out.println("================================================================================\n");
        });
    }

    /**
     * Builds a modern, responsive HTML email template for password reset OTP.
     */
    private static String buildOtpHtmlBody(String name, String email, String otpCode) {
        return "<!DOCTYPE html>"
                + "<html><head><meta charset=\"utf-8\">"
                + "<style>"
                + "body { font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #f8fafc; margin: 0; padding: 24px; color: #1e293b; }"
                + ".card { max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 14px; border: 1px solid #e2e8f0; overflow: hidden; box-shadow: 0 6px 18px rgba(0,0,0,0.06); }"
                + ".header { background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%); padding: 26px 20px; text-align: center; color: #ffffff; }"
                + ".header h1 { margin: 0; font-size: 22px; font-weight: 700; letter-spacing: -0.5px; }"
                + ".content { padding: 32px 28px; }"
                + ".otp-box { background: #f1f5f9; border: 2px dashed #6366f1; border-radius: 10px; padding: 20px; text-align: center; margin: 24px 0; }"
                + ".otp-code { font-size: 34px; font-weight: 800; letter-spacing: 8px; color: #4338ca; margin: 0; font-family: monospace; }"
                + ".warning { font-size: 13px; color: #64748b; margin-top: 24px; border-top: 1px solid #e2e8f0; padding-top: 16px; line-height: 1.5; }"
                + ".footer { text-align: center; font-size: 12px; color: #94a3b8; padding: 18px; background: #f8fafc; border-top: 1px solid #f1f5f9; }"
                + "</style></head><body>"
                + "<div class=\"card\">"
                + "<div class=\"header\"><h1>CareerLink Security Verification</h1></div>"
                + "<div class=\"content\">"
                + "<p>Hello <strong>" + escapeHtml(name) + "</strong>,</p>"
                + "<p>A request was received to verify your identity and update your CareerLink account password for <strong>" + escapeHtml(email) + "</strong>.</p>"
                + "<div class=\"otp-box\">"
                + "<div style=\"font-size: 13px; color: #64748b; margin-bottom: 6px; text-transform: uppercase; font-weight: 600;\">Your 6-Digit OTP Code</div>"
                + "<div class=\"otp-code\">" + otpCode + "</div>"
                + "</div>"
                + "<p style=\"font-size: 14px; color: #475569;\">"
                + "⏳ <strong>This code is valid for 10 minutes.</strong> Enter this code in the password verification modal to proceed."
                + "</p>"
                + "<div class=\"warning\">"
                + "🔒 <strong>Security Warning:</strong> Never share this code with anyone. CareerLink staff will never ask for your verification OTP. If you did not initiate this request, your account may be at risk—please contact support immediately."
                + "</div></div>"
                + "<div class=\"footer\">&copy; 2026 CareerLink Identity &amp; Access Security System. All rights reserved.</div>"
                + "</div></body></html>";
    }

    /**
     * Masks an email address for privacy and security display (e.g., "s***2@gmail.com").
     */
    public static String maskEmail(String email) {
        if (email == null || !email.contains("@")) {
            return "your registered email";
        }
        int atIndex = email.indexOf("@");
        String name = email.substring(0, atIndex);
        String domain = email.substring(atIndex);

        if (name.length() <= 2) {
            return name.charAt(0) + "***" + domain;
        } else {
            return name.charAt(0) + "***" + name.charAt(name.length() - 1) + domain;
        }
    }

    /**
     * Masks a mobile number for privacy and security display (e.g., "******0895").
     */
    public static String maskMobile(String mobile) {
        if (mobile == null || mobile.trim().isEmpty()) {
            return "";
        }
        String clean = mobile.replaceAll("[^0-9]", "");
        if (clean.length() <= 4) {
            return "******" + clean;
        }
        String last4 = clean.substring(clean.length() - 4);
        return "******" + last4;
    }

    private static String escapeHtml(String str) {
        if (str == null) return "";
        return str.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;");
    }
}
