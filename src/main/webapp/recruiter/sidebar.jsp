<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    String activePage = request.getParameter("activePage");
%>

<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Inter:wght@400;500&display=swap" rel="stylesheet">

<style>
    .sidebar-header {
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        padding: 2.5rem 1rem 1.5rem;
        border-bottom: 1px solid rgba(212, 175, 55, 0.15);
        margin-bottom: 1.5rem;
    }
    .sidebar-header h3 {
        font-family: 'Playfair Display', serif;
        font-size: 1.2rem;
        letter-spacing: 3px;
        margin-bottom: 0.5rem;
        color: var(--gold-primary, #cca852);
        text-transform: uppercase;
    }
    .sidebar-header p {
        font-family: 'Inter', sans-serif;
        font-weight: 500;
        color: #e0e0e0;
        font-size: 0.95rem;
    }
    .sidebar-menu a {
        font-family: 'Playfair Display', serif;
        font-weight: 600;
        letter-spacing: 0.5px;
        font-size: 1.05rem; 
        padding: 1.2rem 1.5rem;
        transition: all 0.3s ease;
    }
   
    .sidebar-dp-link {
        text-decoration: none;
        display: block;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        border-radius: 50%;
        margin-bottom: 1.2rem;
    }
    .sidebar-dp-link:hover {
        transform: scale(1.05);
        box-shadow: 0 0 25px rgba(212,175,55,0.4);
    }
</style>

<aside class="sidebar">
    <div class="sidebar-header">
        
        <a href="edit-profile.jsp" class="sidebar-dp-link" title="Edit Profile">
            <div style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; background: var(--gold-metallic, #cca852); display: flex; align-items: center; justify-content: center; font-size: 2.2rem; font-weight: 800; color: #000; border: 2px solid var(--gold-primary, #cca852); box-shadow: 0 0 20px rgba(212,175,55,0.25);">
                <% if (sessionUser.getProfilePicture() != null) { %>
                    <img src="<%= request.getContextPath() %>/display-avatar?userId=<%= sessionUser.getUserId() %>&t=<%= System.currentTimeMillis() %>" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                <% } else { %>
                    <%= sessionUser.getFullName().charAt(0) %>
                <% } %>
            </div>
        </a>
        
        <h3>RECRUITER</h3>
        <p><%= sessionUser.getFullName() %></p>
    </div>
    
    <ul class="sidebar-menu">
        <li><a href="dashboard.jsp" class="<%= "dashboard.jsp".equals(activePage) ? "active" : "" %>">&#128200; Dashboard</a></li>
        <li><a href="post-job.jsp" class="<%= "post-job.jsp".equals(activePage) ? "active" : "" %>">&#10133; Post a Job</a></li>
        <li><a href="manage-jobs.jsp" class="<%= "manage-jobs.jsp".equals(activePage) ? "active" : "" %>">&#128188; Manage Jobs</a></li>
        <li><a href="view-applications.jsp" class="<%= "view-applications.jsp".equals(activePage) ? "active" : "" %>">&#128203; Applications</a></li>
        <li><a href="edit-profile.jsp" class="<%= "edit-profile.jsp".equals(activePage) ? "active" : "" %>">&#128100; Profile</a></li>
        
       
      <li><a href="../changePassword.jsp" class="<%= "changePassword.jsp".equals(activePage) ? "active" : "" %>">&#128274; Change Password</a></li>
        
        <li><a href="../logout">&#128682; Logout</a></li>
    </ul>
</aside>