
// Helper function to dynamically show error messages
function showError(message, formElement) {
    // Remove any existing client-side alerts to prevent stacking
    const existingAlert = formElement.parentElement.querySelector('.client-alert');
    if (existingAlert) {
        existingAlert.remove();
    }

    // Create the error alert 
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-error client-alert';
    // Add a slight slide-down animation effect natively via inline transition
    alertDiv.style.opacity = '0';
    alertDiv.style.transform = 'translateY(-10px)';
    alertDiv.style.transition = 'all 0.3s ease';
    
    alertDiv.innerHTML = '&#10007; ' + message;
    
    // Insert the alert right before the form
    formElement.parentNode.insertBefore(alertDiv, formElement);

    // Trigger animation
    setTimeout(() => {
        alertDiv.style.opacity = '1';
        alertDiv.style.transform = 'translateY(0)';
    }, 10);

    // Scroll slightly so the user sees the error
    alertDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

// Helper function to validate email format
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Validates the Login Form (called by onsubmit in login.jsp)
function validateLogin() {
    const form = document.querySelector('form[action="login"]');
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value.trim();

    if (!email) {
        showError("Email address is required.", form);
        return false;
    }
    
    if (!isValidEmail(email)) {
        showError("Please enter a valid email address.", form);
        return false;
    }

    if (!password) {
        showError("Password is required.", form);
        return false;
    }

    return true; // Form is valid, allow submission
}

// Validates the Registration Form (called by onsubmit in register.jsp)
function validateRegister() {
    const form = document.querySelector('form[action="register"]');
    const role = document.getElementById('role').value;
    const fullName = document.getElementById('fullName').value.trim();
    const email = document.getElementById('email').value.trim();
    const phone = document.getElementById('phone').value.trim();
    const password = document.getElementById('password').value;

    // Validate Full Name
    if (!fullName || fullName.length < 2) {
        showError("Please enter your complete full name.", form);
        return false;
    }

    // Validate Company Name (Only if Recruiter)
    if (role === 'recruiter') {
        const companyName = document.getElementById('companyName').value.trim();
        if (!companyName) {
            showError("Enterprise/Company name is required for recruiter accounts.", form);
            return false;
        }
    }

    // Validate Email
    if (!email || !isValidEmail(email)) {
        showError("Please enter a valid email address.", form);
        return false;
    }

    // Validate Phone (Optional, but if provided must match general phone format)
    if (phone) {
        // Allows digits, spaces, +, -, and ()
        const phoneRegex = /^[0-9+\-\s()]{7,15}$/;
        if (!phoneRegex.test(phone)) {
            showError("Please enter a valid phone number format.", form);
            return false;
        }
    }

    // Validate Password Strength
    if (!password || password.length < 6) {
        showError("For your security, passwords must be at least 6 characters long.", form);
        return false;
    }

    // Show a loading state on the button to prevent double-clicks
    const submitBtn = form.querySelector('button[type="submit"]');
    if (submitBtn) {
        submitBtn.innerHTML = 'Processing...';
        submitBtn.style.opacity = '0.8';
        submitBtn.style.pointerEvents = 'none';
    }

    return true; // Form is valid, allow submission to Java backend
}