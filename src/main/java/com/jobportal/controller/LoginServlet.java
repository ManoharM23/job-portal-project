package com.jobportal.controller;

import java.io.IOException;

import com.jobportal.dao.JobSeekerDAO;
import com.jobportal.dao.RecruiterDAO;
import com.jobportal.dao.UserDAO;
import com.jobportal.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    String email = request.getParameter("email");
	    String password = request.getParameter("password");
	    
	    UserDAO userDAO = new UserDAO();
	    User user = userDAO.validateUser(email, password);
	    
	    if (user != null) {
	        HttpSession session = request.getSession();
	        session.setAttribute("user", user);
	        session.setAttribute("role", user.getRole());
	        session.setAttribute("userId", user.getUserId());
	        
	        // ADD THIS BLOCK:
	        if ("recruiter".equals(user.getRole())) {
	            RecruiterDAO recDAO = new RecruiterDAO();
	            int recruiterId = recDAO.getRecruiterIdByUserId(user.getUserId());
	            session.setAttribute("recruiterId", recruiterId);
	            response.sendRedirect("recruiter/dashboard.jsp");
	            
	        } else {
	            JobSeekerDAO seekDAO = new JobSeekerDAO();
	            int seekerId = seekDAO.getSeekerIdByUserId(user.getUserId());
	            session.setAttribute("seekerId", seekerId);
	            response.sendRedirect("jobseeker/dashboard.jsp");
	        }
	        
	    } else {
	        request.setAttribute("error", "Invalid email or password");
	        request.getRequestDispatcher("login.jsp").forward(request, response);
	    }
	}
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}