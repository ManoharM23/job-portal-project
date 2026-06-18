<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.User, com.jobportal.dao.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"jobseeker".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int seekerId = (session.getAttribute("seekerId") != null) ? 
        (Integer) session.getAttribute("seekerId") : -1;
    
    ApplicationDAO appDAO = new ApplicationDAO();
    int myApps = appDAO.getApplicationsBySeeker(seekerId).size();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Luxury Dashboard - Job Seeker</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/jobseeker-luxury.css">
</head>
<body>
    <div class="dashboard">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="dashboard.jsp"/>
        </jsp:include>
        
        <main class="main-content">
            <div class="container-fluid">
                <h1 class="page-title">Welcome, <span><%= user.getFullName() %></span></h1>
                
                <div class="glass-card" style="margin-bottom: 2.5rem;">
                    <h3 style="color: #fff; font-size: 1.5rem; margin-bottom: 0.5rem;">Ready to find your dream job?</h3>
                    <p style="color: var(--text-muted);">Track your applications and discover new opportunities matched to your skills.</p>
                </div>
                
                <div class="job-grid">
                    <div class="glass-card" style="text-align:center; display: flex; flex-direction: column; justify-content: center;">
                        <h3 style="color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; font-size: 0.9rem;">Applications Sent</h3>
                        <p style="font-size:3.5rem; color:#fff; font-weight:800; margin: 1rem 0;"><%= myApps %></p>
                        <a href="my-applications.jsp" class="btn-dark">View Status</a>
                    </div>
                    <div class="glass-card" style="text-align:center; display: flex; flex-direction: column; justify-content: center;">
                        <h3 style="color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; font-size: 0.9rem;">Find Jobs</h3>
                        <p style="font-size:3.5rem; color:#fff; font-weight:800; margin: 1rem 0;">&#128269;</p>
                        <a href="browse-jobs.jsp" class="btn-gold">Browse Now</a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>