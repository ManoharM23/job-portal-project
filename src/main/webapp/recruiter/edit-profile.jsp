<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jobportal.model.*, com.jobportal.dao.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"recruiter".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");

    RecruiterDAO recDAO = new RecruiterDAO();
    Recruiter recruiter = recDAO.getRecruiterByUserId(user.getUserId());

    String companyName = (recruiter != null && recruiter.getCompanyName() != null) ? recruiter.getCompanyName() : "";
    String companyWebsite = (recruiter != null && recruiter.getWebsite() != null) ? recruiter.getWebsite() : "";
    String location = (recruiter != null && recruiter.getLocation() != null) ? recruiter.getLocation() : "";
    String industry = (recruiter != null && recruiter.getIndustry() != null) ? recruiter.getIndustry() : "";
    String companyDescription = (recruiter != null && recruiter.getCompanyDescription() != null) ? recruiter.getCompanyDescription() : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Recruiter</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/recruiter-luxury.css">
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>
</head>
<body>
    <div class="dashboard">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="edit-profile.jsp"/>
        </jsp:include>

        <main class="main-content">
            <div class="container-fluid" style="max-width: 900px;" id="profileContainer">

                <% if("updated".equals(msg)) { %> <div class="alert alert-success">&#10003; Profile updated successfully.</div> <% } %>
                <% if("dpUpdated".equals(msg)) { %> <div class="alert alert-success">&#10003; Profile picture updated.</div> <% } %>
                <% if("error".equals(error)) { %> <div class="alert alert-error">&#10007; Something went wrong. Please try again.</div> <% } %>

                <div id="viewMode">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 2rem;">
                        <h1 class="page-title" style="margin:0;">Company <span>Profile</span></h1>
                        <button type="button" class="btn-gold" onclick="enableEdit()">&#9998; Edit Details</button>
                    </div>

                    <div class="glass-card" style="display: flex; align-items: center; gap: 2.5rem; margin-bottom: 2rem;">
                        <div style="position: relative;">
                            <div style="width: 100px; height: 100px; border-radius: 50%; overflow: hidden; background: var(--gold-metallic); display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: 800; color: #000; box-shadow: 0 0 25px rgba(212,175,55,0.4); border: 3px solid var(--gold-primary);">
                                <% if (user.getProfilePicture() != null) { %>
                                    <img src="<%= request.getContextPath() %>/display-avatar?userId=<%= user.getUserId() %>&t=<%= System.currentTimeMillis() %>" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                                <% } else { %>
                                    <%= user.getFullName().charAt(0) %>
                                <% } %>
                            </div>
                            
                            <label for="avatarInput" style="position: absolute; bottom: 0; right: 0; background: #000; border: 1px solid var(--gold-primary); color: var(--gold-primary); width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.3s; box-shadow: 0 4px 10px rgba(0,0,0,0.5);">
                                &#128247;
                            </label>
                            <input type="file" id="avatarInput" accept="image/png, image/jpeg, image/jpg" style="display: none;">
                        </div>
                        
                        <div>
                            <h2 style="color: #fff; font-size: 2rem; margin-bottom: 0.2rem;"><%= user.getFullName() %></h2>
                            <p style="color: var(--text-muted); font-size: 1.1rem;"><%= user.getEmail() %></p>
                            <% if(!companyName.isEmpty()) { %>
                                <span style="display: inline-block; margin-top: 0.8rem; background: rgba(212,175,55,0.1); color: var(--gold-primary); padding: 6px 14px; border-radius: 20px; font-size: 0.85rem; border: 1px solid rgba(212,175,55,0.3); font-weight: 600;">&#127970; <%= companyName %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="glass-card">
                        <h3 style="color: var(--gold-primary); margin-bottom: 1.5rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 0.5rem;">Personal Information</h3>
                        <div class="info-grid">
                            <div>
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Phone</label>
                                <div style="color: #fff; font-size: 1.1rem;"><%= user.getPhone() != null && !user.getPhone().isEmpty() ? user.getPhone() : "<span style='color:#555;font-style:italic;'>Not provided</span>" %></div>
                            </div>
                        </div>
                    </div>

                    <div class="glass-card">
                        <h3 style="color: var(--gold-primary); margin-bottom: 1.5rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 0.5rem;">Company Details</h3>
                        <div class="info-grid">
                            <div>
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Industry</label>
                                <div style="color: #fff; font-size: 1.1rem;"><%= !industry.isEmpty() ? industry : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                            </div>
                            <div>
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Location</label>
                                <div style="color: #fff; font-size: 1.1rem;"><%= !location.isEmpty() ? location : "<span style='color:#555;font-style:italic;'>Not specified</span>" %></div>
                            </div>
                            <div>
    <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">Website</label>
    <div style="color: #fff; font-size: 1.1rem; word-break: break-all; overflow-wrap: anywhere;">
        <% if(!companyWebsite.isEmpty()) { %>
            <a href="<%= companyWebsite.startsWith("http") ? companyWebsite : "http://" + companyWebsite %>" target="_blank" style="color: #3498db; text-decoration: none; word-break: break-all;"><%= companyWebsite %></a>
        <% } else { %>
            <span style='color:#555;font-style:italic;'>Not specified</span>
        <% } %>
    </div>
</div>
                            </div>
                            <div style="grid-column: 1 / -1;">
                                <label style="display: block; font-size: 0.75rem; color: var(--gold-primary); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem;">About Company</label>
                                <div style="color: #ccc; font-size: 1rem; line-height: 1.6;"><%= !companyDescription.isEmpty() ? companyDescription : "<span style='color:#555;font-style:italic;'>No description provided</span>" %></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="editForm" style="display: none;">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 2rem;">
                        <h1 class="page-title" style="margin:0;">Edit <span>Profile</span></h1>
                        <button type="button" class="btn-dark" onclick="disableEdit()">Cancel Edit</button>
                    </div>

                    <div class="glass-card">
                        <form action="../update-profile" method="post">
                            <input type="hidden" name="role" value="recruiter">
                            
                            <h3 style="color: var(--gold-primary); margin-bottom: 1.5rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 0.5rem;">Account Information</h3>
                            <div class="info-grid">
                                <div class="form-group"><label>Full Name *</label><input type="text" name="fullName" value="<%= user.getFullName() %>" required></div>
                                <div class="form-group"><label>Email</label><input type="email" value="<%= user.getEmail() %>" disabled style="opacity: 0.5;"></div>
                                <div class="form-group"><label>Phone</label><input type="tel" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>"></div>
                            </div>

                            <h3 style="color: var(--gold-primary); margin-bottom: 1.5rem; margin-top: 2rem; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 0.5rem;">Company Details</h3>
                            <div class="info-grid">
                                <div class="form-group"><label>Company Name</label><input type="text" name="companyName" value="<%= companyName %>" placeholder="e.g. Tech Solutions"></div>
                                <div class="form-group"><label>Industry</label><input type="text" name="industry" value="<%= industry %>" placeholder="e.g. IT Services"></div>
                                <div class="form-group"><label>Location</label><input type="text" name="location" value="<%= location %>" placeholder="e.g. Bangalore"></div>
                                <div class="form-group"><label>Website</label><input type="url" name="website" value="<%= companyWebsite %>" placeholder="https://..."></div>
                                <div class="form-group" style="grid-column: 1 / -1;">
                                    <label>About Company</label>
                                    <textarea name="companyDescription" placeholder="Describe your company..."><%= companyDescription %></textarea>
                                </div>
                            </div>
                            
                            <div style="margin-top:2rem;">
                                <button type="submit" class="btn-gold" style="width: 100%;">&#128190; Save Changes</button>
                            </div>
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

    <script>
        function enableEdit() {
            document.getElementById('viewMode').style.display = 'none';
            document.getElementById('editForm').style.display = 'block';
        }
        function disableEdit() {
            document.getElementById('viewMode').style.display = 'block';
            document.getElementById('editForm').style.display = 'none';
        }
    </script>
    
    <script>
        let cropper;
        const avatarInput = document.getElementById('avatarInput');
        const imageToCrop = document.getElementById('imageToCrop');
        const modal = document.getElementById('cropperModal');
        const btnUpload = document.getElementById('btnUploadCrop');

        avatarInput.addEventListener('change', function(e) {
            const files = e.target.files;
            if (files && files.length > 0) {
                const file = files[0];
                
                if (file.size > 5 * 1024 * 1024) {
                    alert("File is too large. Maximum size is 5MB.");
                    avatarInput.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function(event) {
                    imageToCrop.src = event.target.result;
                    modal.style.display = 'flex'; 
                    
                    if (cropper) cropper.destroy();
                    cropper = new Cropper(imageToCrop, {
                        aspectRatio: 1, 
                        viewMode: 2,    
                        background: false
                    });
                };
                reader.readAsDataURL(file);
            }
        });

        function rotateImage() {
            if(cropper) {
                cropper.rotate(90);
            }
        }

        function closeCropper() {
            modal.style.display = 'none';
            avatarInput.value = ''; 
            if(cropper) cropper.destroy();
        }

        function uploadCroppedImage() {
            if (!cropper) return;
            
            btnUpload.innerHTML = "Uploading...";
            btnUpload.style.opacity = "0.7";
            btnUpload.style.pointerEvents = "none";

            cropper.getCroppedCanvas({
                width: 400, 
                height: 400,
                fillColor: '#fff' 
            }).toBlob(function(blob) {
                
                const formData = new FormData();
                formData.append('avatarFile', blob, 'profile_pic.jpg');

                // Used dynamic context path for safety
                fetch('<%= request.getContextPath() %>/upload-avatar', {
                    method: 'POST',
                    body: formData
                }).then(response => {
                    if(response.ok) {
                        window.location.href = 'edit-profile.jsp?msg=dpUpdated';
                    } else {
                        alert("Upload failed. Please try again.");
                        closeCropper();
                        btnUpload.innerHTML = "Save & Upload";
                        btnUpload.style.opacity = "1";
                        btnUpload.style.pointerEvents = "auto";
                    }
                }).catch(error => {
                    console.error("Error:", error);
                    alert("An error occurred during upload.");
                    closeCropper();
                    btnUpload.innerHTML = "Save & Upload";
                    btnUpload.style.opacity = "1";
                    btnUpload.style.pointerEvents = "auto";
                });
                
            }, 'image/jpeg', 0.9); 
        }
    </script>
</body>
</html>