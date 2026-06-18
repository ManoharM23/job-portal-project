<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Account Recovery - Job Portal</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/public-luxury.css">
</head>
<body>
	<div class="auth-container">
		<a href="login.jsp"
			style="position: absolute; top: 2rem; left: 2.5rem; color: var(--gold-primary, #cca852); text-decoration: none; font-weight: 600; display: flex; align-items: center; gap: 0.5rem; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s ease;"
			onmouseover="this.style.color='#fff'"
			onmouseout="this.style.color='var(--gold-primary, #cca852)'"> &#8592; Back to Login
		</a>
		
		<div class="auth-card">
			<h2>Account Recovery</h2>

			<%
			String errorMsg = (String) session.getAttribute("errorMsg");
			if (errorMsg != null) {
			%>
			<div class="alert alert-error"><%=errorMsg%></div>
			<%
			session.removeAttribute("errorMsg");
			}
			%>

			<form action="forgotPassword" method="post">
				<div class="form-group">
					<label>Email Address</label> 
					<input type="email" id="email" name="email" required placeholder="Enter your registered email">
				</div>
				<button type="submit" class="btn-gold" style="width: 100%; margin-top: 1rem;">Request Reset Code</button>
			</form>
		</div>
	</div>
</body>
</html>