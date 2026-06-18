<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.*, com.jobportal.dao.*, java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"jobseeker".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int seekerId = (session.getAttribute("seekerId") != null) ? (Integer) session.getAttribute("seekerId") : -1;
    
    ApplicationDAO appDAO = new ApplicationDAO();
    List<Application> apps = appDAO.getApplicationsBySeeker(seekerId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Applications</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/jobseeker-luxury.css">
</head>
<body>
    <div class="dashboard">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="my-applications.jsp"/>
        </jsp:include>
        
        <main class="main-content">
            <div class="container-fluid">
                <h1 class="page-title">Application <span>History</span></h1>
                
                <div class="glass-card" style="padding: 0; overflow: hidden;">
                    <table class="data-table">
                        <thead style="background: rgba(0,0,0,0.4);">
                            <tr>
                                <th>Job Title</th>
                                <th>Company</th>
                                <th>Applied Date</th>
                                <th>Status</th>
                                <th>Resume Sent</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Application a : apps) { %>
                            <tr>
                                <td><strong style="color:#fff;"><%= a.getJobTitle() %></strong></td>
                                <td><%= a.getCompanyName() %></td>
                                <td><%= a.getAppliedDate() != null ? a.getAppliedDate().toString().substring(0, 10) : "" %></td>
                                <td><span class="status-badge status-<%= a.getStatus() %>"><%= a.getStatus() %></span></td>
                                <td>
                                   <% if(a.getResumeFile() != null) { %>
                                   <a href="../download-resume?appId=<%= a.getApplicationId() %>" class="btn-dark" style="padding:4px 12px; font-size: 0.8rem;">
                                    &#128196; Download</a>
                                    <% } else { %>
                                    <span style="color:var(--text-muted); font-size: 0.85rem; font-style: italic;">No resume</span>
                                     <% } %>
                                </td>
                            </tr>
                            <% } %>
                            <% if(apps.isEmpty()) { %>
                            <tr><td colspan="5" style="text-align:center; padding: 3rem; color: var(--text-muted);">You haven't applied to any jobs yet. Browse jobs to get started!</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>