package com.jobportal.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.jobportal.dao.UserDAO;
import com.jobportal.model.User;
import com.jobportal.util.PasswordHash;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // 1. Security Check: Ensure user is actually logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // 2. Extract the email dynamically from the logged-in User object
        User loggedInUser = (User) session.getAttribute("user");
        String email = loggedInUser.getEmail(); 
        
        // 3. Grab the form inputs
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // 4. Validate new passwords match
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMsg", "New passwords do not match!");
            response.sendRedirect("changePassword.jsp");
            return;
        }
        
        UserDAO userDao = new UserDAO();
        
        // 5. VERIFY OLD PASSWORD: Use your existing login method!
       
        User verifyOldUser = userDao.validateUser(email, oldPassword); 
        
        // If the user object comes back null, they typed their current password incorrectly
        if (verifyOldUser == null) {
            session.setAttribute("errorMsg", "Incorrect current password. Please try again.");
            response.sendRedirect("changePassword.jsp");
            return;
        }
        
        // 6. If old password is correct, hash the new one and save it
        String newHashed = PasswordHash.hashPassword(newPassword);
        boolean isUpdated = userDao.updateOnlyPassword(email, newHashed);
        
        // 7. Redirect with appropriate message
        if (isUpdated) {
            session.setAttribute("successMsg", "Password successfully changed!");
            response.sendRedirect("changePassword.jsp");
        } else {
            session.setAttribute("errorMsg", "Database error. Could not update password.");
            response.sendRedirect("changePassword.jsp");
        }
    }
}