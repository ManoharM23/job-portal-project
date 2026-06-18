<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.*, com.jobportal.dao.*"%>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"jobseeker".equals(user.getRole())) {
	response.sendRedirect("../login.jsp");
	return;
}

String jobIdStr = request.getParameter("jobId");
if (jobIdStr == null || jobIdStr.isEmpty()) {
	response.sendRedirect("browse-jobs.jsp");
	return;
}

int jobId = Integer.parseInt(jobIdStr);
int seekerId = (session.getAttribute("seekerId") != null) ? (Integer) session.getAttribute("seekerId") : -1;

JobDAO jobDAO = new JobDAO();
Job job = jobDAO.getJobById(jobId);

if (job == null) {
	response.sendRedirect("browse-jobs.jsp");
	return;
}

ApplicationDAO appDAO = new ApplicationDAO();
boolean alreadyApplied = appDAO.hasAlreadyApplied(jobId, seekerId);
String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=job.getTitle()%></title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/jobseeker-luxury.css">
</head>
<body>
	<div class="dashboard">
		<jsp:include page="sidebar.jsp">
			<jsp:param name="activePage" value="browse-jobs.jsp" />
		</jsp:include>

		<main class="main-content">
			<div class="container-fluid" style="max-width: 900px;">
				<div style="margin-bottom: 2rem;">
					<a href="browse-jobs.jsp" class="btn-dark"
						style="padding: 8px 16px; font-size: 0.85rem;">&#8592; Back to
						Jobs</a>
				</div>

				<div class="glass-card">
					<h1 style="font-size: 2.2rem; color: #fff; margin-bottom: 0.5rem;"><%=job.getTitle()%></h1>
					<h3
						style="color: var(--gold-primary); margin-bottom: 1.5rem; font-weight: 600;">
						&#127970;
						<%=job.getCompanyName()%></h3>

					<div class="job-meta-tags" style="margin-bottom: 2rem;">
						<span><%=job.getJobType()%></span> <span>&#128205; <%=job.getLocation() != null ? job.getLocation() : "Remote"%></span>
						<span
							style="color: #2ecc71; border-color: rgba(46, 204, 113, 0.3); background: rgba(46, 204, 113, 0.05);">$<%=(int) job.getSalaryMin()%>
							- $<%=(int) job.getSalaryMax()%></span>
					</div>

					<hr
						style="margin: 2rem 0; border: none; border-top: 1px solid rgba(255, 255, 255, 0.1);">

					<h3
						style="color: var(--gold-primary); margin-bottom: 1rem; text-transform: uppercase; font-size: 0.9rem; letter-spacing: 1px;">Description</h3>
					<p style="line-height: 1.8; color: #ccc; margin-bottom: 2rem;"><%=job.getDescription().replace("\n", "<br>")%></p>

					<%
					if (job.getRequirements() != null && !job.getRequirements().isEmpty()) {
					%>
					<h3
						style="color: var(--gold-primary); margin-bottom: 1rem; text-transform: uppercase; font-size: 0.9rem; letter-spacing: 1px;">Requirements</h3>
					<p style="line-height: 1.8; color: #ccc; margin-bottom: 2rem;"><%=job.getRequirements().replace("\n", "<br>")%></p>
					<%
					}
					%>

					<%
					if (job.getSkillsRequired() != null && !job.getSkillsRequired().isEmpty()) {
					%>
					<h3
						style="color: var(--gold-primary); margin-bottom: 1rem; text-transform: uppercase; font-size: 0.9rem; letter-spacing: 1px;">Skills
						Required</h3>
					<div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
						<%
						for (String skill : job.getSkillsRequired().split(",")) {
						%>
						<span
							style="background: rgba(255, 255, 255, 0.05); padding: 6px 14px; border-radius: 20px; font-size: 0.85rem; border: 1px solid rgba(255, 255, 255, 0.1);"><%=skill.trim()%></span>
						<%
						}
						%>
					</div>

					<%
					if (job.getEducation() != null && !job.getEducation().isEmpty()) {
					%>
					<h3
						style="color: var(--gold-primary); margin-bottom: 1rem; margin-top: 2rem; text-transform: uppercase; font-size: 0.9rem; letter-spacing: 1px;">Education
						Required</h3>
					<p style="color: #ccc; margin-bottom: 2rem;"><%=job.getEducation()%></p>
					<%
					}
					%>
					<%
					}
					%>

					<hr
						style="margin: 2rem 0; border: none; border-top: 1px solid rgba(255, 255, 255, 0.1);">

					<%
					if ("alreadyApplied".equals(error)) {
					%>
					<div class="alert alert-error">You have already applied for
						this job.</div>
					<%
					}
					%>

					<div style="margin-top: 2rem;">
						<%
						if (alreadyApplied) {
						%>
						<button class="btn-dark" disabled
							style="opacity: 0.6; cursor: not-allowed; width: 100%;">
							&#10003; Application Submitted</button>
						<%
						} else {
						%>
						<a href="apply-job.jsp?jobId=<%=job.getJobId()%>" class="btn-gold"
							style="width: 100%; padding: 16px;">Apply for this Position</a>
						<%
						}
						%>
					</div>
				</div>
			</div>
		</main>
	</div>
</body>
</html>