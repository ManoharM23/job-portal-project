package com.jobportal.controller;

import com.jobportal.dao.UserDAO;
import com.jobportal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/display-avatar")
public class DisplayAvatarServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId"));
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(userId);
        
        if (user != null && user.getProfilePicture() != null) {
            response.setContentType("image/jpeg");
            try (OutputStream out = response.getOutputStream()) {
                out.write(user.getProfilePicture());
                out.flush();
            }
        } else {
            // Send a 404 if no image exists so the frontend can handle the fallback
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}