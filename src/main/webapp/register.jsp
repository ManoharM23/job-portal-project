<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String role = request.getParameter("role");
if (role == null || (!role.equals("recruiter") && !role.equals("jobseeker"))) {
	role = "jobseeker";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Account - Job Portal</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/public-luxury.css">
</head>
<body>
	<div class="auth-container">
		<a href="index.jsp"
			style="position: absolute; top: 2rem; left: 2.5rem; color: var(--gold-primary); text-decoration: none; font-weight: 600; display: flex; align-items: center; gap: 0.5rem; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s ease;"
			onmouseover="this.style.color='#fff'"
			onmouseout="this.style.color='var(--gold-primary)'"> &#8592; Home
		</a>
		<div class="auth-card" style="max-width: 550px;">
			<h2>Create Your Profile</h2>

			<%
			if (request.getAttribute("error") != null) {
			%>
			<div class="alert alert-error">
				<%=request.getAttribute("error")%>
			</div>
			<%
			}
			%>

			<%
			if (request.getAttribute("success") != null) {
			%>
			<div class="alert alert-success">
				<%=request.getAttribute("success")%>
			</div>
			<%
			}
			%>

			<form action="register" method="post"
				onsubmit="return validateRegister()">
				<div class="form-group">
					<label>Account Type</label> <select name="role" id="role"
						onchange="toggleFields()">
						<option value="jobseeker"
							<%="jobseeker".equals(role) ? "selected" : ""%>>Professional
							/ Candidate</option>
						<option value="recruiter"
							<%="recruiter".equals(role) ? "selected" : ""%>>Enterprise
							/ Recruiter</option>
					</select>
				</div>

				<div class="form-group">
					<label>Full Name *</label> <input type="text" name="fullName"
						id="fullName" required placeholder="John Doe">
				</div>

				<div class="form-group" id="companyField"
					style="display: <%="recruiter".equals(role) ? "block" : "none"%>;">
					<label>Company Name *</label> <input type="text" name="companyName"
						id="companyName" placeholder="Acme Corp">
				</div>

				<div class="form-group">
					<label>Email Address *</label> <input type="email" name="email"
						id="email" required placeholder="john@example.com">
				</div>

				<div
					style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
					<div class="form-group">
						<label>Phone Number</label> <input type="tel" name="phone"
							id="phone" placeholder="+1 234 567 8900">
					</div>
					<div class="form-group">
						<label>Password *</label> <input type="password" name="password"
							id="password" required placeholder="••••••••">
					</div>
				</div>

				<div class="form-group" style="margin-top: 1rem; margin-bottom: 0;">
					<button type="submit" class="btn-gold" style="width: 100%;">Create
						Account</button>
				</div>
			</form>

			<p class="auth-link">
				Already a member? <a href="login.jsp">Login here</a>
			</p>
		</div>
	</div>

	<script>
		function toggleFields() {
			var role = document.getElementById('role').value;
			var companyField = document.getElementById('companyField');
			var companyInput = document.getElementById('companyName');

			if (role === 'recruiter') {
				companyField.style.display = 'block';
				companyInput.setAttribute('required', 'required');
			} else {
				companyField.style.display = 'none';
				companyInput.removeAttribute('required');
			}
		}

		window.onload = function() {
			toggleFields();
		};
	</script>
	<script src="js/validation.js"></script>
</body>
</html>