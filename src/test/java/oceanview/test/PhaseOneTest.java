package oceanview.test;

import oceanview.util.DatabaseFactory;
import oceanview.util.HashProvider;
import org.junit.Test;

import java.sql.Connection;

import static org.junit.Assert.*;

/**
 * Phase 1 Integration Test Suite
 *
 * Tests:
 * 1. Database connectivity
 * 2. SHA-256 hash generation
 * 3. Salt generation and verification
 */
public class PhaseOneTest {

    /**
     * Test 1: Verify database connection is successful
     */
    @Test
    public void testDatabaseConnection() {
        try (Connection conn = DatabaseFactory.getConnection()) {
            assertNotNull("Connection should not be null", conn);
            System.out.println("✅ Test PASSED: Database Connected Successfully!");
        } catch (Exception e) {
            fail("❌ Test FAILED: Database Connection Error - " + e.getMessage());
        }
    }

    /**
     * Test 2: Verify SHA-256 hash generation with known values
     * Uses test vectors from the setup script
     */
    @Test
    public void testHashingWithAdminCredentials() {
        // Original test salt and expected hash from security setup
        String testSalt = "A1B2C3D4";
        String plainPassword = "admin123";
        String expectedHash = "6FCD8C198A80B4AF659461894503A25E71B9B0F5F2BEACE61BCE8063C6798C2C";

        String computedHash = HashProvider.computeHash(plainPassword, testSalt);

        assertEquals("Admin hash should match expected value", expectedHash, computedHash);
        System.out.println("✅ Test PASSED: Admin Hash Verified!");
        System.out.println("   Input: " + plainPassword + " + " + testSalt);
        System.out.println("   Output: " + computedHash);
    }

    /**
     * Test 3: Verify SHA-256 hash generation for staff account
     */
    @Test
    public void testHashingWithStaffCredentials() {
        // Original test salt and expected hash from security setup
        String testSalt = "X9Y8Z7W6";
        String plainPassword = "staff123";
        String expectedHash = "A40F828DDEED1B2CC942CA6E3573D33024531E7B6BC75CA3FBC657A49F349C13";

        String computedHash = HashProvider.computeHash(plainPassword, testSalt);

        assertEquals("Staff hash should match expected value", expectedHash, computedHash);
        System.out.println("✅ Test PASSED: Staff Hash Verified!");
        System.out.println("   Input: " + plainPassword + " + " + testSalt);
        System.out.println("   Output: " + computedHash);
    }

    /**
     * Test 4: Verify that different salts produce different hashes
     */
    @Test
    public void testHashConsistency() {
        String password = "testPassword123";
        String salt1 = "SALT1234";
        String salt2 = "SALT5678";

        String hash1 = HashProvider.computeHash(password, salt1);
        String hash2 = HashProvider.computeHash(password, salt2);

        // Same password with different salts should produce different hashes
        assertNotEquals("Different salts should produce different hashes", hash1, hash2);
        System.out.println("✅ Test PASSED: Hash Consistency Verified!");
        System.out.println("   Hash 1: " + hash1);
        System.out.println("   Hash 2: " + hash2);
    }

    /**
     * Test 5: Verify that same input always produces same hash
     */
    @Test
    public void testHashDeterminism() {
        String password = "deterministicTest";
        String salt = "FIXEDSALT";

        String hash1 = HashProvider.computeHash(password, salt);
        String hash2 = HashProvider.computeHash(password, salt);

        // Same input should always produce same hash
        assertEquals("Same input should always produce same hash", hash1, hash2);
        System.out.println("✅ Test PASSED: Hash Determinism Verified!");
        System.out.println("   Hash: " + hash1);
    }
}


