package com.jobportal.model;

public class User {
	private int userId;
	private String email;
	private String password;
	private String role;
	private String fullName;
	private String phone;
	private String status;
	private byte[] profilePicture;

	public byte[] getProfilePicture() {
		return profilePicture;
	}

	public void setProfilePicture(byte[] profilePicture) {
		this.profilePicture = profilePicture;
	}

	// Constructors
	public User() {
	}

	public User(int userId, String email, String role, String fullName, String phone, String status) {
		this.userId = userId;
		this.email = email;
		this.role = role;
		this.fullName = fullName;
		this.phone = phone;
		this.status = status;
	}

	// Getters and Setters
	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}