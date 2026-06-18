package com.jobportal.dao;

import com.jobportal.model.User;
import com.jobportal.util.PasswordHash;
import java.sql.*;

public class UserDAO {
    
    private String lastError = "";
    
    public String getLastError() { return lastError; }
    
    public User validateUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND status = 'active'";
        User user = null;
        lastError = "";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password");
                
                if (PasswordHash.checkPassword(password, storedHash)) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setFullName(rs.getString("full_name"));
                    user.setPhone(rs.getString("phone"));
                    user.setStatus(rs.getString("status"));
             
                    java.sql.Blob blob = rs.getBlob("profile_picture");
                    if (blob != null) {
                        user.setProfilePicture(blob.getBytes(1, (int) blob.length()));
                    }
                } else {
                    lastError = "Password mismatch";
                }
            } else {
                lastError = "User not found";
            }
        } catch (SQLException e) {
            lastError = "SQL Error in validateUser: " + e.getMessage();
            e.printStackTrace();
        }
        return user;
    }
    
    public int registerUser(User user) {
        String sql = "INSERT INTO users (email, password, role, full_name, phone) VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;
        lastError = "";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            String hashedPassword = PasswordHash.hashPassword(user.getPassword());
            
            ps.setString(1, user.getEmail());
            ps.setString(2, hashedPassword);
            ps.setString(3, user.getRole());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getPhone());
            
            int affectedRows = ps.executeUpdate();
            //System.out.println("Affected rows: " + affectedRows);
            
            if (affectedRows == 0) {
                lastError = "Insert failed, no rows affected.";
                return -1;
            }
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);
             //   System.out.println("Generated user_id: " + generatedId);
            } else {
                lastError = "Insert succeeded but no ID returned.";
            }
            
        } catch (SQLException e) {
            lastError = "SQL Exception: " + e.getMessage();
           // System.err.println("REGISTER ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return generatedId;
    }
    
    public boolean emailExists(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            lastError = "emailExists error: " + e.getMessage();
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateUser(int userId, String fullName, String phone) {
        String sql = "UPDATE users SET full_name = ?, phone = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setStatus(rs.getString("status"));
            
                java.sql.Blob blob = rs.getBlob("profile_picture");
                if (blob != null) {
                    u.setProfilePicture(blob.getBytes(1, (int) blob.length()));
                }
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateProfilePicture(int userId, byte[] imageBytes) {
        String sql = "UPDATE users SET profile_picture = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBytes(1, imageBytes);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
 // Method 1: Save the generated token to the user's account
    public boolean saveResetToken(String email, String token) {
        String query = "UPDATE users SET reset_token = ?, token_expiry = DATE_ADD(NOW(), INTERVAL 15 MINUTE) WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, token);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean resetUserPassword(String email, String otp, String newPassword) {
        // The query checks the email, the token, AND ensures the token_expiry is still in the future
        String query = "UPDATE users SET password = ?, reset_token = NULL, token_expiry = NULL WHERE email = ? AND reset_token = ? AND token_expiry > NOW()";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setString(1, newPassword);
            ps.setString(2, email);
            ps.setString(3, otp);
            
            // executeUpdate() returns the number of rows changed. If it's 1, it was successful!
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean changePassword(String email, String oldHashedPassword, String newHashedPassword) {
        // This query ensures the password only updates if the current password provided is correct
        String query = "UPDATE users SET password = ? WHERE email = ? AND password = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setString(1, newHashedPassword);
            ps.setString(2, email);
            ps.setString(3, oldHashedPassword);
            
            // If it returns 1, the old password matched and the new one was saved!
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateOnlyPassword(String email, String newHashedPassword) {
        String query = "UPDATE users SET password = ? WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setString(1, newHashedPassword);
            ps.setString(2, email);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}