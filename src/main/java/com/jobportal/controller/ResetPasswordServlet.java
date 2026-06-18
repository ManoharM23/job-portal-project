package com.jobportal.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.jobportal.dao.UserDAO;
import com.jobportal.util.PasswordHash;

@WebServlet("/updatePassword")
public class ResetPasswordServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String otp = request.getParameter("otp");
        String rawPassword = request.getParameter("newPassword");
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        
        // Security check: ensure session hasn't expired
        if (email == null) {
            session.setAttribute("errorMsg", "Session expired. Please request a new OTP.");
            response.sendRedirect("forgotPassword.jsp");
            return;
        }
        
        String newHashedPassword = PasswordHash.hashPassword(rawPassword);
        
        UserDAO userDao = new UserDAO();
        // Send the HASHED password to the database
        boolean isUpdated = userDao.resetUserPassword(email, otp, newHashedPassword);
        
        if (isUpdated) {
            session.removeAttribute("resetEmail"); 
            session.setAttribute("successMsg", "Password successfully reset! You can now log in.");
            response.sendRedirect("login.jsp");
        } else {
            session.setAttribute("errorMsg", "Invalid or expired OTP. Please try again.");
            response.sendRedirect("verifyOtp.jsp");
        }
    }
}