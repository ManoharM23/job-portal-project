<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.*"%>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"recruiter".equals(user.getRole())) {
	response.sendRedirect("../login.jsp");
	return;
}
String error = request.getParameter("error");
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Post a Job - Recruiter</title>
<link rel="stylesheet" href="../css/recruiter-luxury.css">
</head>
<body>
	<div class="dashboard">
		<jsp:include page="sidebar.jsp">
			<jsp:param name="activePage" value="post-job.jsp" />
		</jsp:include>

		<main class="main-content">
			<div class="container-fluid" style="max-width: 900px;">
				<h1 class="page-title">
					Post a <span>New Job</span>
				</h1>

				<%
				if ("error".equals(error)) {
				%>
				<div class="alert alert-error">&#10007; Failed to post job.
					Please try again.</div>
				<%
				}
				%>
				<%
				if ("success".equals(msg)) {
				%>
				<div class="alert alert-success">&#10003; Job posted
					successfully!</div>
				<%
				}
				%>

				<div class="glass-card">
					<form action="<%=request.getContextPath()%>/recruiter/post-job"
						method="post">
						<div class="info-grid">
							<div class="form-group">
								<label>Job Title *</label> <input type="text" name="title"
									placeholder="e.g. Senior Java Developer" required>
							</div>
							<div class="form-group">
								<label>Location *</label> <input type="text" name="location"
									placeholder="e.g. New York, NY or Remote" required>
							</div>
							<div class="form-group">
								<label>Job Type</label> <select name="jobType">
									<option value="full-time">Full Time</option>
									<option value="part-time">Part Time</option>
									<option value="contract">Contract</option>
									<option value="internship">Internship</option>
								</select>
							</div>
							<div class="form-group">
								<label>Education Required</label> <input type="text"
									name="education"
									placeholder="e.g. Bachelor's Degree in Computer Science">
							</div>
							<div class="form-group">
								<label>Salary Min ($)</label> <input type="number"
									name="salaryMin" placeholder="e.g. 80000" min="0">
							</div>
							<div class="form-group">
								<label>Salary Max ($)</label> <input type="number"
									name="salaryMax" placeholder="e.g. 120000" min="0">
							</div>
							<div class="form-group">
								<label>Deadline</label> <input type="date" name="deadline"
									style="color-scheme: dark;">
							</div>
							<div class="form-group" style="grid-column: 1/-1;">
								<label>Skills Required</label> <input type="text"
									name="skillsRequired" placeholder="e.g. Java, Spring, MySQL">
							</div>
							<div class="form-group" style="grid-column: 1/-1;">
								<label>Job Description *</label>
								<textarea name="description"
									placeholder="Describe the role, responsibilities, and requirements..."
									required></textarea>
							</div>
							<div class="form-group" style="grid-column: 1/-1;">
								<label>Requirements</label>
								<textarea name="requirements"
									placeholder="List specific requirements and qualifications..."></textarea>
							</div>
						</div>
						<div style="margin-top: 2rem;">
							<button type="submit" class="btn-gold">&#128188; Post
								Job</button>
							<a href="dashboard.jsp" class="btn-dark"
								style="margin-left: 1rem;">Cancel</a>
						</div>
					</form>
				</div>
			</div>
		</main>
	</div>
</body>
</html>