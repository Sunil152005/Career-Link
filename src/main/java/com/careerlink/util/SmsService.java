package com.careerlink.util;

/**
 * Mobile SMS Notification Service for CareerLink Security.
 * Dispatches and logs verification OTPs to registered mobile numbers.
 */
public class SmsService {

    public static void sendOtpSms(String mobileNumber, String otpCode) {
        if (mobileNumber == null || mobileNumber.trim().isEmpty()) {
            return;
        }
        String cleanMobile = mobileNumber.trim();
        String masked = EmailService.maskMobile(cleanMobile);
        
        System.out.println("--------------------------------------------------------------------------------");
        System.out.println("[CareerLink Security SMS Dispatch]");
        System.out.println("Recipient Mobile : " + masked + " (" + cleanMobile + ")");
        System.out.println("SMS VERIFICATION : [ " + otpCode + " ] is your CareerLink OTP (valid for 10 mins).");
        System.out.println("--------------------------------------------------------------------------------");
    }
}
