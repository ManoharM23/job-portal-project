# Job Portal – Java Servlets & JSP

A full-stack job portal web application built with **Java Servlets, JSP, and MySQL** . Job seekers can browse, search, and apply for jobs. Recruiters can post openings and manage applicants. The app features OTP-based password reset via Gmail SMTP, PBKDF2 password hashing, and role-based access control throughout.

---

## Features

### Job Seekers
- Register and log in securely (PBKDF2 hashed passwords with per-user salts)
- Browse and search active job listings by keyword, location, and job type — with paginated results
- View full job details including salary range, skills required, education, and deadline
- Apply with a cover letter; optionally reuse a saved profile resume or upload a new one per application
- Track all submitted applications and their current status from a personal dashboard
- Edit profile (skills, experience, education, expected salary, bio)
- Upload a profile picture and resume, served back via dedicated download servlets

### Recruiters
- Register with a company name; manage a full company profile (industry, website, description, location)
- Post new job listings with all relevant fields (salary range, skills, education, deadline)
- View and manage all posted jobs; delete listings with ownership verification
- Browse applicants per job, read cover letters, and download submitted resumes
- Update application statuses (Pending → Shortlisted / Rejected) — with server-side ownership checks so a recruiter can only update their own applicants

### Auth & Security
- OTP-based forgot-password flow: 6-digit code sent via Gmail SMTP, stored with a 15-minute expiry in the database
- Change-password flow: re-verifies the current password before allowing update
- Session-based auth with role enforcement on every servlet and JSP
- Logout clears cache headers and fully invalidates the session

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java Servlets (Jakarta EE), JSP |
| Database | MySQL 8, accessed via raw JDBC + `PreparedStatement` |
| Password Security | PBKDF2WithHmacSHA256, 65,536 iterations, random per-user salt, constant-time comparison |
| Email | Jakarta Mail (Gmail SMTP + App Password) |
| Frontend | JSP with custom CSS (dark/gold luxury theme), vanilla JS for client-side validation |
| Server | Apache Tomcat 10+ (Jakarta Servlet 5+/6+) |

---

## Project Structure

```
src/
└── com/jobportal/
    ├── controller/        # Servlets — one per feature (Login, Register, PostJob, Apply, etc.)
    ├── dao/               # JDBC data access layer (ApplicationDAO, JobDAO, UserDAO, etc.)
    ├── model/             # POJOs: User, Job, JobSeeker, Recruiter, Application
    └── util/
        ├── PasswordHash.java   # PBKDF2 hashing + constant-time verification
        └── EmailUtility.java   # Gmail SMTP OTP sender

webapp/
├── index.jsp, login.jsp, register.jsp
├── forgotPassword.jsp, verifyOtp.jsp, changePassword.jsp
├── jobseeker/             # Dashboard, browse-jobs, job-details, apply, my-applications, edit-profile
└── recruiter/             # Dashboard, post-job, manage-jobs, view-job, view-applications, edit-profile
```

---

## Getting Started

### Prerequisites
- JDK 17+
- Apache Tomcat 10+ (Jakarta EE namespace — **not** Tomcat 9)
- MySQL 8+
- The four `.jar` files listed below placed in `WEB-INF/lib`

### Required JAR Files

This project does not use Maven, so you need to download these JARs manually and place them in `src/main/webapp/WEB-INF/lib/` (create the `lib` folder if it doesn't exist).

| JAR | Purpose | Download |
|---|---|---|
| `mysql-connector-j-9.x.jar` | Official JDBC driver — lets Java talk to MySQL. Without this, nothing works: no login, no job listings, no profiles. | [Maven Repository](https://mvnrepository.com/artifact/com.mysql/mysql-connector-j/9.0.0) → click **jar** in the Files row |
| `jakarta.mail-2.0.1.jar` | Provides the classes `EmailUtility.java` uses to connect to Gmail's SMTP server and send OTP emails for password resets. | [Maven Repository](https://mvnrepository.com/artifact/com.sun.mail/jakarta.mail/2.0.1) → click **jar** |
| `jakarta.activation-2.0.1.jar` | Mandatory dependency for Jakarta Mail. Handles MIME type formatting behind the scenes so your HTML emails render correctly in the recipient's inbox. | [Maven Repository](https://mvnrepository.com/artifact/com.sun.activation/jakarta.activation/2.0.1) → click **jar** |
| `jbcrypt-0.4.jar` | BCrypt library included as a standard library dependency. If you ever migrate from the current PBKDF2 implementation to BCrypt (a common upgrade), this handles automatic salting and hashing with zero extra setup. | [Maven Repository](https://mvnrepository.com/artifact/org.mindrot/jbcrypt/0.4) → click **jar** |

**How to add JARs to your IDE:**

- **Eclipse:** Right-click project → Build Path → Configure Build Path → Libraries → Add JARs → select all four from `WEB-INF/lib` → Apply.
- **IntelliJ / VS Code:** Most IDEs auto-detect JARs placed in `WEB-INF/lib` for a Dynamic Web Project. If not, right-click the `lib` folder and select "Add as Library."

### Database Setup
1. Create a database named `jobportal`
2. Run the schema SQL to create the `users`, `job_seekers`, `recruiters`, `jobs`, and `applications` tables
   > Add your `schema.sql` to the root of the repo and link it here

### Configuration

**Database:** Open `src/com/jobportal/dao/DBConnection.java` and replace the placeholder password with your local MySQL password:

```java
private static final String USER = "root";
private static final String PASSWORD = "YOUR_LOCAL_MYSQL_PASSWORD"; // ← update this
```

**Gmail OTP:** Open `src/com/jobportal/util/EmailUtility.java` and fill in your Gmail address and a [Gmail App Password](https://support.google.com/accounts/answer/185833) (this is a 16-character app-specific password, not your normal Gmail password):

```java
private static final String SENDER_EMAIL = "your_email@gmail.com";
private static final String SENDER_PASSWORD = "your_16_char_app_password";
```

### Run
1. Import as a **Dynamic Web Project** in Eclipse/IntelliJ, or configure as a Maven webapp
2. Add MySQL Connector/J and Jakarta Mail JARs to `WEB-INF/lib`
3. Deploy to Tomcat and visit `http://localhost:8080/<context-root>/`

---

## Future Enhancements

- **Ajax & Asynchronous Loading** — Instead of reloading the whole page when a job seeker filters jobs, use the JavaScript `fetch()` API to send the filter parameters to a JSON-returning servlet in the background and update only the job grid in the DOM. This makes filtering feel instant and avoids the full page flash on every search.

- **Automated Email Notifications** — When a recruiter changes an application status to **Shortlisted** or **Rejected**, automatically trigger an email to the job seeker via the existing `EmailUtility` infrastructure. The hook would live in `ApplicationDAO.updateApplicationStatus()` or the calling servlet, immediately after a successful status update.

- **Admin Dashboard** — Introduce a third role (`admin`) with a dedicated master dashboard. Admins would be able to monitor platform-wide activity (total users, jobs posted, applications submitted), deactivate or delete abusive accounts, and approve or reject recruiter company profiles before they go live — adding a trust layer between registration and public visibility.

---

## License

MIT — feel free to use this as a reference or starting point for your own projects.
