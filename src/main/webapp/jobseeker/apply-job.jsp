<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.*, com.jobportal.dao.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"jobseeker".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String jobIdStr = request.getParameter("jobId");
    if(jobIdStr == null) {
        response.sendRedirect("browse-jobs.jsp");
        return;
    }
    int jobId = Integer.parseInt(jobIdStr);
    
    JobDAO jobDAO = new JobDAO();
    Job job = jobDAO.getJobById(jobId);
    
    int seekerId = (session.getAttribute("seekerId") != null) ? (Integer) session.getAttribute("seekerId") : -1;
    JobSeekerDAO seekDAO = new JobSeekerDAO();
    JobSeeker seeker = seekDAO.getJobSeekerById(seekerId);
    boolean hasProfileResume = (seeker != null && seeker.hasResume());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Apply - <%= job != null ? job.getTitle() : "Job" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/jobseeker-luxury.css">
</head>
<body>
    <div class="dashboard">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="browse-jobs.jsp"/>
        </jsp:include>
        
        <main class="main-content">
            <div class="container-fluid" style="max-width: 800px;">
                <h1 class="page-title">Submit <span>Application</span></h1>
                
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-error"><%= request.getAttribute("error") %></div>
                <% } %>
                
                <div class="glass-card">
                    <h2 style="color: #fff; margin-bottom: 0.5rem;"><%= job != null ? job.getTitle() : "" %></h2>
                    <p style="color: var(--gold-primary); margin-bottom: 2rem;">&#127970; <%= job != null ? job.getCompanyName() : "" %></p>

                    <form action="../apply" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="jobId" value="<%= jobId %>">
                        
                        <div class="form-group">
                            <label>Cover Letter / Message</label>
                            <textarea name="coverLetter" rows="6" placeholder="Briefly explain why you are a great fit for this role..."></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label style="margin-bottom: 1rem;">Select Resume Format *</label>
                            
                            <% if(hasProfileResume) { %>
                            <div class="resume-option selected" id="divProfile" onclick="selectOption('profile')">
                                <label style="display: flex; align-items: flex-start; cursor: pointer; text-transform: none; margin: 0;">
                                    <input type="radio" name="resumeOption" value="profile" id="optProfile" checked>
                                    <div>
                                        <div class="option-title">&#128196; Use Saved Profile Resume</div>
                                        <div class="option-desc"><%= seeker.getResumeFileName() %></div>
                                    </div>
                                </label>
                            </div>
                            <% } %>
                            
                            <div class="resume-option <%= !hasProfileResume ? "selected" : "" %>" id="divUpload" onclick="selectOption('upload')">
                                <label style="display: flex; align-items: flex-start; cursor: pointer; text-transform: none; margin: 0;">
                                    <input type="radio" name="resumeOption" value="upload" id="optUpload" <%= !hasProfileResume ? "checked" : "" %>>
                                    <div>
                                        <div class="option-title">&#128193; Upload Custom Resume</div>
                                        <div class="option-desc">Attach a tailored resume specifically for this application</div>
                                    </div>
                                </label>
                                <div class="file-upload" id="uploadArea" style="display:<%= !hasProfileResume ? "block" : "none" %>;" onclick="document.getElementById('resumeFile').click(); event.stopPropagation();">
                                    <input type="file" name="resumeFile" id="resumeFile" accept=".pdf,.doc,.docx" onchange="showFileName(this)" style="display: none;">
                                    <div style="color: var(--gold-primary); font-weight: 600;">Click to select file</div>
                                    <div style="color: #888; font-size: 0.85rem; margin-top: 0.5rem;">PDF, DOC, DOCX (Max 5MB)</div>
                                    <div id="fileNameDisplay" style="color:#2ecc71; margin-top:1rem; font-weight: 600;"></div>
                                </div>
                            </div>
                            
                            <div class="resume-option" id="divNone" onclick="selectOption('none')">
                                <label style="display: flex; align-items: flex-start; cursor: pointer; text-transform: none; margin: 0;">
                                    <input type="radio" name="resumeOption" value="none" id="optNone">
                                    <div>
                                        <div class="option-title">&#10007; Apply Without Resume</div>
                                        <div class="option-desc">Rely only on your profile details and cover letter</div>
                                    </div>
                                </label>
                            </div>
                        </div>
                        
                        <div style="margin-top: 2.5rem; display: flex; gap: 1rem;">
                            <button type="submit" class="btn-gold" style="flex: 1;">Submit Application</button>
                            <a href="job-details.jsp?jobId=<%= jobId %>" class="btn-dark" style="flex: 1;">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        function selectOption(option) {
            document.getElementById('optProfile') && (document.getElementById('optProfile').checked = (option === 'profile'));
            document.getElementById('optUpload').checked = (option === 'upload');
            document.getElementById('optNone').checked = (option === 'none');
            
            var uploadArea = document.getElementById('uploadArea');
            uploadArea.style.display = (option === 'upload') ? 'block' : 'none';
            
            document.querySelectorAll('.resume-option').forEach(opt => opt.classList.remove('selected'));
            
            if(option === 'profile') document.getElementById('divProfile').classList.add('selected');
            if(option === 'upload') document.getElementById('divUpload').classList.add('selected');
            if(option === 'none') document.getElementById('divNone').classList.add('selected');
        }
        
        function showFileName(input) {
            var display = document.getElementById('fileNameDisplay');
            if (input.files && input.files[0]) {
                display.textContent = 'Selected: ' + input.files[0].name;
            } else {
                display.textContent = '';
            }
        }
    </script>
</body>
</html>