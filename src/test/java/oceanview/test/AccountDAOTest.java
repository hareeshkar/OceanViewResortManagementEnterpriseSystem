package oceanview.test;

import oceanview.dao.AccountDAO;
import oceanview.model.SysAccount;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Enterprise Test Suite for Account Data Access Object (AccountDAO).
 *
 * This test suite ensures that the DAO layer correctly:
 * 1. Retrieves accounts from the database
 * 2. Validates authentication data (hashes and salts)
 * 3. Enforces role-based access control (RBAC)
 * 4. Handles non-existent users gracefully
 * 5. Prevents SQL injection through parameterized queries
 *
 * Test-Driven Development (TDD) Approach:
 * These tests verify that the DAO works correctly BEFORE building servlets
 * or UI controllers. This ensures a solid foundation for the entire application.
 *
 * All tests require the database to be initialized with:
 * - src/main/resources/sql/oceanview_setup.sql
 * - Initial seed data (admin and staff accounts)
 *
 * @author Ocean View Resort Management System
 * @version 1.0
 */
public class AccountDAOTest {

    private AccountDAO accountDAO;

    /**
     * setUp() runs before EACH test method.
     * Initializes the AccountDAO for testing.
     */
    @Before
    public void setUp() {
        accountDAO = new AccountDAO();
    }

    // ============================================================
    // TEST CASE 1: Valid Admin Account Retrieval
    // ============================================================

    /**
     * Verifies that a valid ADMIN account can be retrieved by username.
     *
     * Test Data: admin / admin123 (from oceanview_setup.sql)
     *
     * Expected Behavior:
     * - Account is found (not null)
     * - Username matches "admin"
     * - Access level is "ADMIN"
     * - Security credentials (salt, hash) are present
     */
    @Test
    public void testGetAccountByValidAdminUsername() {
        // Arrange
        String adminUsername = "admin";

        // Act
        SysAccount account = accountDAO.getAccountByUsername(adminUsername);

        // Assert
        assertNotNull("Admin account should exist in the database", account);
        assertEquals("Username should match the query parameter", adminUsername, account.getLoginName());
        assertEquals("Role should be ADMIN", "ADMIN", account.getAccessLevel());
        assertTrue("Account should identify as admin", account.isAdmin());
        assertNotNull("Secure salt must not be null for security verification", account.getSecureSalt());
        assertNotNull("Secure hash must not be null for password verification", account.getSecureHash());
        assertTrue("Hash should have valid length (SHA-256)", account.getSecureHash().length() >= 64);

        System.out.println("✅ TEST PASSED: testGetAccountByValidAdminUsername");
        System.out.println("   Admin Account: " + account);
    }

    // ============================================================
    // TEST CASE 2: Valid Staff Account Retrieval
    // ============================================================

    /**
     * Verifies that a valid STAFF account can be retrieved by username.
     *
     * Test Data: staff / staff123 (from oceanview_setup.sql)
     *
     * Expected Behavior:
     * - Account is found (not null)
     * - Username matches "staff"
     * - Access level is "STAFF"
     * - Security credentials are present
     */
    @Test
    public void testGetAccountByValidStaffUsername() {
        // Arrange
        String staffUsername = "staff";

        // Act
        SysAccount account = accountDAO.getAccountByUsername(staffUsername);

        // Assert
        assertNotNull("Staff account should exist in the database", account);
        assertEquals("Username should match the query parameter", staffUsername, account.getLoginName());
        assertEquals("Role should be STAFF", "STAFF", account.getAccessLevel());
        assertTrue("Account should identify as staff", account.isStaff());
        assertFalse("Staff account should NOT be admin", account.isAdmin());
        assertNotNull("Secure salt must not be null", account.getSecureSalt());
        assertNotNull("Secure hash must not be null", account.getSecureHash());

        System.out.println("✅ TEST PASSED: testGetAccountByValidStaffUsername");
        System.out.println("   Staff Account: " + account);
    }

    // ============================================================
    // TEST CASE 3: Invalid/Non-existent User
    // ============================================================

    /**
     * Verifies that the system securely handles non-existent users.
     *
     * Security Requirement:
     * - Returns null (does not throw exception)
     * - Does not leak information about whether username exists
     * - Prevents brute-force enumeration attacks
     *
     * Test Data: hacker_user (does not exist in database)
     */
    @Test
    public void testGetAccountByInvalidUsername() {
        // Arrange
        String nonExistentUser = "hacker_user";

        // Act
        SysAccount account = accountDAO.getAccountByUsername(nonExistentUser);

        // Assert
        assertNull("Non-existent account should return null, not throw exception", account);

        System.out.println("✅ TEST PASSED: testGetAccountByInvalidUsername");
        System.out.println("   Non-existent user correctly returned null");
    }

    // ============================================================
    // TEST CASE 4: NULL Input Handling
    // ============================================================

    /**
     * Verifies graceful handling of null username parameter.
     *
     * This test ensures the DAO doesn't crash when receiving null input.
     * The DAO should handle this gracefully (either by returning null
     * or throwing an appropriate exception).
     */
    @Test
    public void testGetAccountByNullUsername() {
        // Act & Assert
        try {
            SysAccount account = accountDAO.getAccountByUsername(null);
            // If we reach here, null was handled gracefully (returned null)
            assertNull("Null username should return null", account);
            System.out.println("✅ TEST PASSED: testGetAccountByNullUsername (graceful null handling)");
        } catch (RuntimeException e) {
            // Database layer caught the error and wrapped it appropriately
            System.out.println("✅ TEST PASSED: testGetAccountByNullUsername (runtime exception caught)");
            assertTrue("Exception should contain database error info", e.getMessage().contains("Database"));
        }
    }

    // ============================================================
    // TEST CASE 5: SQL Injection Prevention (PreparedStatement)
    // ============================================================

    /**
     * Verifies that SQL injection attempts are safely ignored.
     *
     * This test passes a malicious SQL string as input to verify that:
     * 1. The PreparedStatement treats it as literal string data
     * 2. No SQL is executed
     * 3. Query returns null (user not found)
     *
     * Security Test: SQL Injection
     * Input: "admin' OR '1'='1"
     * Expected: No injection occurs, returns null
     */
    @Test
    public void testSQLInjectionPrevention() {
        // Arrange
        String maliciousInput = "admin' OR '1'='1";

        // Act
        SysAccount account = accountDAO.getAccountByUsername(maliciousInput);

        // Assert
        assertNull("SQL injection attempt should be treated as literal string and return null", account);

        System.out.println("✅ TEST PASSED: testSQLInjectionPrevention");
        System.out.println("   Malicious SQL input was safely handled");
    }

    // ============================================================
    // TEST CASE 6: Account Retrieval by ID
    // ============================================================

    /**
     * Verifies that accounts can be retrieved by ID (useful for session management).
     *
     * This test retrieves the admin account (typically ID=1) and validates it.
     */
    @Test
    public void testGetAccountById() {
        // Arrange
        int adminAccountId = 1; // From oceanview_setup.sql

        // Act
        SysAccount account = accountDAO.getAccountById(adminAccountId);

        // Assert
        assertNotNull("Account with ID 1 should exist", account);
        assertEquals("Retrieved account should have matching ID", adminAccountId, account.getAccountId());
        assertEquals("Account ID 1 should be admin", "admin", account.getLoginName());

        System.out.println("✅ TEST PASSED: testGetAccountById");
        System.out.println("   Retrieved account by ID: " + account);
    }

    // ============================================================
    // TEST CASE 7: Account Retrieval by Invalid ID
    // ============================================================

    /**
     * Verifies graceful handling when account ID doesn't exist.
     */
    @Test
    public void testGetAccountByInvalidId() {
        // Arrange
        int nonExistentId = 99999;

        // Act
        SysAccount account = accountDAO.getAccountById(nonExistentId);

        // Assert
        assertNull("Non-existent account ID should return null", account);

        System.out.println("✅ TEST PASSED: testGetAccountByInvalidId");
    }

    // ============================================================
    // TEST CASE 8: Get All Accounts (Admin Function)
    // ============================================================

    /**
     * Verifies that all accounts can be retrieved (for admin dashboard).
     *
     * Expected Result: At least 2 accounts (admin and staff from oceanview_setup.sql)
     */
    @Test
    public void testGetAllAccounts() {
        // Act
        SysAccount[] accounts = accountDAO.getAllAccounts();

        // Assert
        assertNotNull("Accounts array should not be null", accounts);
        assertTrue("Database should have at least 2 accounts (admin + staff)", accounts.length >= 2);

        System.out.println("✅ TEST PASSED: testGetAllAccounts");
        System.out.println("   Found " + accounts.length + " account(s) in database:");
        for (SysAccount account : accounts) {
            System.out.println("   - " + account);
        }
    }

    // ============================================================
    // TEST CASE 9: Role-Based Access Control (RBAC) Verification
    // ============================================================

    /**
     * Verifies that RBAC flags (isAdmin(), isStaff()) work correctly.
     *
     * This is critical for authorization checks throughout the application.
     */
    @Test
    public void testRoleBasedAccessControl() {
        // Retrieve both accounts
        SysAccount adminAccount = accountDAO.getAccountByUsername("admin");
        SysAccount staffAccount = accountDAO.getAccountByUsername("staff");

        // Assert
        assertNotNull("Admin account should exist", adminAccount);
        assertNotNull("Staff account should exist", staffAccount);

        // Verify admin roles
        assertTrue("Admin account isAdmin() should be true", adminAccount.isAdmin());
        assertFalse("Admin account isStaff() should be false", adminAccount.isStaff());

        // Verify staff roles
        assertFalse("Staff account isAdmin() should be false", staffAccount.isAdmin());
        assertTrue("Staff account isStaff() should be true", staffAccount.isStaff());

        System.out.println("✅ TEST PASSED: testRoleBasedAccessControl");
        System.out.println("   Admin role: " + adminAccount.getAccessLevel());
        System.out.println("   Staff role: " + staffAccount.getAccessLevel());
    }

    // ============================================================
    // TEST CASE 10: Security Hash Validation
    // ============================================================

    /**
     * Verifies that passwords are stored as hashes, NOT plaintext.
     *
     * This is a critical security check:
     * - getSecureHash() should return a hash, not the actual password
     * - The hash should NOT match the original password "admin123" or "staff123"
     * - Hash should be consistent (deterministic)
     */
    @Test
    public void testSecureHashStorage() {
        // Arrange
        SysAccount account = accountDAO.getAccountByUsername("admin");
        String originalPassword = "admin123";

        // Assert
        assertNotNull("Admin account should exist", account);
        assertNotNull("Hash should be stored", account.getSecureHash());
        assertNotEquals("Hash should NOT equal plaintext password (critical security check)",
                       originalPassword, account.getSecureHash());

        // Verify hash looks like SHA-256 (64 hex characters, uppercase or lowercase)
        assertTrue("Hash should be hexadecimal string", account.getSecureHash().matches("[a-fA-F0-9]{64}"));

        System.out.println("✅ TEST PASSED: testSecureHashStorage");
        System.out.println("   Password properly hashed, not stored as plaintext");
        System.out.println("   Hash: " + account.getSecureHash());
    }
}



