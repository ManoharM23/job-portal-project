package com.jobportal.controller;

import com.jobportal.dao.ApplicationDAO;
import com.jobportal.dao.JobSeekerDAO;
import com.jobportal.model.Application;
import com.jobportal.model.JobSeeker;
import com.jobportal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/apply")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 20
)
public class ApplyJobServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"jobseeker".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int seekerId;
        Integer seekerIdObj = (Integer) request.getSession().getAttribute("seekerId");
        if (seekerIdObj == null) {
            JobSeekerDAO seekDAO = new JobSeekerDAO();
            seekerId = seekDAO.getSeekerIdByUserId(user.getUserId());
            request.getSession().setAttribute("seekerId", seekerId);
        } else {
            seekerId = seekerIdObj;
        }
        
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        
        ApplicationDAO appDAO = new ApplicationDAO();
        
        // Check if already applied
        if (appDAO.hasAlreadyApplied(jobId, seekerId)) {
            response.sendRedirect("jobseeker/job-details.jsp?jobId=" + jobId + "&error=alreadyApplied");
            return;
        }
        
        Application app = new Application();
        app.setJobId(jobId);
        app.setSeekerId(seekerId);
        app.setCoverLetter(request.getParameter("coverLetter"));
        
        // Check resume option
        String resumeOption = request.getParameter("resumeOption");
        
        if ("profile".equals(resumeOption)) {
            // Use resume from profile
            JobSeekerDAO seekDAO = new JobSeekerDAO();
            JobSeeker seeker = seekDAO.getJobSeekerById(seekerId);
            
            if (seeker != null && seeker.hasResume()) {
                app.setResumeFile(seeker.getResumeFile());
                app.setUseProfileResume(true);
            }
        } else if ("upload".equals(resumeOption)) {
            // Upload new resume for this application
            Part filePart = request.getPart("resumeFile");
            if (filePart != null && filePart.getSize() > 0) {
                long fileSize = filePart.getSize();
                
                if (fileSize > 5 * 1024 * 1024) {
                    request.setAttribute("error", "File too large. Maximum 5MB allowed.");
                    request.getRequestDispatcher("jobseeker/apply-job.jsp?jobId=" + jobId).forward(request, response);
                    return;
                }
                
                byte[] fileBytes = new byte[(int) fileSize];
                try (InputStream is = filePart.getInputStream()) {
                    is.read(fileBytes);
                }
                app.setResumeFile(fileBytes);
                app.setUseProfileResume(false);
            }
        }
        
        if (appDAO.applyForJob(app)) {
            response.sendRedirect("jobseeker/my-applications.jsp?msg=applied");
        } else {
            request.setAttribute("error", "Application failed. Please try again.");
            request.getRequestDispatcher("jobseeker/apply-job.jsp?jobId=" + jobId).forward(request, response);
        }
    }
}