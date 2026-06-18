package com.jobportal.model;

import java.sql.Timestamp;

public class Application {
	private int applicationId;
	private int jobId;
	private int seekerId;
	private Timestamp appliedDate;
	private String status;
	private String coverLetter;
	private byte[] resumeFile;

	private boolean useProfileResume;

	// Getters and Setters
	public int getApplicationId() {
		return applicationId;
	}

	public void setApplicationId(int applicationId) {
		this.applicationId = applicationId;
	}

	public int getJobId() {
		return jobId;
	}

	public void setJobId(int jobId) {
		this.jobId = jobId;
	}

	public int getSeekerId() {
		return seekerId;
	}

	public void setSeekerId(int seekerId) {
		this.seekerId = seekerId;
	}

	public Timestamp getAppliedDate() {
		return appliedDate;
	}

	public void setAppliedDate(Timestamp appliedDate) {
		this.appliedDate = appliedDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getCoverLetter() {
		return coverLetter;
	}

	public void setCoverLetter(String coverLetter) {
		this.coverLetter = coverLetter;
	}

	public byte[] getResumeFile() {
		return resumeFile;
	}

	public void setResumeFile(byte[] resumeFile) {
		this.resumeFile = resumeFile;
	}

	// NEW
	public boolean isUseProfileResume() {
		return useProfileResume;
	}

	public void setUseProfileResume(boolean useProfileResume) {
		this.useProfileResume = useProfileResume;
	}

	// Joined fields
	private String jobTitle;
	private String companyName;
	private String seekerName;

	public String getJobTitle() {
		return jobTitle;
	}

	public void setJobTitle(String jobTitle) {
		this.jobTitle = jobTitle;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getSeekerName() {
		return seekerName;
	}

	public void setSeekerName(String seekerName) {
		this.seekerName = seekerName;
	}
}