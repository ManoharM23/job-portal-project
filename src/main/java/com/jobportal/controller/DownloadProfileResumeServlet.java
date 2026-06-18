package com.jobportal.controller;

import com.jobportal.dao.JobSeekerDAO;
import com.jobportal.model.JobSeeker;
import com.jobportal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/download-profile-resume")
public class DownloadProfileResumeServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Integer seekerId = (Integer) request.getSession().getAttribute("seekerId");
        if (seekerId == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        JobSeekerDAO seekDAO = new JobSeekerDAO();
        JobSeeker seeker = seekDAO.getJobSeekerById(seekerId);
        
        if (seeker == null || !seeker.hasResume()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No resume found");
            return;
        }
        
        // Security: only owner can download
        if ("jobseeker".equals(user.getRole())) {
            JobSeeker check = seekDAO.getJobSeekerByUserId(user.getUserId());
            if (check == null || check.getSeekerId() != seekerId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }
        
        String fileName = seeker.getResumeFileName();
        if (fileName == null || fileName.isEmpty()) {
            fileName = "resume.pdf";
        }
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.setContentLength(seeker.getResumeFile().length);
        
        try (OutputStream out = response.getOutputStream()) {
            out.write(seeker.getResumeFile());
            out.flush();
        }
    }
}