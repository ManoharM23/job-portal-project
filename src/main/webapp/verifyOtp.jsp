<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Secure Verification - Job Portal</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/public-luxury.css">
</head>
<body>
	<div class="auth-container">
		<div class="auth-card">
			<h2>Secure Verification</h2>

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

			<form action="updatePassword" method="post">
				<div class="form-group">
					<label>Security Code (OTP)</label> 
					<input type="text" id="otp" name="otp" required placeholder="Enter the 6-digit code">
				</div>
				
				<div class="form-group">
					<label>New Password</label> 
					<input type="password" id="newPassword" name="newPassword" required placeholder="••••••••">
				</div>
				
				<button type="submit" class="btn-gold" style="width: 100%; margin-top: 1rem;">Update Password</button>
			</form>
		</div>
	</div>
</body>
</html>