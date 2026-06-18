package com.jobportal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jobportal.model.Recruiter;

public class RecruiterDAO {

	public Recruiter getRecruiterByUserId(int userId) {
		String sql = "SELECT * FROM recruiters WHERE user_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				Recruiter r = new Recruiter();
				r.setRecruiterId(rs.getInt("recruiter_id"));
				r.setUserId(rs.getInt("user_id"));
				r.setCompanyName(rs.getString("company_name"));
				r.setCompanyDescription(rs.getString("company_description"));
				r.setIndustry(rs.getString("industry"));
				r.setLocation(rs.getString("location"));
				r.setWebsite(rs.getString("website"));
				return r;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean createProfile(int userId, String companyName) {
		String sql = "INSERT INTO recruiters (user_id, company_name) VALUES (?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);
			ps.setString(2, companyName);

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			//System.err.println("RecruiterDAO Error: " + e.getMessage());
			e.printStackTrace();
		}
		return false;
	}

	public int getRecruiterIdByUserId(int userId) {
		String sql = "SELECT recruiter_id FROM recruiters WHERE user_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt("recruiter_id");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}

	public boolean updateProfile(int recruiterId, String companyName, String industry, String location, String website,
			String companyDescription) {
		String sql = "UPDATE recruiters SET company_name = ?, industry = ?, location = ?, "
				+ "website = ?, company_description = ? WHERE recruiter_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, companyName);
			ps.setString(2, industry != null ? industry : "");
			ps.setString(3, location != null ? location : "");
			ps.setString(4, website != null ? website : "");
			ps.setString(5, companyDescription != null ? companyDescription : "");
			ps.setInt(6, recruiterId);

			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			//System.err.println("Recruiter update error: " + e.getMessage());
			e.printStackTrace();
		}
		return false;
	}
}