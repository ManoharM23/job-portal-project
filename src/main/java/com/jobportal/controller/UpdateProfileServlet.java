package com.jobportal.controller;

import com.jobportal.dao.*;
import com.jobportal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = request.getParameter("role");
        int userId = user.getUserId();
        
        // Update common user fields
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        
        UserDAO userDAO = new UserDAO();
        boolean userUpdated = userDAO.updateUser(userId, fullName, phone);
        
        // Refresh user object in session
        if (userUpdated) {
            User updatedUser = userDAO.getUserById(userId);
            session.setAttribute("user", updatedUser);
        }
        
        if ("recruiter".equals(role)) {
            // SAFE: Get recruiterId from session OR lookup from DB
            Integer recruiterIdObj = (Integer) session.getAttribute("recruiterId");
            int recruiterId;
            
            if (recruiterIdObj == null) {
                RecruiterDAO recDAO = new RecruiterDAO();
                recruiterId = recDAO.getRecruiterIdByUserId(userId);
                session.setAttribute("recruiterId", recruiterId); // cache it
            } else {
                recruiterId = recruiterIdObj;
            }
            
            String companyName = request.getParameter("companyName");
            String industry = request.getParameter("industry");
            String location = request.getParameter("location");
            String website = request.getParameter("website");
            String companyDescription = request.getParameter("companyDescription");
            
            RecruiterDAO recDAO = new RecruiterDAO();
            recDAO.updateProfile(recruiterId, companyName, industry, location, website, companyDescription);
            response.sendRedirect("recruiter/edit-profile.jsp?msg=updated");
            
        } else if ("jobseeker".equals(role)) {
            // SAFE: Get seekerId from session OR lookup from DB
            Integer seekerIdObj = (Integer) session.getAttribute("seekerId");
            int seekerId;
            
            if (seekerIdObj == null) {
                JobSeekerDAO seekDAO = new JobSeekerDAO();
                seekerId = seekDAO.getSeekerIdByUserId(userId);
                session.setAttribute("seekerId", seekerId); // cache it
            } else {
                seekerId = seekerIdObj;
            }
            
            String skills = request.getParameter("skills");
            String experienceStr = request.getParameter("experienceYears");
            String education = request.getParameter("education");
            String location = request.getParameter("location");
            String salaryStr = request.getParameter("expectedSalary");
            
            int experienceYears = 0;
            double expectedSalary = 0;
            
            try {
                if (experienceStr != null && !experienceStr.isEmpty()) {
                    experienceYears = Integer.parseInt(experienceStr);
                }
                if (salaryStr != null && !salaryStr.isEmpty()) {
                    expectedSalary = Double.parseDouble(salaryStr);
                }
            } catch (NumberFormatException e) {
                // ignore
            }
            
            JobSeekerDAO seekDAO = new JobSeekerDAO();
            seekDAO.updateProfile(seekerId, skills, experienceYears, education, location, expectedSalary);
            response.sendRedirect("jobseeker/edit-profile.jsp?msg=updated");
        }
    }
}