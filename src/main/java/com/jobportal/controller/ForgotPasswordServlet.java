package com.jobportal.controller;

import java.io.IOException;
import java.util.Random;

import com.jobportal.dao.UserDAO;
import com.jobportal.util.EmailUtility;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO userDao = new UserDAO();
        HttpSession session = request.getSession();
        
        // 1. Check if the user's email actually exists in your database
        
        // 2. Generate a random 6-digit OTP
        Random rand = new Random();
        int otp = 100000 + rand.nextInt(900000);
        String otpString = String.valueOf(otp);
        
        // 3. Save the OTP to the database (using the DAO method we discussed earlier)
        boolean isTokenSaved = userDao.saveResetToken(email, otpString);
        
        if (isTokenSaved) {
            // 4. Send the email!
            boolean isEmailSent = EmailUtility.sendOtpEmail(email, otpString);
            
            if (isEmailSent) {
                // Save email in session so we know who is trying to reset their password
                session.setAttribute("resetEmail", email);
                session.setAttribute("successMsg", "An OTP has been sent to your email!");
                response.sendRedirect("verifyOtp.jsp");
            } else {
                session.setAttribute("errorMsg", "Failed to send email. Please check your internet or email settings.");
                response.sendRedirect("forgotPassword.jsp");
            }
        } else {
            session.setAttribute("errorMsg", "Email not found in our system.");
            response.sendRedirect("forgotPassword.jsp");
        }
    }
}