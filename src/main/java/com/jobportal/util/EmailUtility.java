package com.jobportal.util;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtility {

    // Your Gmail address that will send the emails
    private static final String SENDER_EMAIL = "your_email@gmail.com";
    
    // Your 16-character Gmail App Password (NOT your normal password)
    private static final String SENDER_PASSWORD = "YOUR_16_DIGIT_APP_PASSWORD";

    public static boolean sendOtpEmail(String recipientEmail, String otpCode) {
        boolean isSent = false;

        // 1. Setup Gmail SMTP server properties
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true"); // Enables secure connection

        // 2. Authenticate the sender email
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            // 3. Draft the email
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            message.setSubject("Password Reset - Job Portal");
            
            // The actual content of the email
            String emailBody = "<h3>Password Reset Request</h3>"
                             + "<p>Your One-Time Password (OTP) to reset your account is:</p>"
                             + "<h2 style='color: blue;'>" + otpCode + "</h2>"
                             + "<p>This code will expire in 15 minutes. If you did not request this, please ignore this email.</p>";
            
            message.setContent(emailBody, "text/html; charset=utf-8");

            // 4. Send the email
            Transport.send(message);
            isSent = true;
            //System.out.println("OTP Email successfully sent to: " + recipientEmail);

        } catch (Exception e) {
            //System.out.println("Error sending email: " + e.getMessage());
            e.printStackTrace();
        }

        return isSent;
    }
}