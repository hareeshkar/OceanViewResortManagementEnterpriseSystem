package oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Enterprise Database Connection Factory.
 * Implements Singleton Pattern to manage DB resources efficiently.
 *
 * Usage: Connection conn = DatabaseFactory.getConnection();
 */
public class DatabaseFactory {

    // Database Configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/oceanview_management_enterprice_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = ""; // ⚠️ CHANGE THIS to your MySQL password

    /**
     * Static initializer block to load MySQL JDBC driver.
     * Executes once when the class is first loaded.
     */
    static {
        try {
            // Explicitly load MySQL driver for Tomcat 9 / Java 11 compatibility
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("CRITICAL: MySQL Driver not found in classpath!", e);
        }
    }

    /**
     * Factory method to obtain a database connection.
     * @return A new Connection object to the oceanview database.
     * @throws SQLException If connection fails.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
}

