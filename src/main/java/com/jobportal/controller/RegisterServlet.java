package com.jobportal.controller;

import com.jobportal.dao.*;
import com.jobportal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
       
        request.setCharacterEncoding("UTF-8");
        
        String role = request.getParameter("role");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        
        //System.out.println("Register attempt: email=" + email + ", role=" + role);
        
        // Validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            role == null || (!role.equals("recruiter") && !role.equals("jobseeker"))) {
            
            request.setAttribute("error", "All fields are required. Role was: " + role);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        User user = new User();
        user.setEmail(email.trim());
        user.setPassword(password);
        user.setRole(role);
        user.setFullName(fullName.trim());
        user.setPhone(phone);
        
        int userId = userDAO.registerUser(user);
        //System.out.println("registerUser returned: " + userId);
        
        if (userId > 0) {
            // Create role-specific profile
            boolean profileCreated = false;
            
            if ("recruiter".equals(role)) {
                String companyName = request.getParameter("companyName");
                if (companyName == null || companyName.trim().isEmpty()) {
                    companyName = "Not Specified"; // Prevent NULL insert
                }
                RecruiterDAO recDAO = new RecruiterDAO();
                profileCreated = recDAO.createProfile(userId, companyName.trim());
                //System.out.println("Recruiter profile created: " + profileCreated);
                
            } else {
                JobSeekerDAO seekDAO = new JobSeekerDAO();
                profileCreated = seekDAO.createProfile(userId);
                //System.out.println("JobSeeker profile created: " + profileCreated);
            }
            
            if (profileCreated) {
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "User created but profile setup failed. Please contact admin.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            
        } else {
            
            request.setAttribute("error", "Registration failed. DAO Error: " + userDAO.getLastError());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}