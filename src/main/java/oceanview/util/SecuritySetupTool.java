package oceanview.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.UUID;

/**
 * Enterprise Security Utility Tool.
 *
 * Purpose:
 * - Generate cryptographically secure random salts using UUID
 * - Hash passwords using SHA-256 (via HashProvider)
 * - Inject user credentials directly into the database
 *
 * Run this ONCE (after database setup) to initialize admin and staff accounts:
 * Right-click this file in IntelliJ -> Run 'SecuritySetupTool.main()'
 *
 * Credentials created:
 * - Admin: username="admin", password="admin123"
 * - Staff: username="staff", password="staff123"
 */
public class SecuritySetupTool {

    public static void main(String[] args) {
        System.out.println("════════════════════════════════════════════════════");
        System.out.println("🔒 Initializing Enterprise Security Setup");
        System.out.println("════════════════════════════════════════════════════");

        // Step 1: Generate Secure Random Salts (8 characters each)
        String adminSalt = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String staffSalt = UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // Step 2: Compute SHA-256 Hashes using Java
        String adminHash = HashProvider.computeHash("admin123", adminSalt);
        String staffHash = HashProvider.computeHash("staff123", staffSalt);

        System.out.println("\n📋 Generated Credentials:");
        System.out.println("──────────────────────────────────────────────────");
        System.out.println("ADMIN:");
        System.out.println("  Username: admin");
        System.out.println("  Password: admin123");
        System.out.println("  Salt:     " + adminSalt);
        System.out.println("  Hash:     " + adminHash);
        System.out.println("──────────────────────────────────────────────────");
        System.out.println("STAFF:");
        System.out.println("  Username: staff");
        System.out.println("  Password: staff123");
        System.out.println("  Salt:     " + staffSalt);
        System.out.println("  Hash:     " + staffHash);
        System.out.println("──────────────────────────────────────────────────");

        // Step 3: Inject directly into the Database
        try (Connection conn = DatabaseFactory.getConnection()) {

            System.out.println("\n🔄 Clearing existing accounts...");
            conn.createStatement().executeUpdate("TRUNCATE TABLE ov_sys_account");
            System.out.println("✅ Old accounts cleared");

            String sql = "INSERT INTO ov_sys_account (login_name, secure_hash, secure_salt, access_level) VALUES (?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {

                // Insert Admin Account
                System.out.println("\n🔐 Injecting ADMIN account...");
                ps.setString(1, "admin");
                ps.setString(2, adminHash);
                ps.setString(3, adminSalt);
                ps.setString(4, "ADMIN");
                ps.executeUpdate();
                System.out.println("✅ Admin account created");

                // Insert Staff Account
                System.out.println("\n🔐 Injecting STAFF account...");
                ps.setString(1, "staff");
                ps.setString(2, staffHash);
                ps.setString(3, staffSalt);
                ps.setString(4, "STAFF");
                ps.executeUpdate();
                System.out.println("✅ Staff account created");
            }

            System.out.println("\n════════════════════════════════════════════════════");
            System.out.println("✅ SUCCESS: Database updated with cryptographic hashes!");
            System.out.println("════════════════════════════════════════════════════");

        } catch (Exception e) {
            System.err.println("\n════════════════════════════════════════════════════");
            System.err.println("❌ FAILURE: Database Update Failed");
            System.err.println("════════════════════════════════════════════════════");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}

