<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Premium Job Portal - Launch & Elevate Your Career</title>
   
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/public-luxury.css">
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <div class="logo">JobPortal</div>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="register.jsp" class="nav-btn">Get Started</a></li>
            </ul>
        </div>
    </nav>
    
    <header class="hero">
        <div class="container">
            <h1>Shape Your <span>Future</span></h1>
            <p>Connect with innovative companies and discover opportunities tailored to every stage of your journey—from ambitious graduates to seasoned experts.</p>
            <div class="cta-buttons">
                <a href="register.jsp?role=jobseeker" class="btn-gold">I am Looking for a Job</a>
                <a href="register.jsp?role=recruiter" class="btn-dark">I am Hiring Talent</a>
            </div>
        </div>
    </header>
    
    <section class="features">
        <div class="container">
            <div class="feature-card">
                <div class="icon">&#128188;</div>
                <h3>For Candidates</h3>
                <p>Whether you are launching your career or taking the next big step, experience seamless 1-click applications and direct connections to top-tier organizations.</p>
            </div>
            <div class="feature-card">
                <div class="icon">&#127970;</div>
                <h3>For Enterprises</h3>
                <p>Streamlined candidate management, premium brand positioning, and access to a diverse pool of exceptional talent at all experience levels.</p>
            </div>
        </div>
    </section>
    
    <footer>
        <p>&copy; 2026 Job Portal Premium. All rights reserved.</p>
    </footer>
</body>
</html>