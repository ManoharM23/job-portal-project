<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.jobportal.model.*, com.jobportal.dao.*, java.util.*"%>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"jobseeker".equals(user.getRole())) {
	response.sendRedirect("../login.jsp");
	return;
}

// Safely capture search parameters
String keyword = request.getParameter("keyword");
String locationStr = request.getParameter("location");
String jobType = request.getParameter("jobType");

// Prevent nulls from breaking the input values
String safeKeyword = (keyword != null) ? keyword : "";
String safeLocation = (locationStr != null) ? locationStr : "";
String safeJobType = (jobType != null) ? jobType : "all";

JobDAO jobDAO = new JobDAO();
List<Job> jobs;

// Fetch jobs based on parameters
if ((keyword != null && !keyword.trim().isEmpty()) || (locationStr != null && !locationStr.trim().isEmpty())
		|| (jobType != null && !jobType.equals("all"))) {
	jobs = jobDAO.searchJobs(keyword, locationStr, jobType);
} else {
	jobs = jobDAO.getAllActiveJobs();
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Browse Jobs - Premium</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/jobseeker-luxury.css">
</head>
<body>
	<div class="dashboard">
		<jsp:include page="sidebar.jsp">
			<jsp:param name="activePage" value="browse-jobs.jsp" />
		</jsp:include>

		<main class="main-content">
			<div class="container-fluid">
				<h1 class="page-title">
					Available <span>Opportunities</span>
				</h1>

				<!-- Search UI -->
				<div class="glass-card" style="margin-bottom: 2rem;">
					<form action="browse-jobs.jsp" method="get"
						style="display: flex; gap: 1.5rem; align-items: flex-end; flex-wrap: wrap;">

						<div class="form-group" style="flex: 2; margin-bottom: 0;">
							<label>Search Keyword</label> <input type="text" name="keyword"
								value="<%=safeKeyword%>"
								placeholder="Job title, skills, or company">
						</div>

						<div class="form-group" style="flex: 1; margin-bottom: 0;">
							<label>Location</label> <input type="text" name="location"
								value="<%=safeLocation%>" placeholder="City or Remote">
						</div>

						<div class="form-group" style="flex: 1; margin-bottom: 0;">
							<label>Job Type</label> <select name="jobType">
								<option value="all"
									<%="all".equals(safeJobType) ? "selected" : ""%>>All
									Types</option>
								<option value="full-time"
									<%="full-time".equals(safeJobType) ? "selected" : ""%>>Full
									Time</option>
								<option value="part-time"
									<%="part-time".equals(safeJobType) ? "selected" : ""%>>Part
									Time</option>
								<option value="contract"
									<%="contract".equals(safeJobType) ? "selected" : ""%>>Contract</option>
								<option value="internship"
									<%="internship".equals(safeJobType) ? "selected" : ""%>>Internship</option>
							</select>
						</div>

						<div style="margin-bottom: 0;">
							<button type="submit" class="btn-gold"
								style="padding: 14px 28px;">&#128269; Filter</button>
							<%
							if (!safeKeyword.isEmpty() || !safeLocation.isEmpty() || !safeJobType.equals("all")) {
							%>
							<a href="browse-jobs.jsp" class="btn-dark"
								style="margin-left: 0.5rem; padding: 14px;">Clear</a>
							<%
							}
							%>
						</div>
					</form>
				</div>

				<!-- Job Listings -->
				<div class="job-grid">
					<%
					for (Job job : jobs) {
						// Safe description handling
						String desc = job.getDescription();
						if (desc == null)
							desc = "No description provided.";
						String shortDesc = desc.length() > 120 ? desc.substring(0, 120) + "..." : desc;
						String compName = (job.getCompanyName() != null && !job.getCompanyName().isEmpty()) ? job.getCompanyName()
						: "Company";
					%>
					<div class="job-card">

						<!-- Header with Job Title & Small Company Profile -->
						<div
							style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem; gap: 1rem;">
							<h3 style="margin-bottom: 0; line-height: 1.3;"><%=job.getTitle()%></h3>

							<div
								style="display: flex; align-items: center; gap: 0.5rem; background: rgba(212, 175, 55, 0.05); padding: 4px 12px 4px 4px; border-radius: 20px; border: 1px solid rgba(212, 175, 55, 0.15); flex-shrink: 0;">
								<div
									style="width: 28px; height: 28px; border-radius: 50%; background: var(--gold-metallic); display: flex; align-items: center; justify-content: center; font-size: 0.85rem; font-weight: 800; color: #000; overflow: hidden;">
									<img
										src="<%=request.getContextPath()%>/display-avatar?userId=<%=job.getRecruiterUserId()%>"
										alt="Logo"
										style="width: 100%; height: 100%; object-fit: cover;"
										onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
									<span style="display: none;"><%=compName.charAt(0)%></span>
								</div>
								<span
									style="color: var(--gold-primary); font-weight: 600; font-size: 0.85rem; letter-spacing: 0.5px;"><%=compName%></span>
							</div>
						</div>

						<div class="job-meta-tags">
							<span><%=job.getJobType()%></span> <span>&#128205; <%=job.getLocation() != null ? job.getLocation() : "Remote"%></span>
							<span
								style="color: #2ecc71; border-color: rgba(46, 204, 113, 0.3); background: rgba(46, 204, 113, 0.05);">$<%=(int) job.getSalaryMin()%>
								- $<%=(int) job.getSalaryMax()%></span>
						</div>

						<p
							style="margin: 1rem 0; color: var(--text-muted); font-size: 0.95rem; line-height: 1.6; flex-grow: 1;">
							<%=shortDesc%>
						</p>

						<a href="job-details.jsp?jobId=<%=job.getJobId()%>"
							class="btn-gold" style="width: 100%;">View Details</a>
					</div>
					<%
					}
					%>

					<%
					if (jobs.isEmpty()) {
					%>
					<div class="glass-card"
						style="grid-column: 1/-1; text-align: center;">
						<p style="color: var(--text-muted); font-size: 1.2rem;">No
							active jobs match your search criteria. Try clearing your
							filters!</p>
					</div>
					<%
					}
					%>
				</div>
			</div>
		</main>
	</div>
</body>
</html>