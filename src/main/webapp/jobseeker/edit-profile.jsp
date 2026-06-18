<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.*, com.jobportal.dao.*" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"jobseeker".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
    
    JobSeekerDAO seekDAO = new JobSeekerDAO();
    JobSeeker seeker = seekDAO.getJobSeekerByUserId(user.getUserId());
    
    String skills = (seeker != null && seeker.getSkills() != null) ? seeker.getSkills() : "";
    String education = (seeker != null && seeker.getEducation() != null) ? seeker.getEducation() : "";
    String location = (seeker != null && seeker.getLocation() != null) ? seeker.getLocation() : "";
    int expYears = (seeker != null) ? seeker.getExperienceYears() : 0;
    double expSalary = (seeker != null) ? seeker.getExpectedSalary() : 0;
    
    boolean hasResume = (seeker != null && seeker.hasResume());
    String resumeName = hasResume ? seeker.getResumeFileName() : null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/jobseeker-luxury.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>
</head>
<body>
    <div class="dashboard">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="edit-profile.jsp"/>
        </jsp:include>
        
        <main class="main-content">
            <div class="container-fluid" style="max-width: 900px;">
                
                <% if("updated".equals(msg)) { %> <div class="alert alert-success">Profile updated successfully.</div> <% } %>
                <% if("dpUpdated".equals(msg)) { %> <div class="alert alert-success">Profile picture updated successfully.</div> <% } %>
                <% if("resumeUploaded".equals(msg)) { %> <div class="alert alert-success">Resume uploaded successfully.</div> <% } %>
                <% if("resumeDeleted".equals(msg)) { %> <div class="alert alert-success">Resume removed successfully.</div> <% } %>
                <% if("noFile".equals(error)) { %> <div class="alert alert-error">Please select a file to upload.</div> <% } %>
                <% if("fileTooLarge".equals(error)) { %> <div class="alert alert-error">File too large. Maximum 5MB allowed.</div> <% } %>
                <% if("uploadFailed".equals(error)) { %> <div class="alert alert-error">Upload failed. Please try again.</div> <% } %>
                
                <!-- VIEW MODE -->
                <div id="viewMode">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 2rem;">
                        <h1 class="page-title" style="margin:0;">My <span>Profile</span></h1>
                        <button type="button" class="btn-gold" onclick="enableEdit()">&#9998; Edit Details</button>
                    </div>
                    
                    <div class="glass-card" style="display: flex; align-items: center; gap: 2.5rem;">
                       
                        <div style="position: relative;">
                            <div style="width: 100px; height: 100px; border-radius: 50%; overflow: hidden; background: var(--gold-metallic); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: 800; color: #000; box-shadow: 0 0 25px rgba(212,175,55,0.4); border: 3px solid var(--gold-primary);">
                                <% if (user.getProfilePicture() != null) { %>
                                    <img src="<%= request.getContextPath() %>/display-avatar?userId=<%= user.getUserId() %>&t=<%= System.currentTimeMillis() %>" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                                <% } else { %>
                                    <%= user.getFullName().charAt(0) %>
                                <% } %>
                            </div>
                            
                            <!-- Camera Icon triggers the JS File Input -->
                            <label for="avatarInput" style="position: absolute; bottom: -5px; right: -5px; background: #000; border: 1px solid var(--gold-primary); color: var(--gold-primary); width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.3s; box-shadow: 0 4px 10px rgba(0,0,0,0.5);">
                                &#128247;
                            </label>
                            <input type="file" id="avatarInput" accept="image/png, image/jpeg, image/jpg" style="display: none;">
                        </div>
                        
                        <div>
                            <h2 style="color: #fff; font-size: 2rem; margin-bottom: 0.2rem;"><%= user.getFullName() %></h2>
                            <p style="color: var(--text-muted); font-size: 1.1rem;"><%= user.getEmail() %></p>
                        </div>
                    </div>
                    
                    <div class="glass-card">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem;">
                            <div>
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Phone</label>
                                <div style="color: #fff; font-size: 1.1rem;"><%= user.getPhone() != null && !user.getPhone().isEmpty() ? user.getPhone() : "<span style='color:#555;font-style:italic;'>Not provided</span>" %></div>
                            </div>
                            <div>
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Location</label>
                                <div style="color: #fff; font-size: 1.1rem;"><%= !location.isEmpty() ? location : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                            </div>
                            <div>
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Experience</label>
                                <div style="color: #fff; font-size: 1.1rem;"><%= expYears > 0 ? expYears + " years" : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                            </div>
                            <div>
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Expected Salary</label>
                                <div style="color: #fff; font-size: 1.1rem;"><%= expSalary > 0 ? "$" + (int)expSalary + " / yr" : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                            </div>
                            <div style="grid-column: 1/-1;">
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Education</label>
                                <div style="color: #fff; font-size: 1.1rem;"><%= !education.isEmpty() ? education : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                            </div>
                            <div style="grid-column: 1/-1;">
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Skills</label>
                                <div style="color: #fff; font-size: 1.1rem;"><%= !skills.isEmpty() ? skills : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="glass-card" style="border-left: 4px solid var(--gold-primary);">
                        <h3 style="margin-top:0; color:var(--gold-primary); margin-bottom: 1rem;">&#128196; Default Resume</h3>
                        <% if(hasResume) { %>
                            <div style="display: flex; align-items: center; justify-content: space-between; background: rgba(0,0,0,0.3); padding: 1rem 1.5rem; border-radius: 8px; border: 1px solid rgba(255,255,255,0.05);">
                                <div>
                                    <div style="color: #fff; font-weight: 600;">&#128462; <%= resumeName %></div>
                                    <div style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.3rem;">Saved securely in profile</div>
                                </div>
                                <div style="display: flex; gap: 0.5rem;">
                                    <a href="../download-profile-resume" class="btn-dark" style="padding:8px 16px;">Download</a>
                                    <form action="../upload-resume" method="post" style="margin: 0;">
                                        <input type="hidden" name="action" value="delete">
                                        <button type="submit" class="btn-dark" style="padding:8px 16px; border-color: rgba(231,76,60,0.3); color: #e74c3c;" onclick="return confirm('Delete your resume?')">Remove</button>
                                    </form>
                                </div>
                            </div>
                        <% } else { %>
                            <p style="color:var(--text-muted); margin:0.5rem 0;">No resume uploaded yet.</p>
                            <p style="color:#555; font-size:0.9rem;">Upload your resume via Edit mode to use it for 1-click applications.</p>
                        <% } %>
                    </div>
                </div>
                
                <!-- EDIT MODE -->
                <div id="editForm" style="display: none;">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 2rem;">
                        <h1 class="page-title" style="margin:0;">Edit <span>Profile</span></h1>
                        <button type="button" class="btn-dark" onclick="disableEdit()">Cancel Edit</button>
                    </div>
                    
                    <div class="glass-card">
                        <form action="../update-profile" method="post">
                            <input type="hidden" name="role" value="jobseeker">
                            <h3 style="color: var(--gold-primary); margin-bottom: 1.5rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 0.5rem;">Account Information</h3>
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem;">
                                <div class="form-group"><label>Full Name *</label><input type="text" name="fullName" value="<%= user.getFullName() %>" required></div>
                                <div class="form-group"><label>Email</label><input type="email" value="<%= user.getEmail() %>" disabled style="opacity: 0.5;"></div>
                                <div class="form-group"><label>Phone</label><input type="tel" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>"></div>
                            </div>
                            
                            <h3 style="color: var(--gold-primary); margin-bottom: 1.5rem; margin-top: 1rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 0.5rem;">Professional Details</h3>
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem;">
                                <div class="form-group" style="grid-column: 1/-1;"><label>Skills (comma separated)</label><input type="text" name="skills" value="<%= skills %>"></div>
                                <div class="form-group" style="grid-column: 1/-1;"><label>Education</label><input type="text" name="education" value="<%= education %>"></div>
                                <div class="form-group"><label>Experience (years)</label><input type="number" name="experienceYears" min="0" value="<%= expYears %>"></div>
                                <div class="form-group"><label>Location</label><input type="text" name="location" value="<%= location %>"></div>
                                <div class="form-group"><label>Expected Salary ($)</label><input type="number" name="expectedSalary" min="0" value="<%= (int)expSalary %>"></div>
                            </div>
                            
                            <div style="margin-top:1.5rem;">
                                <button type="submit" class="btn-gold" style="width: 100%;">&#128190; Save Profile Data</button>
                            </div>
                        </form>
                    </div>
                    
                    <div class="glass-card" style="margin-top:1.5rem;">
                        <h3 style="color: var(--gold-primary); margin-bottom: 1rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 0.5rem;">&#128190; Upload Default Resume</h3>
                        <form action="../upload-resume" method="post" enctype="multipart/form-data">
                            <div class="file-upload" onclick="document.getElementById('resumeFile').click()">
                                <input type="file" name="resumeFile" id="resumeFile" accept=".pdf,.doc,.docx" onchange="showFileName(this)" style="display: none;">
                                <div style="font-size: 2rem; margin-bottom: 0.5rem;">&#128193;</div>
                                <div style="color: var(--gold-primary); font-weight: 600;">Click to Upload Resume</div>
                                <div style="color:#888; font-size:0.85rem; margin-top:0.5rem;">PDF, DOC, DOCX (Max 5MB)</div>
                                <div id="fileNameDisplay" style="color:#2ecc71; margin-top:1rem; font-weight: 600;"></div>
                            </div>
                            <button type="submit" class="btn-dark" style="margin-top:1.5rem; width: 100%;">Upload Document</button>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    
    <div id="cropperModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.85); z-index:9999; align-items:center; justify-content:center; backdrop-filter: blur(5px);">
        <div class="glass-card" style="width: 500px; max-width: 90%; background: var(--bg-deep); border: 1px solid var(--gold-primary);">
            <h3 style="color:var(--gold-primary); margin-bottom: 1rem; text-transform: uppercase; letter-spacing: 1px;">Adjust Profile Picture</h3>
            
            <div style="width: 100%; height: 350px; background: #000; margin-bottom: 1.5rem; border-radius: 8px; overflow: hidden;">
                <img id="imageToCrop" src="" style="max-width: 100%; display: block;">
            </div>
            
            <div style="display:flex; gap: 1rem;">
                <button type="button" onclick="rotateImage()" class="btn-dark" style="padding: 10px 15px;">&#10227; Rotate</button>
                <button type="button" onclick="uploadCroppedImage()" class="btn-gold" style="flex:1; padding: 10px 15px;" id="btnUploadCrop">Save & Upload</button>
                <button type="button" onclick="closeCropper()" class="btn-dark" style="padding: 10px 15px;">Cancel</button>
            </div>
        </div>
    </div>

    <!-- UI Scripts -->
    <script>
        function enableEdit() {
            document.getElementById('viewMode').style.display = 'none';
            document.getElementById('editForm').style.display = 'block';
        }
        function disableEdit() {
            document.getElementById('viewMode').style.display = 'block';
            document.getElementById('editForm').style.display = 'none';
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
    
    <!-- Cropper Scripts -->
    <script>
        let cropper;
        const avatarInput = document.getElementById('avatarInput');
        const imageToCrop = document.getElementById('imageToCrop');
        const modal = document.getElementById('cropperModal');
        const btnUpload = document.getElementById('btnUploadCrop');

        // 1. When user selects a file, open the modal
        avatarInput.addEventListener('change', function(e) {
            const files = e.target.files;
            if (files && files.length > 0) {
                const file = files[0];
                
                // Validate file size on client side (max 5MB)
                if (file.size > 5 * 1024 * 1024) {
                    alert("File is too large. Maximum size is 5MB.");
                    avatarInput.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function(event) {
                    imageToCrop.src = event.target.result;
                    modal.style.display = 'flex'; // Show modal
                    
                    // Initialize Cropper.js
                    if (cropper) cropper.destroy();
                    cropper = new Cropper(imageToCrop, {
                        aspectRatio: 1, // Forces a perfect square crop
                        viewMode: 2,    // Restricts crop box to within the canvas
                        background: false
                    });
                };
                reader.readAsDataURL(file);
            }
        });

        // 2. Rotate Image Button
        function rotateImage() {
            if(cropper) {
                cropper.rotate(90);
            }
        }

        // 3. Cancel Button
        function closeCropper() {
            modal.style.display = 'none';
            avatarInput.value = ''; // Reset input
            if(cropper) cropper.destroy();
        }

        // 4. Save & Upload
        function uploadCroppedImage() {
            if (!cropper) return;
            
            // Show loading state
            btnUpload.innerHTML = "Uploading...";
            btnUpload.style.opacity = "0.7";
            btnUpload.style.pointerEvents = "none";

            // Get the cropped image as a Blob (binary data)
            cropper.getCroppedCanvas({
                width: 400, // Resize to max 400x400 for DB efficiency
                height: 400,
                fillColor: '#fff' // fill transparent backgrounds (like PNGs) with white
            }).toBlob(function(blob) {
                
                // Create a FormData object (this mimics a standard HTML form submission)
                const formData = new FormData();
                formData.append('avatarFile', blob, 'profile_pic.jpg');

                // Send via AJAX fetch to your existing Servlet
                fetch('../upload-avatar', {
                    method: 'POST',
                    body: formData
                }).then(response => {
                    if(response.ok) {
                        // Reload page to show new image and success message
                        window.location.href = 'edit-profile.jsp?msg=dpUpdated';
                    } else {
                        alert("Upload failed. Please try again.");
                        closeCropper();
                        btnUpload.innerHTML = "Save & Upload";
                        btnUpload.style.opacity = "1";
                        btnUpload.style.pointerEvents = "auto";
                    }
                }).catch(error => {
                   // console.error("Error:", error);
                    alert("An error occurred during upload.");
                    closeCropper();
                    btnUpload.innerHTML = "Save & Upload";
                    btnUpload.style.opacity = "1";
                    btnUpload.style.pointerEvents = "auto";
                });
                
            }, 'image/jpeg', 0.9); // Compress as JPEG at 90% quality
        }
    </script>
</body>
</html>