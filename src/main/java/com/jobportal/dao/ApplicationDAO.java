package com.jobportal.dao;

import com.jobportal.model.Application;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

	public boolean applyForJob(Application application) {
		String sql = "INSERT INTO applications (job_id, seeker_id, cover_letter, resume_file) VALUES (?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, application.getJobId());
			ps.setInt(2, application.getSeekerId());
			ps.setString(3, application.getCoverLetter());

			if (application.getResumeFile() != null) {
				ps.setBytes(4, application.getResumeFile());
			} else {
				ps.setNull(4, Types.BLOB);
			}

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			if (e.getMessage().contains("Duplicate entry")) {
				return false;
			}
			e.printStackTrace();
		}
		return false;
	}

	public boolean hasAlreadyApplied(int jobId, int seekerId) {
		String sql = "SELECT application_id FROM applications WHERE job_id = ? AND seeker_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, jobId);
			ps.setInt(2, seekerId);
			ResultSet rs = ps.executeQuery();
			return rs.next();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public List<Application> getApplicationsBySeeker(int seekerId) {
		List<Application> applications = new ArrayList<>();
		String sql = "SELECT a.*, j.title as job_title, r.company_name " + "FROM applications a "
				+ "JOIN jobs j ON a.job_id = j.job_id " + "JOIN recruiters r ON j.recruiter_id = r.recruiter_id "
				+ "WHERE a.seeker_id = ? ORDER BY a.applied_date DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, seekerId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				applications.add(extractApplication(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return applications;
	}

	public List<Application> getApplicationsByRecruiter(int recruiterId) {
		List<Application> applications = new ArrayList<>();
		String sql = "SELECT a.*, j.title as job_title, u.full_name as seeker_name " + "FROM applications a "
				+ "JOIN jobs j ON a.job_id = j.job_id " + "JOIN job_seekers js ON a.seeker_id = js.seeker_id "
				+ "JOIN users u ON js.user_id = u.user_id " + "WHERE j.recruiter_id = ? ORDER BY a.applied_date DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, recruiterId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				applications.add(extractApplication(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return applications;
	}

	public Application getApplicationById(int applicationId) {
		String sql = "SELECT a.* FROM applications a WHERE a.application_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, applicationId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return extractApplication(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	private Application extractApplication(ResultSet rs) throws SQLException {
		Application app = new Application();
		app.setApplicationId(rs.getInt("application_id"));
		app.setJobId(rs.getInt("job_id"));
		app.setSeekerId(rs.getInt("seeker_id"));
		app.setAppliedDate(rs.getTimestamp("applied_date"));
		app.setStatus(rs.getString("status"));
		app.setCoverLetter(rs.getString("cover_letter"));

		Blob blob = rs.getBlob("resume_file");
		if (blob != null) {
			app.setResumeFile(blob.getBytes(1, (int) blob.length()));
		}

		try {
			app.setJobTitle(rs.getString("job_title"));
		} catch (SQLException e) {
		}
		try {
			app.setCompanyName(rs.getString("company_name"));
		} catch (SQLException e) {
		}
		try {
			app.setSeekerName(rs.getString("seeker_name"));
		} catch (SQLException e) {
		}

		return app;
	}

	public List<Application> getApplicationsByJobId(int jobId) {
		List<Application> applications = new ArrayList<>();
		String sql = "SELECT a.*, u.full_name as seeker_name " + "FROM applications a "
				+ "JOIN job_seekers js ON a.seeker_id = js.seeker_id " + "JOIN users u ON js.user_id = u.user_id "
				+ "WHERE a.job_id = ? ORDER BY a.applied_date DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, jobId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				applications.add(extractApplication(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return applications;
	}

	public boolean updateApplicationStatus(int applicationId, String status, int recruiterId) {
		String sql = "UPDATE applications a " + "JOIN jobs j ON a.job_id = j.job_id " + "SET a.status = ? "
				+ "WHERE a.application_id = ? AND j.recruiter_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, applicationId);
			ps.setInt(3, recruiterId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
}