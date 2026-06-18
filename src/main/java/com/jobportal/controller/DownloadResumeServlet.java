package com.jobportal.controller;

import com.jobportal.dao.ApplicationDAO;
import com.jobportal.model.Application;
import com.jobportal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/download-resume")
public class DownloadResumeServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int appId = Integer.parseInt(request.getParameter("appId"));
        
        ApplicationDAO appDAO = new ApplicationDAO();
        Application app = appDAO.getApplicationById(appId);
        
        if (app == null || app.getResumeFile() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resume not found");
            return;
        }
        
        // Simple security: jobseeker can only download their own resume
        if ("jobseeker".equals(user.getRole())) {
            Integer seekerId = (Integer) request.getSession().getAttribute("seekerId");
            if (seekerId == null || seekerId != app.getSeekerId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }
        // Recruiters can download any resume
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"resume.pdf\"");
        response.setContentLength(app.getResumeFile().length);
        
        try (OutputStream out = response.getOutputStream()) {
            out.write(app.getResumeFile());
            out.flush();
        }
    }
}