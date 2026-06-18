package com.jobportal.controller;

import com.jobportal.dao.JobSeekerDAO;
import com.jobportal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/upload-resume")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class UploadResumeServlet extends HttpServlet {
    
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
        
        String action = request.getParameter("action");
        JobSeekerDAO seekDAO = new JobSeekerDAO();
        
        if ("delete".equals(action)) {
            // Delete resume
            seekDAO.deleteResume(seekerId);
            response.sendRedirect("jobseeker/edit-profile.jsp?msg=resumeDeleted");
            return;
        }
        
        // Upload new resume
        Part filePart = request.getPart("resumeFile");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("jobseeker/edit-profile.jsp?error=noFile");
            return;
        }
        
        long fileSize = filePart.getSize();
        if (fileSize > 5 * 1024 * 1024) {
            response.sendRedirect("jobseeker/edit-profile.jsp?error=fileTooLarge");
            return;
        }
        
        String fileName = getSubmittedFileName(filePart);
        
        // Read file into byte array
        byte[] fileBytes = new byte[(int) fileSize];
        try (InputStream is = filePart.getInputStream()) {
            is.read(fileBytes);
        }
        
        if (seekDAO.updateResume(seekerId, fileBytes, fileName)) {
            response.sendRedirect("jobseeker/edit-profile.jsp?msg=resumeUploaded");
        } else {
            response.sendRedirect("jobseeker/edit-profile.jsp?error=uploadFailed");
        }
    }
    
    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 2, token.length() - 1);
            }
        }
        return null;
    }
}