package com.jobportal.model;

import java.sql.Timestamp;

public class Job {
	private int jobId;
	private int recruiterId;
	private String title;
	private String description;
	private String requirements;
	private String jobType;
	private String location;
	private double salaryMin;
	private double salaryMax;
	private String skillsRequired;
	private Timestamp postedDate;
	private String deadline;
	private String status;
	private String companyName;
	private String education;
	private int recruiterUserId;

	public int getRecruiterUserId() {
		return recruiterUserId;
	}

	public void setRecruiterUserId(int recruiterUserId) {
		this.recruiterUserId = recruiterUserId;
	}

	public String getEducation() {
		return education;
	}

	public void setEducation(String education) {
		this.education = education;
	}

	public Job() {
	}

	// Getters and Setters for all fields
	public int getJobId() {
		return jobId;
	}

	public void setJobId(int jobId) {
		this.jobId = jobId;
	}

	public int getRecruiterId() {
		return recruiterId;
	}

	public void setRecruiterId(int recruiterId) {
		this.recruiterId = recruiterId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getRequirements() {
		return requirements;
	}

	public void setRequirements(String requirements) {
		this.requirements = requirements;
	}

	public String getJobType() {
		return jobType;
	}

	public void setJobType(String jobType) {
		this.jobType = jobType;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public double getSalaryMin() {
		return salaryMin;
	}

	public void setSalaryMin(double salaryMin) {
		this.salaryMin = salaryMin;
	}

	public double getSalaryMax() {
		return salaryMax;
	}

	public void setSalaryMax(double salaryMax) {
		this.salaryMax = salaryMax;
	}

	public String getSkillsRequired() {
		return skillsRequired;
	}

	public void setSkillsRequired(String skillsRequired) {
		this.skillsRequired = skillsRequired;
	}

	public Timestamp getPostedDate() {
		return postedDate;
	}

	public void setPostedDate(Timestamp postedDate) {
		this.postedDate = postedDate;
	}

	public String getDeadline() {
		return deadline;
	}

	public void setDeadline(String deadline) {
		this.deadline = deadline;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
}