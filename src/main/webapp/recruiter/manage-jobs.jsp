<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.*, com.jobportal.dao.*, java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"recruiter".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int recruiterId = (session.getAttribute("recruiterId") != null) ? 
        (Integer) session.getAttribute("recruiterId") : -1;

    JobDAO jobDAO = new JobDAO();
    List<Job> jobs = jobDAO.getJobsByRecruiter(recruiterId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Jobs - Recruiter</title>
    <link rel="stylesheet" href="../css/recruiter-luxury.css">
</head>
<body>
    <div class="dashboard">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="manage-jobs.jsp"/>
        </jsp:include>

        <main class="main-content">
            <div class="container-fluid">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <h1 class="page-title" style="margin-bottom: 0;">My <span>Job Postings</span></h1>
                    <a href="post-job.jsp" class="btn-gold">&#10133; Post New Job</a>
                </div>

                <div class="glass-card" style="padding: 0; overflow: hidden;">
                    <table class="data-table">
                        <thead style="background: rgba(0,0,0,0.4);">
                            <tr>
                                <th>Title</th>
                                <th>Type</th>
                                <th>Location</th>
                                <th>Posted</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Job j : jobs) { %>
                            <tr>
                                <td><strong style="color:#fff;"><%= j.getTitle() %></strong></td>
                                <td><span style="background: rgba(212,175,55,0.1); color: var(--gold-primary); padding: 4px 8px; border-radius: 4px; font-size: 0.8rem;"><%= j.getJobType() %></span></td>
                                <td><%= j.getLocation() != null ? j.getLocation() : "Remote" %></td>
                                <td><%= j.getPostedDate() %></td>
                                <td>
                                    <span class="status-badge <%= "active".equals(j.getStatus()) ? "status-active" : "status-closed" %>">
                                        <%= j.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <a href="view-job.jsp?jobId=<%= j.getJobId() %>" class="btn-dark" style="padding: 6px 12px; font-size: 0.8rem;">View</a>
                                    <a href="../delete-job?jobId=<%= j.getJobId() %>" class="btn-dark" style="padding: 6px 12px; font-size: 0.8rem; border-color: rgba(231, 76, 60, 0.4); color: #e74c3c;" onclick="return confirm('Delete this job?')">Delete</a>
                                </td>
                            </tr>
                            <% } %>
                            <% if(jobs.isEmpty()) { %>
                            <tr>
                                <td colspan="6" style="text-align:center; padding:3rem; color:var(--text-muted);">
                                    <div style="font-size:3rem; margin-bottom:1rem;">&#128188;</div>
                                    <p>No jobs posted yet.</p>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>