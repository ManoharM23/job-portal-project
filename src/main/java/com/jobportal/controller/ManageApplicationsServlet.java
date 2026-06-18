package com.jobportal.controller;

import java.io.IOException;

import com.jobportal.dao.ApplicationDAO;
import com.jobportal.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/update-application")
public class ManageApplicationsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"recruiter".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        Integer recruiterId = (Integer) request.getSession().getAttribute("recruiterId");
        if (recruiterId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int appId = Integer.parseInt(request.getParameter("appId"));
        String status = request.getParameter("status");

        ApplicationDAO appDAO = new ApplicationDAO();
        
        boolean updated = appDAO.updateApplicationStatus(appId, status, recruiterId);

        if (updated) {
            response.sendRedirect("recruiter/view-applications.jsp?msg=updated");
        } else {
            response.sendRedirect("recruiter/view-applications.jsp?error=notallowed");
        }
    }
}