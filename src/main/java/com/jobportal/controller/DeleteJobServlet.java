package com.jobportal.controller;

import com.jobportal.dao.JobDAO;
import com.jobportal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/delete-job")
public class DeleteJobServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"recruiter".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int recruiterId = (Integer) request.getSession().getAttribute("recruiterId");
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        
        JobDAO jobDAO = new JobDAO();
        if (jobDAO.deleteJob(jobId, recruiterId)) {
            response.sendRedirect("recruiter/manage-jobs.jsp");
        } else {
            response.sendRedirect("recruiter/manage-jobs.jsp?error=deletefailed");
        }
    }
}