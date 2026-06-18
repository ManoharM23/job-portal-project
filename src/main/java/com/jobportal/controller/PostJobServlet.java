package com.jobportal.controller;

import java.io.IOException;

import com.jobportal.dao.JobDAO;
import com.jobportal.model.Job;
import com.jobportal.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/recruiter/post-job")
public class PostJobServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");

		if (user == null || !"recruiter".equals(user.getRole())) {
			response.sendRedirect("../login.jsp");
			return;
		}

		// Safely get recruiter_id
		int recruiterId = (int) session.getAttribute("recruiterId");

		Job job = new Job();
		job.setRecruiterId(recruiterId);
		job.setTitle(request.getParameter("title"));
		job.setDescription(request.getParameter("description"));
		job.setRequirements(request.getParameter("requirements"));
		job.setJobType(request.getParameter("jobType"));
		job.setLocation(request.getParameter("location"));

		try {
			job.setSalaryMin(Double.parseDouble(request.getParameter("salaryMin")));
			job.setSalaryMax(Double.parseDouble(request.getParameter("salaryMax")));
		} catch (NumberFormatException e) {
			job.setSalaryMin(0);
			job.setSalaryMax(0);
		}

		job.setSkillsRequired(request.getParameter("skillsRequired"));
		job.setDeadline(request.getParameter("deadline"));
		job.setEducation(request.getParameter("education")); 

		JobDAO jobDAO = new JobDAO();

		
		if (jobDAO.postJob(job)) {
			response.sendRedirect("post-job.jsp?msg=success");
		} else {
			response.sendRedirect("post-job.jsp?error=error");
		}
	}
}