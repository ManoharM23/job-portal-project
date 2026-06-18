package com.jobportal.dao;

import com.jobportal.model.Job;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobDAO {

	public boolean postJob(Job job) {
		String sql = "INSERT INTO jobs (recruiter_id, title, description, requirements, job_type, "
				+ "location, salary_min, salary_max, skills_required, deadline, education) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, job.getRecruiterId());
			ps.setString(2, job.getTitle());
			ps.setString(3, job.getDescription());
			ps.setString(4, job.getRequirements());
			ps.setString(5, job.getJobType());
			ps.setString(6, job.getLocation());
			ps.setDouble(7, job.getSalaryMin());
			ps.setDouble(8, job.getSalaryMax());
			ps.setString(9, job.getSkillsRequired());
			ps.setString(10, job.getDeadline());
			ps.setString(11, job.getEducation()); // NEW FIELD

			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public List<Job> getAllActiveJobs() {
	    return getAllActiveJobs(1, 20);
	}
	 
	public List<Job> getAllActiveJobs(int page, int pageSize) {
	    List<Job> jobs = new ArrayList<>();
	 
	    if (page < 1) page = 1;
	    if (pageSize < 1) pageSize = 20;
	    int offset = (page - 1) * pageSize;
	 
	    String sql = "SELECT j.*, r.company_name, r.user_id FROM jobs j "
	            + "JOIN recruiters r ON j.recruiter_id = r.recruiter_id "
	            + "WHERE j.status = 'active' AND (j.deadline IS NULL OR j.deadline >= CURDATE()) "
	            + "ORDER BY j.posted_date DESC "
	            + "LIMIT ? OFFSET ?";
	 
	    try (Connection conn = DBConnection.getConnection();
	            PreparedStatement ps = conn.prepareStatement(sql)) {
	 
	        ps.setInt(1, pageSize);
	        ps.setInt(2, offset);
	 
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            jobs.add(extractJobFromResultSet(rs));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return jobs;
	}
	 

	public List<Job> getJobsByRecruiter(int recruiterId) {
		List<Job> jobs = new ArrayList<>();
		String sql = "SELECT j.*, r.company_name FROM jobs j " + "JOIN recruiters r ON j.recruiter_id = r.recruiter_id "
				+ "WHERE j.recruiter_id = ? ORDER BY j.posted_date DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, recruiterId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				jobs.add(extractJobFromResultSet(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return jobs;
	}

	public Job getJobById(int jobId) {
		String sql = "SELECT j.*, r.company_name FROM jobs j " + "JOIN recruiters r ON j.recruiter_id = r.recruiter_id "
				+ "WHERE j.job_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, jobId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return extractJobFromResultSet(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean deleteJob(int jobId, int recruiterId) {
		String sql = "DELETE FROM jobs WHERE job_id = ? AND recruiter_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, jobId);
			ps.setInt(2, recruiterId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	private Job extractJobFromResultSet(ResultSet rs) throws SQLException {
		Job job = new Job();
		job.setJobId(rs.getInt("job_id"));
		job.setRecruiterId(rs.getInt("recruiter_id"));
		job.setTitle(rs.getString("title"));
		job.setDescription(rs.getString("description"));
		job.setRequirements(rs.getString("requirements"));
		job.setJobType(rs.getString("job_type"));
		job.setLocation(rs.getString("location"));
		job.setSalaryMin(rs.getDouble("salary_min"));
		job.setSalaryMax(rs.getDouble("salary_max"));
		job.setSkillsRequired(rs.getString("skills_required"));
		job.setPostedDate(rs.getTimestamp("posted_date"));
		job.setDeadline(rs.getString("deadline"));
		job.setEducation(rs.getString("education"));
		job.setStatus(rs.getString("status"));
		job.setCompanyName(rs.getString("company_name"));
		try {
			job.setRecruiterUserId(rs.getInt("user_id"));
		} catch (SQLException e) {
		}
		return job;
	}

	public List<Job> searchJobs(String keyword, String location, String jobType) {
		List<Job> jobs = new ArrayList<>();
		StringBuilder sql = new StringBuilder("SELECT j.*, r.company_name, r.user_id FROM jobs j "
				+ "JOIN recruiters r ON j.recruiter_id = r.recruiter_id "
				+ "WHERE j.status = 'active' AND (j.deadline IS NULL OR j.deadline >= CURDATE()) ");

		// Dynamically build the query based on inputs
		if (keyword != null && !keyword.trim().isEmpty()) {
			sql.append("AND (j.title LIKE ? OR j.skills_required LIKE ? OR r.company_name LIKE ?) ");
		}
		if (location != null && !location.trim().isEmpty()) {
			sql.append("AND j.location LIKE ? ");
		}
		if (jobType != null && !jobType.trim().isEmpty() && !jobType.equals("all")) {
			sql.append("AND j.job_type = ? ");
		}

		sql.append("ORDER BY j.posted_date DESC");

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			int paramIndex = 1;

			if (keyword != null && !keyword.trim().isEmpty()) {
				String searchKeyword = "%" + keyword.trim() + "%";
				ps.setString(paramIndex++, searchKeyword);
				ps.setString(paramIndex++, searchKeyword);
				ps.setString(paramIndex++, searchKeyword);
			}
			if (location != null && !location.trim().isEmpty()) {
				ps.setString(paramIndex++, "%" + location.trim() + "%");
			}
			if (jobType != null && !jobType.trim().isEmpty() && !jobType.equals("all")) {
				ps.setString(paramIndex++, jobType);
			}

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				jobs.add(extractJobFromResultSet(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return jobs;
	}
	
	public int countActiveJobs() {
	    String sql = "SELECT COUNT(*) FROM jobs WHERE status = 'active' "
	            + "AND (deadline IS NULL OR deadline >= CURDATE())";
	    try (Connection conn = DBConnection.getConnection();
	            PreparedStatement ps = conn.prepareStatement(sql);
	            ResultSet rs = ps.executeQuery()) {
	        if (rs.next()) return rs.getInt(1);
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return 0;
	}
	 
	
	public List<Job> searchJobs(String keyword, String location, String jobType, int page, int pageSize) {
	    List<Job> jobs = new ArrayList<>();
	 
	    if (page < 1) page = 1;
	    if (pageSize < 1) pageSize = 20;
	    int offset = (page - 1) * pageSize;
	 
	    StringBuilder sql = new StringBuilder("SELECT j.*, r.company_name, r.user_id FROM jobs j "
	            + "JOIN recruiters r ON j.recruiter_id = r.recruiter_id "
	            + "WHERE j.status = 'active' AND (j.deadline IS NULL OR j.deadline >= CURDATE()) ");
	 
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        sql.append("AND (j.title LIKE ? OR j.skills_required LIKE ? OR r.company_name LIKE ?) ");
	    }
	    if (location != null && !location.trim().isEmpty()) {
	        sql.append("AND j.location LIKE ? ");
	    }
	    if (jobType != null && !jobType.trim().isEmpty() && !jobType.equals("all")) {
	        sql.append("AND j.job_type = ? ");
	    }
	 
	    sql.append("ORDER BY j.posted_date DESC LIMIT ? OFFSET ?");
	 
	    try (Connection conn = DBConnection.getConnection();
	            PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	 
	        int paramIndex = 1;
	 
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            String searchKeyword = "%" + keyword.trim() + "%";
	            ps.setString(paramIndex++, searchKeyword);
	            ps.setString(paramIndex++, searchKeyword);
	            ps.setString(paramIndex++, searchKeyword);
	        }
	        if (location != null && !location.trim().isEmpty()) {
	            ps.setString(paramIndex++, "%" + location.trim() + "%");
	        }
	        if (jobType != null && !jobType.trim().isEmpty() && !jobType.equals("all")) {
	            ps.setString(paramIndex++, jobType);
	        }
	 
	        ps.setInt(paramIndex++, pageSize);
	        ps.setInt(paramIndex++, offset);
	 
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            jobs.add(extractJobFromResultSet(rs));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return jobs;
	}
	
	public int countSearchJobs(String keyword, String location, String jobType) {
	    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM jobs j "
	            + "JOIN recruiters r ON j.recruiter_id = r.recruiter_id "
	            + "WHERE j.status = 'active' AND (j.deadline IS NULL OR j.deadline >= CURDATE()) ");
	 
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        sql.append("AND (j.title LIKE ? OR j.skills_required LIKE ? OR r.company_name LIKE ?) ");
	    }
	    if (location != null && !location.trim().isEmpty()) {
	        sql.append("AND j.location LIKE ? ");
	    }
	    if (jobType != null && !jobType.trim().isEmpty() && !jobType.equals("all")) {
	        sql.append("AND j.job_type = ? ");
	    }
	 
	    try (Connection conn = DBConnection.getConnection();
	            PreparedStatement ps = conn.prepareStatement(sql.toString())) {
	 
	        int paramIndex = 1;
	 
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            String searchKeyword = "%" + keyword.trim() + "%";
	            ps.setString(paramIndex++, searchKeyword);
	            ps.setString(paramIndex++, searchKeyword);
	            ps.setString(paramIndex++, searchKeyword);
	        }
	        if (location != null && !location.trim().isEmpty()) {
	            ps.setString(paramIndex++, "%" + location.trim() + "%");
	        }
	        if (jobType != null && !jobType.trim().isEmpty() && !jobType.equals("all")) {
	            ps.setString(paramIndex++, jobType);
	        }
	 
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) return rs.getInt(1);
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return 0;
	}
}