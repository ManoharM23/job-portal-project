package com.jobportal.controller;

import com.jobportal.dao.UserDAO;
import com.jobportal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/upload-avatar")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB Limit
public class UploadAvatarServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) return;
        
        Part filePart = request.getPart("avatarFile");
        if (filePart != null && filePart.getSize() > 0) {
            byte[] fileBytes = new byte[(int) filePart.getSize()];
            try (InputStream is = filePart.getInputStream()) {
                is.read(fileBytes);
            }
            
            UserDAO userDAO = new UserDAO();
            userDAO.updateProfilePicture(user.getUserId(), fileBytes);
            
            // Update session user object
            user.setProfilePicture(fileBytes);
            request.getSession().setAttribute("user", user);
        }
        
        // Redirect back to respective profile page
        if ("recruiter".equals(user.getRole())) {
            response.sendRedirect("recruiter/edit-profile.jsp?msg=dpUpdated");
        } else {
            response.sendRedirect("jobseeker/edit-profile.jsp?msg=dpUpdated");
        }
    }
}