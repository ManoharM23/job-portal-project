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

    ApplicationDAO appDAO = new ApplicationDAO();
    List<Application> apps = appDAO.getApplicationsByRecruiter(recruiterId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Candidate Pipeline - Recruiter</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/recruiter-luxury.css">
    <style>
     
        .premium-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23d4af37' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
        }
        .premium-select option {
            background: #111;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="view-applications.jsp"/>
        </jsp:include>

        <main class="main-content">
            <div class="container-fluid">
                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 2rem;">
                    <h1 class="page-title" style="margin-bottom: 0;">Candidate <span>Pipeline</span></h1>
                    <div style="color: var(--text-muted); font-size: 0.9rem; letter-spacing: 1px; text-transform: uppercase;">
                        Total Applicants: <strong style="color: var(--gold-primary);"><%= apps.size() %></strong>
                    </div>
                </div>

                <% if(apps.isEmpty()) { %>
                    <div class="glass-card" style="text-align: center; padding: 5rem 2rem;">
                        <div style="font-size: 4rem; margin-bottom: 1rem;">&#128203;</div>
                        <h3 style="color: #fff; margin-bottom: 0.5rem; font-size: 1.5rem;">Your Pipeline is Empty</h3>
                        <p style="color: var(--text-muted);">Applications will appear here once candidates start applying to your job postings.</p>
                    </div>
                <% } else { %>
                   
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 1.5rem;">
                        
                        <% for(Application a : apps) { 
                            // Safely extract cover letter snippet
                            String cover = a.getCoverLetter();
                            String coverSnippet = (cover != null && !cover.trim().isEmpty()) ? 
                                (cover.length() > 90 ? cover.substring(0, 90) + "..." : cover) : null;
                        %>
                            <div class="glass-card" style="padding: 2rem; display: flex; flex-direction: column; position: relative; overflow: hidden;">
                                
                                <!-- Top Accent Line based on Status -->
                                <% if("hired".equals(a.getStatus())) { %>
                                    <div style="position: absolute; top: 0; left: 0; width: 100%; height: 4px; background: #2ecc71;"></div>
                                <% } else if ("rejected".equals(a.getStatus())) { %>
                                    <div style="position: absolute; top: 0; left: 0; width: 100%; height: 4px; background: #e74c3c;"></div>
                                <% } else { %>
                                    <div style="position: absolute; top: 0; left: 0; width: 100%; height: 4px; background: var(--gold-metallic);"></div>
                                <% } %>

                                <!-- Header: Avatar & Name -->
                                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.5rem;">
                                    <div style="display: flex; align-items: center; gap: 1rem;">
                                        <div style="width: 55px; height: 55px; border-radius: 50%; background: var(--gold-metallic); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; font-weight: 800; color: #000; box-shadow: 0 0 15px rgba(212,175,55,0.3);">
                                            <%= a.getSeekerName() != null ? a.getSeekerName().charAt(0) : '?' %>
                                        </div>
                                        <div>
                                            <h3 style="color: #fff; font-size: 1.25rem; margin-bottom: 0.2rem;"><%= a.getSeekerName() != null ? a.getSeekerName() : "Unknown Candidate" %></h3>
                                            <p style="color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px;">&#128197; <%= a.getAppliedDate() != null ? a.getAppliedDate().toString().substring(0, 10) : "N/A" %></p>
                                        </div>
                                    </div>
                                    <span class="status-badge status-<%= a.getStatus() != null ? a.getStatus() : "pending" %>">
                                        <%= a.getStatus() != null ? a.getStatus() : "pending" %>
                                    </span>
                                </div>

                                <!-- Body: Role & Cover Letter -->
                                <div style="flex-grow: 1; margin-bottom: 2rem;">
                                    <div style="display: inline-block; background: rgba(212,175,55,0.05); color: var(--gold-light); padding: 6px 12px; border-radius: 6px; font-size: 0.85rem; border: 1px solid rgba(212,175,55,0.2); margin-bottom: 1rem; font-weight: 600;">
                                        Target Role: <span style="color: #fff;"><%= a.getJobTitle() %></span>
                                    </div>

                                    <% if(coverSnippet != null) { %>
                                        <div style="background: rgba(0,0,0,0.3); border-left: 3px solid var(--gold-primary); padding: 1rem; border-radius: 0 8px 8px 0;">
                                            <div style="font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem; font-weight: 700;">Cover Letter Snippet</div>
                                            <p style="color: #ccc; font-size: 0.95rem; line-height: 1.6; font-style: italic; margin: 0;">
                                                "<%= coverSnippet %>"
                                            </p>
                                        </div>
                                    <% } else { %>
                                        <div style="background: rgba(0,0,0,0.3); border-left: 3px solid #333; padding: 1rem; border-radius: 0 8px 8px 0;">
                                            <p style="color: #666; font-size: 0.9rem; font-style: italic; margin: 0;">Candidate applied without a cover letter message.</p>
                                        </div>
                                    <% } %>
                                </div>

                                <!-- Footer: Actions -->
                                <div style="display: flex; gap: 1rem; align-items: center; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 1.5rem;">
                                    
                                    <% if(a.getResumeFile() != null) { %>
                                        <a href="../download-resume?appId=<%= a.getApplicationId() %>" class="btn-dark" style="flex: 1; padding: 12px; font-size: 0.9rem; border-radius: 8px;">
                                            &#128196; Resume
                                        </a>
                                    <% } else { %>
                                        <button class="btn-dark" disabled style="flex: 1; padding: 12px; font-size: 0.9rem; border-radius: 8px; opacity: 0.4; cursor: not-allowed;">
                                            No Resume
                                        </button>
                                    <% } %>

                                    <% if(!"hired".equals(a.getStatus()) && !"rejected".equals(a.getStatus())) { %>
                                        <form action="../update-application" method="post" style="margin: 0; flex: 1.5;">
                                            <input type="hidden" name="appId" value="<%= a.getApplicationId() %>">
                                            <select name="status" onchange="this.form.submit()" class="premium-select" style="width: 100%; padding: 12px; background: rgba(212,175,55,0.1); border: 1px solid var(--gold-primary); border-radius: 8px; color: var(--gold-primary); font-weight: 700; cursor: pointer; text-transform: uppercase; font-size: 0.85rem; letter-spacing: 1px; transition: all 0.3s;">
                                                <option value="pending" <%= "pending".equals(a.getStatus()) ? "selected" : "" %>>Update Status</option>
                                                <option value="reviewed" <%= "reviewed".equals(a.getStatus()) ? "selected" : "" %>>Mark Reviewed</option>
                                                <option value="shortlisted" <%= "shortlisted".equals(a.getStatus()) ? "selected" : "" %>>Shortlist</option>
                                                <option value="rejected">Reject</option>
                                                <option value="hired">Hire Candidate</option>
                                            </select>
                                        </form>
                                    <% } else { %>
                                        <div style="flex: 1.5; text-align: center; color: var(--text-muted); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 600; padding: 12px; background: rgba(0,0,0,0.5); border-radius: 8px; border: 1px solid rgba(255,255,255,0.05);">
                                            Pipeline Closed
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>