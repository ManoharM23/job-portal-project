<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Password - Job Portal</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/public-luxury.css">
</head>
<body>
	<div class="auth-container">
		
		<a href="#" onclick="returnToDashboard(); return false;"
    style="position: absolute; top: 2rem; left: 2.5rem; color: var(--gold-primary, #cca852); text-decoration: none; font-weight: 600; display: flex; align-items: center; gap: 0.5rem; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s ease;"
    onmouseover="this.style.color='#fff'"
    onmouseout="this.style.color='var(--gold-primary, #cca852)'"> &#8592; Back to Dashboard
</a>
		<div class="auth-card">
			<h2>Change Password</h2>

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

			<form action="changePassword" method="post">
				<div class="form-group">
					<label>Current Password</label> 
					<input type="password" name="oldPassword" required placeholder="Enter current password">
				</div>
				
				<div class="form-group">
					<label>New Password</label> 
					<input type="password" name="newPassword" required placeholder="Enter new password">
				</div>
				
				<div class="form-group">
					<label>Confirm New Password</label> 
					<input type="password" name="confirmPassword" required placeholder="Confirm new password">
				</div>
				
				<button type="submit" class="btn-gold" style="width: 100%; margin-top: 1rem;">Update Password</button>
			</form>
		</div>
	</div>
	<script>

    window.onload = function() {
        let previousPage = document.referrer;
        if (previousPage.includes("dashboard.jsp")) {
            sessionStorage.setItem("dashboardOriginUrl", previousPage);
        }
    };

   
    function returnToDashboard() {
        let targetUrl = sessionStorage.getItem("dashboardOriginUrl");
        
       
        if (!targetUrl) {
            targetUrl = "index.jsp"; 
        }
        
        window.location.href = targetUrl;
    }
</script>
	
</body>
</html>