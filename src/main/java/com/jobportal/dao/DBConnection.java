package com.jobportal.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
   
    private static final String URL = "jdbc:mysql://localhost:3306/jobportal?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";      
    private static final String PASSWORD = "YOUR_MYSQL_PASSWORD_HERE";  
    
    static {
        try {
            // MySQL Connector 9.x uses com.mysql.cj.jdbc.Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            //System.out.println("MySQL Driver loaded successfully");
        } catch (ClassNotFoundException e) {
           // System.err.println("MySQL Driver NOT FOUND: " + e.getMessage());
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}