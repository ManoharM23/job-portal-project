<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Secure Login - Job Portal</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/public-luxury.css">
</head>
<body>
	<div class="auth-container">
		<a href="index.jsp"
			style="position: absolute; top: 2rem; left: 2.5rem; color: var(--gold-primary, #cca852); text-decoration: none; font-weight: 600; display: flex; align-items: center; gap: 0.5rem; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s ease;"
			onmouseover="this.style.color='#fff'"
			onmouseout="this.style.color='var(--gold-primary, #cca852)'"> &#8592; Home
		</a>
		<div class="auth-card">
			<h2>Welcome Back</h2>

			<!-- System Errors -->
			<%
			if (request.getAttribute("error") != null) {
			%>
			<div class="alert alert-error"><%=request.getAttribute("error")%></div>
			<%
			}
			%>
			<%
			if (request.getAttribute("success") != null) {
			%>
			<div class="alert alert-success"><%=request.getAttribute("success")%></div>
			<%
			}
			%>

			<!-- Password Reset Session Messages -->
			<%
			String successMsg = (String) session.getAttribute("successMsg");
			if (successMsg != null) {
			%>
			<div class="alert alert-success">
				<strong>Success:</strong> <%=successMsg%>
			</div>
			<%
			session.removeAttribute("successMsg");
			}
			%>

			<%
			String errorMsg = (String) session.getAttribute("errorMsg");
			if (errorMsg != null) {
			%>
			<div class="alert alert-error"><%=errorMsg%></div>
			<%
			session.removeAttribute("errorMsg");
			}
			%>

			<form action="login" method="post" onsubmit="return validateLogin()">
				<div class="form-group">
					<label>Email Address</label> 
					<input type="email" name="email" id="email" required placeholder="Enter your registered email">
				</div>
				<div class="form-group">
					<label>Password</label> 
					<input type="password" name="password" id="password" required placeholder="••••••••">
				</div>
				
				<button type="submit" class="btn-gold" style="width: 100%; margin-top: 1rem;">Authenticate</button>
				
				<div style="text-align: center; margin-top: 20px;">
					<a href="forgotPassword.jsp" style="color: var(--gold-primary, #cca852); text-decoration: none; font-size: 0.9rem; transition: color 0.3s ease;"
					onmouseover="this.style.color='#fff'"
					onmouseout="this.style.color='var(--gold-primary, #cca852)'">Forgot Password?</a>
				</div>
			</form>
			
			<p class="auth-link" style="margin-top: 1.5rem;">
				Not a member yet? <a href="register.jsp">Request Access</a>
			</p>
		</div>
	</div>
	<script src="js/validation.js"></script>
</body>
</html>