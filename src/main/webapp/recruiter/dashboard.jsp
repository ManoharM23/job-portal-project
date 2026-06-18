<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.*, com.jobportal.dao.*, java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"recruiter".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    Integer recruiterIdObj = (Integer) session.getAttribute("recruiterId");
    int recruiterId = (recruiterIdObj != null) ? recruiterIdObj : -1;
    if (recruiterId == -1) {
        RecruiterDAO recDAO = new RecruiterDAO();
        recruiterId = recDAO.getRecruiterIdByUserId(user.getUserId());
        session.setAttribute("recruiterId", recruiterId);
    }

    JobDAO jobDAO = new JobDAO();
    ApplicationDAO appDAO = new ApplicationDAO();

    List<Job> myJobs = jobDAO.getJobsByRecruiter(recruiterId);
    List<Application> allApps = appDAO.getApplicationsByRecruiter(recruiterId);

    int totalJobs = myJobs.size();
    int totalApplications = allApps.size();
    int activeJobs = 0;
    for (Job j : myJobs) {
        if ("active".equals(j.getStatus())) activeJobs++;
    }

    List<Job> recentJobs = myJobs.size() > 5 ? myJobs.subList(0, 5) : myJobs;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Luxury Dashboard - Recruiter</title>
    <link rel="stylesheet" href="../css/recruiter-luxury.css">
</head>
<body>
    <div class="dashboard">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="dashboard.jsp"/>
        </jsp:include>

        <main class="main-content">
            <div class="container-fluid">
                <h1 class="page-title">Welcome, <span><%= user.getFullName() %></span></h1>

                <div class="stats-grid">
                    <div class="glass-card" style="text-align: center;">
                        <div style="font-size: 2.5rem; margin-bottom: 1rem;">&#128188;</div>
                        <div style="font-size: 2.5rem; font-weight: 800; color: #fff;"><%= totalJobs %></div>
                        <div style="color: var(--gold-primary); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">Total Jobs</div>
                    </div>
                    <div class="glass-card" style="text-align: center;">
                        <div style="font-size: 2.5rem; margin-bottom: 1rem;">&#9989;</div>
                        <div style="font-size: 2.5rem; font-weight: 800; color: #fff;"><%= activeJobs %></div>
                        <div style="color: var(--gold-primary); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">Active Postings</div>
                    </div>
                    <div class="glass-card" style="text-align: center;">
                        <div style="font-size: 2.5rem; margin-bottom: 1rem;">&#128203;</div>
                        <div style="font-size: 2.5rem; font-weight: 800; color: #fff;"><%= totalApplications %></div>
                        <div style="color: var(--gold-primary); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">Applications</div>
                    </div>
                </div>

                <div class="glass-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 1rem;">
                        <h3 style="font-size: 1.3rem; color: #fff;">Recent Jobs</h3>
                        <a href="post-job.jsp" class="btn-gold">&#10133; Post New Job</a>
                    </div>

                    <% if(!recentJobs.isEmpty()) { %>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Job Title</th>
                                    <th>Location</th>
                                    <th>Posted</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(Job job : recentJobs) { %>
                                    <tr>
                                        <td><strong style="color:#fff;"><%= job.getTitle() %></strong></td>
                                        <td><%= job.getLocation() != null ? job.getLocation() : "Remote" %></td>
                                        <td><%= job.getPostedDate() != null ? job.getPostedDate() : "N/A" %></td>
                                        <td>
                                            <span class="status-badge <%= "active".equals(job.getStatus()) ? "status-active" : "status-closed" %>">
                                                <%= job.getStatus() != null ? job.getStatus() : "Unknown" %>
                                            </span>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <div style="text-align: center; padding: 3rem;">
                            <p style="color: var(--text-muted);">No jobs posted yet. Start building your team.</p>
                            <a href="post-job.jsp" class="btn-gold" style="margin-top:1rem;">Post a Job</a>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>