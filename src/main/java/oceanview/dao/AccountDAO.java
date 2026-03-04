package oceanview.dao;

import oceanview.model.SysAccount;
import oceanview.util.DatabaseFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Enterprise Data Access Object (DAO) for System Accounts.
 *
 * Responsible for securely retrieving authentication credentials from the database.
 * This class enforces the separation of concerns pattern, isolating all database
 * queries from business logic and ensuring exclusive use of PreparedStatement
 * to prevent SQL injection attacks.
 *
 * Features:
 * - PreparedStatement exclusively (SQL injection prevention)
 * - Try-with-resources for automatic connection cleanup
 * - Clean architecture with single responsibility principle
 * - Enterprise-grade error handling and logging
 *
 * @author Ocean View Resort Management System
 * @version 1.0
 */
public class AccountDAO {

    /**
     * Retrieves a system account by username to facilitate authentication.
     *
     * This method queries the ov_sys_account table using a parameterized query
     * to safely retrieve user credentials without risk of SQL injection.
     *
     * Security Features:
     * - Uses PreparedStatement with parameter binding
     * - Try-with-resources ensures connection cleanup
     * - Returns null for non-existent users (no information leakage)
     *
     * @param username The login name provided by the user during authentication
     * @return SysAccount object containing credentials if found, null if not found
     * @throws RuntimeException if a database error occurs during query execution
     */
    public SysAccount getAccountByUsername(String username) {
        String sql = "SELECT account_id, login_name, secure_hash, secure_salt, access_level " +
                     "FROM ov_sys_account WHERE login_name = ?";

        // Try-with-resources automatically closes Connection, PreparedStatement, and ResultSet
        // This prevents memory leaks and ensures proper resource management
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Bind parameter safely - prevents SQL injection
            ps.setString(1, username);

            // Execute query and process results
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Account found - populate domain object from result set
                    SysAccount account = new SysAccount();
                    account.setAccountId(rs.getInt("account_id"));
                    account.setLoginName(rs.getString("login_name"));
                    account.setSecureHash(rs.getString("secure_hash"));
                    account.setSecureSalt(rs.getString("secure_salt"));
                    account.setAccessLevel(rs.getString("access_level"));
                    return account;
                }
            }
        } catch (SQLException e) {
            // Convert checked exception to runtime exception for cleaner API
            // Allows calling code to handle or propagate as needed
            throw new RuntimeException("Database error while fetching user account: " + e.getMessage(), e);
        }

        // No matching account found - return null
        // Calling code must check for null before using the returned object
        return null;
    }

    /**
     * Retrieves a system account by account ID.
     *
     * Useful for session management and account lookup operations.
     *
     * @param accountId The unique account identifier
     * @return SysAccount object if found, null otherwise
     * @throws RuntimeException if a database error occurs
     */
    public SysAccount getAccountById(int accountId) {
        String sql = "SELECT account_id, login_name, secure_hash, secure_salt, access_level " +
                     "FROM ov_sys_account WHERE account_id = ?";

        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SysAccount account = new SysAccount();
                    account.setAccountId(rs.getInt("account_id"));
                    account.setLoginName(rs.getString("login_name"));
                    account.setSecureHash(rs.getString("secure_hash"));
                    account.setSecureSalt(rs.getString("secure_salt"));
                    account.setAccessLevel(rs.getString("access_level"));
                    return account;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database error while fetching account by ID: " + e.getMessage(), e);
        }

        return null;
    }

    /**
     * Retrieves all system accounts (admin functionality).
     *
     * Note: This method should only be called by authenticated ADMIN users.
     * Access control must be enforced at the service/servlet layer.
     *
     * @return An array of SysAccount objects, or empty array if none found
     * @throws RuntimeException if a database error occurs
     */
    public SysAccount[] getAllAccounts() {
        String sql = "SELECT account_id, login_name, secure_hash, secure_salt, access_level " +
                     "FROM ov_sys_account ORDER BY account_id";

        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            try (ResultSet rs = ps.executeQuery()) {
                // Use a temporary list to collect results
                java.util.List<SysAccount> accountList = new java.util.ArrayList<>();

                while (rs.next()) {
                    SysAccount account = new SysAccount();
                    account.setAccountId(rs.getInt("account_id"));
                    account.setLoginName(rs.getString("login_name"));
                    account.setSecureHash(rs.getString("secure_hash"));
                    account.setSecureSalt(rs.getString("secure_salt"));
                    account.setAccessLevel(rs.getString("access_level"));
                    accountList.add(account);
                }

                // Convert list to array
                return accountList.toArray(new SysAccount[0]);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database error while fetching all accounts: " + e.getMessage(), e);
        }
    }
}


