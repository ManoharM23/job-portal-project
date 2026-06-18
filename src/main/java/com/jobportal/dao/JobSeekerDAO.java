package com.jobportal.dao;

import com.jobportal.model.JobSeeker;
import java.sql.*;

public class JobSeekerDAO {
    
    public boolean createProfile(int userId) {
        String sql = "INSERT INTO job_seekers (user_id) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int getSeekerIdByUserId(int userId) {
        String sql = "SELECT seeker_id FROM job_seekers WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("seeker_id");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    public JobSeeker getJobSeekerByUserId(int userId) {
        String sql = "SELECT * FROM job_seekers WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractJobSeeker(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public JobSeeker getJobSeekerById(int seekerId) {
        String sql = "SELECT * FROM job_seekers WHERE seeker_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seekerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractJobSeeker(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateProfile(int seekerId, String skills, int experienceYears, 
                                  String education, String location, double expectedSalary) {
        String sql = "UPDATE job_seekers SET skills = ?, experience_years = ?, education = ?, " +
                     "location = ?, expected_salary = ? WHERE seeker_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, skills != null ? skills : "");
            ps.setInt(2, experienceYears);
            ps.setString(3, education != null ? education : "");
            ps.setString(4, location != null ? location : "");
            ps.setDouble(5, expectedSalary);
            ps.setInt(6, seekerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    
    public boolean updateResume(int seekerId, byte[] resumeFile, String fileName) {
        String sql = "UPDATE job_seekers SET resume_file = ?, resume_file_name = ? WHERE seeker_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (resumeFile != null) {
                ps.setBytes(1, resumeFile);
                ps.setString(2, fileName);
            } else {
                ps.setNull(1, Types.BLOB);
                ps.setNull(2, Types.VARCHAR);
            }
            ps.setInt(3, seekerId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
   
    public boolean deleteResume(int seekerId) {
        return updateResume(seekerId, null, null);
    }
    
    private JobSeeker extractJobSeeker(ResultSet rs) throws SQLException {
        JobSeeker s = new JobSeeker();
        s.setSeekerId(rs.getInt("seeker_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setSkills(rs.getString("skills"));
        s.setExperienceYears(rs.getInt("experience_years"));
        s.setEducation(rs.getString("education"));
        s.setResumePath(rs.getString("resume_path"));
        s.setLocation(rs.getString("location"));
        s.setExpectedSalary(rs.getDouble("expected_salary"));
        
        // BLOB fields
        Blob blob = rs.getBlob("resume_file");
        if (blob != null) {
            s.setResumeFile(blob.getBytes(1, (int) blob.length()));
        }
        s.setResumeFileName(rs.getString("resume_file_name"));
        
        return s;
    }
}