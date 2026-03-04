package oceanview.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Enterprise Cryptographic Utility for Secure Password Hashing.
 *
 * Algorithm: SHA-256
 * Pattern: Salted hashing (salt + password)
 *
 * Usage:
 *   String hash = HashProvider.computeHash("password123", "saltsalt");
 */
public class HashProvider {

    /**
     * Generates a SHA-256 hash of the password combined with a salt.
     * The salt is prepended to the password before hashing.
     *
     * @param plainPassword The user's raw password (plaintext).
     * @param salt The user's specific salt (should be random and unique per user).
     * @return Hexadecimal string representation of the SHA-256 hash.
     * @throws RuntimeException If SHA-256 algorithm is not available.
     */
    public static String computeHash(String plainPassword, String salt) {
        try {
            // Concatenate salt with password for hashing
            String input = plainPassword + salt;

            // Get SHA-256 digest instance
            MessageDigest digest = MessageDigest.getInstance("SHA-256");

            // Compute hash
            byte[] encodedHash = digest.digest(input.getBytes(StandardCharsets.UTF_8));

            // Convert to hexadecimal string
            return bytesToHex(encodedHash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 Algorithm not supported by JVM", e);
        }
    }

    /**
     * Converts a byte array to a hexadecimal string.
     * Each byte is converted to 2 hex characters.
     *
     * @param hash Byte array to convert.
     * @return Hexadecimal string (uppercase).
     */
    private static String bytesToHex(byte[] hash) {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString().toUpperCase();
    }
}

