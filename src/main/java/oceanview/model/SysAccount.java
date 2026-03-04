package oceanview.model;

/**
 * Enterprise Domain Model for System Accounts.
 * Handles Role-Based Access Control (RBAC) data.
 *
 * Maps to database table: ov_sys_account
 *
 * @author Ocean View Resort Management System
 * @version 1.0
 */
public class SysAccount {
    private int accountId;
    private String loginName;
    private String secureHash;
    private String secureSalt;
    private String accessLevel; // "ADMIN" or "STAFF"

    /**
     * Default constructor - initializes empty SysAccount.
     */
    public SysAccount() {}

    /**
     * Full constructor for creating a complete SysAccount.
     *
     * @param accountId The unique account identifier
     * @param loginName The unique login username
     * @param secureHash The salted SHA-256 hash of the password
     * @param secureSalt The cryptographic salt for hashing
     * @param accessLevel The role level ("ADMIN" or "STAFF")
     */
    public SysAccount(int accountId, String loginName, String secureHash,
                     String secureSalt, String accessLevel) {
        this.accountId = accountId;
        this.loginName = loginName;
        this.secureHash = secureHash;
        this.secureSalt = secureSalt;
        this.accessLevel = accessLevel;
    }

    /**
     * Gets the unique account identifier.
     * @return The account ID
     */
    public int getAccountId() {
        return accountId;
    }

    /**
     * Sets the account identifier.
     * @param accountId The account ID to set
     */
    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    /**
     * Gets the login username.
     * @return The login name
     */
    public String getLoginName() {
        return loginName;
    }

    /**
     * Sets the login username.
     * @param loginName The login name to set
     */
    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }

    /**
     * Gets the secure password hash.
     * @return The SHA-256 hash of password with salt
     */
    public String getSecureHash() {
        return secureHash;
    }

    /**
     * Sets the secure password hash.
     * @param secureHash The hash to set
     */
    public void setSecureHash(String secureHash) {
        this.secureHash = secureHash;
    }

    /**
     * Gets the cryptographic salt.
     * @return The salt used for hashing
     */
    public String getSecureSalt() {
        return secureSalt;
    }

    /**
     * Sets the cryptographic salt.
     * @param secureSalt The salt to set
     */
    public void setSecureSalt(String secureSalt) {
        this.secureSalt = secureSalt;
    }

    /**
     * Gets the access level/role.
     * @return The access level ("ADMIN" or "STAFF")
     */
    public String getAccessLevel() {
        return accessLevel;
    }

    /**
     * Sets the access level/role.
     * @param accessLevel The access level to set
     */
    public void setAccessLevel(String accessLevel) {
        this.accessLevel = accessLevel;
    }

    /**
     * Determines if this account has administrator privileges.
     * @return true if access level is ADMIN, false otherwise
     */
    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.accessLevel);
    }

    /**
     * Determines if this account has staff privileges.
     * @return true if access level is STAFF, false otherwise
     */
    public boolean isStaff() {
        return "STAFF".equalsIgnoreCase(this.accessLevel);
    }

    @Override
    public String toString() {
        return "SysAccount{" +
                "accountId=" + accountId +
                ", loginName='" + loginName + '\'' +
                ", accessLevel='" + accessLevel + '\'' +
                '}';
    }
}

