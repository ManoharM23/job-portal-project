<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.*, com.jobportal.dao.*, java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"recruiter".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    int jobId = Integer.parseInt(request.getParameter("jobId"));
    JobDAO jobDAO = new JobDAO();
    ApplicationDAO appDAO = new ApplicationDAO();
    
    Job job = jobDAO.getJobById(jobId);
    List<Application> apps = appDAO.getApplicationsByJobId(jobId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Job Details - <%= job.getTitle() %></title>
   
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/recruiter-luxury.css">
</head>
<body>
    <div class="dashboard">
        
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="manage-jobs.jsp"/>
        </jsp:include>
        
        <main class="main-content">
            <div class="container-fluid" style="max-width: 1000px;">
                
                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
                    <h1 class="page-title" style="margin-bottom: 0;">Job <span>Details</span></h1>
                    <a href="manage-jobs.jsp" class="btn-dark" style="padding: 10px 20px; font-size: 0.9rem;">&#8592; Back to Jobs</a>
                </div>
                
                <!-- Job Info Card -->
                <div class="glass-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 1rem;">
                        <h2 style="color: #fff; font-size: 1.8rem; margin: 0;"><%= job.getTitle() %></h2>
                        <span class="status-badge <%= "active".equals(job.getStatus()) ? "status-active" : "status-closed" %>">
                            <%= job.getStatus() %>
                        </span>
                    </div>
                    
                    <!-- Meta Tags -->
                    <div style="display: flex; gap: 0.8rem; margin-bottom: 2.5rem; flex-wrap: wrap;">
                        <span style="background: rgba(255,255,255,0.05); padding: 6px 14px; border-radius: 6px; font-size: 0.85rem; border: 1px solid rgba(255,255,255,0.1); color: #ccc;">&#128205; <%= job.getLocation() != null ? job.getLocation() : "Remote" %></span>
                        <span style="background: rgba(46, 204, 113, 0.05); padding: 6px 14px; border-radius: 6px; font-size: 0.85rem; border: 1px solid rgba(46, 204, 113, 0.3); color: #2ecc71;">&#128176; $<%= (int)job.getSalaryMin() %> - $<%= (int)job.getSalaryMax() %></span>
                        <span style="background: rgba(212,175,55,0.1); padding: 6px 14px; border-radius: 6px; font-size: 0.85rem; border: 1px solid rgba(212,175,55,0.3); color: var(--gold-primary); text-transform: uppercase; font-weight: 600;">&#128188; <%= job.getJobType() %></span>
                        <span style="background: rgba(255,255,255,0.05); padding: 6px 14px; border-radius: 6px; font-size: 0.85rem; border: 1px solid rgba(255,255,255,0.1); color: #ccc;">&#128197; Posted: <%= job.getPostedDate() != null ? job.getPostedDate().toString().substring(0, 10) : "N/A" %></span>
                        <span style="background: rgba(231, 76, 60, 0.05); padding: 6px 14px; border-radius: 6px; font-size: 0.85rem; border: 1px solid rgba(231, 76, 60, 0.3); color: #e74c3c;">&#9200; Deadline: <%= job.getDeadline() != null ? job.getDeadline() : "N/A" %></span>
                    </div>
                    
                    <div style="color: #ccc; line-height: 1.8; margin-bottom: 2.5rem; font-size: 1rem;">
                        <%= job.getDescription().replace("\n", "<br>") %>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; background: rgba(0,0,0,0.3); padding: 1.5rem; border-radius: 12px; border: 1px solid rgba(255,255,255,0.05);">
                        <div>
                            <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem; font-weight: 700;">Skills Required</label>
                            <div style="color: #fff; font-size: 0.95rem; line-height: 1.5;"><%= job.getSkillsRequired() != null && !job.getSkillsRequired().isEmpty() ? job.getSkillsRequired() : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                        </div>
                        <div>
                            <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem; font-weight: 700;">Requirements</label>
                            <div style="color: #fff; font-size: 0.95rem; line-height: 1.5;"><%= job.getRequirements() != null && !job.getRequirements().isEmpty() ? job.getRequirements() : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                        </div>
                        <div style="grid-column: 1 / -1;">
                            <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem; font-weight: 700;">Education Required</label>
                            <div style="color: #fff; font-size: 0.95rem; line-height: 1.5;"><%= job.getEducation() != null && !job.getEducation().isEmpty() ? job.getEducation() : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                        </div>
                    </div>
                </div>
                
                <!-- Applications Card -->
                <div class="glass-card" style="margin-top: 2rem;">
                    <h3 style="color: var(--gold-primary); margin-bottom: 1.5rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 0.5rem;">
                        &#128203; Applications (<%= apps.size() %>)
                    </h3>
                    
                    <% if(apps.isEmpty()) { %>
                        <div style="text-align: center; padding: 2rem;">
                            <p style="color: var(--text-muted); margin: 0;">No candidates have applied for this position yet.</p>
                        </div>
                    <% } else { %>
                        <div style="display: grid; gap: 1rem;">
                            <% for(Application a : apps) { %>
                                <div style="background: rgba(0,0,0,0.4); border: 1px solid rgba(255,255,255,0.05); border-radius: 12px; padding: 1.5rem; display: flex; flex-direction: column; gap: 1rem;">
                                    
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <div style="display: flex; align-items: center; gap: 1rem;">
                                            <div style="width: 45px; height: 45px; border-radius: 50%; background: var(--gold-metallic); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; font-weight: 800; color: #000;">
                                                <%= a.getSeekerName() != null ? a.getSeekerName().charAt(0) : '?' %>
                                            </div>
                                            <div>
                                                <h4 style="color: #fff; margin: 0 0 0.2rem 0; font-size: 1.1rem;"><%= a.getSeekerName() != null ? a.getSeekerName() : "Unknown Candidate" %></h4>
                                                <p style="color: var(--text-muted); font-size: 0.8rem; margin: 0;">Applied: <%= a.getAppliedDate() != null ? a.getAppliedDate().toString().substring(0, 10) : "N/A" %></p>
                                            </div>
                                        </div>
                                        <span class="status-badge status-<%= a.getStatus() != null ? a.getStatus() : "pending" %>">
                                            <%= a.getStatus() != null ? a.getStatus() : "pending" %>
                                        </span>
                                    </div>

                                    <% if(a.getCoverLetter() != null && !a.getCoverLetter().trim().isEmpty()) { %>
                                        <div style="background: rgba(212,175,55,0.05); border-left: 2px solid var(--gold-primary); padding: 0.8rem 1rem; border-radius: 0 6px 6px 0;">
                                            <p style="color: #ccc; font-size: 0.9rem; font-style: italic; margin: 0; line-height: 1.5;">"<%= a.getCoverLetter() %>"</p>
                                        </div>
                                    <% } %>
                                    
                                    <div style="display: flex; justify-content: flex-end;">
                                        <% if(a.getResumeFile() != null) { %>
                                            <a href="../download-resume?appId=<%= a.getApplicationId() %>" class="btn-dark" style="padding: 8px 16px; font-size: 0.85rem;">&#128196; Download Resume</a>
                                        <% } else { %>
                                            <span style="color: var(--text-muted); font-size: 0.85rem; font-style: italic;">No Resume Attached</span>
                                        <% } %>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>

            </div>
        </main>
    </div>
</body>
</html>