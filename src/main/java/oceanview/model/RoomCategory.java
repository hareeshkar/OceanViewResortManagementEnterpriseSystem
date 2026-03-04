package oceanview.model;

import java.math.BigDecimal;

/**
 * Enterprise Domain Model for Room Categories/Tiers.
 *
 * Represents different room classification levels with pricing.
 * Maps to database table: ov_room_category
 *
 * CRITICAL RULE: Uses java.math.BigDecimal EXCLUSIVELY for currency values.
 * This ensures precision in financial calculations and prevents floating-point
 * arithmetic errors that are unacceptable in enterprise systems.
 *
 * @author Ocean View Resort Management System
 * @version 1.0
 */
public class RoomCategory {
    private int categoryId;
    private String categoryName;
    private BigDecimal baseRateLkr; // STRICT REQUIREMENT: BigDecimal for currency (LKR = Sri Lankan Rupees)
    private String description;

    /**
     * Default constructor - initializes empty RoomCategory.
     */
    public RoomCategory() {}

    /**
     * Full constructor for creating a complete RoomCategory.
     *
     * @param categoryId The unique category identifier
     * @param categoryName The category display name (e.g., "Standard", "Luxury")
     * @param baseRateLkr The base nightly rate in LKR as BigDecimal
     * @param description The category description
     */
    public RoomCategory(int categoryId, String categoryName, BigDecimal baseRateLkr, String description) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.baseRateLkr = baseRateLkr;
        this.description = description;
    }

    /**
     * Gets the unique category identifier.
     * @return The category ID
     */
    public int getCategoryId() {
        return categoryId;
    }

    /**
     * Sets the category identifier.
     * @param categoryId The category ID to set
     */
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    /**
     * Gets the category name.
     * @return The category name (e.g., "Standard", "Luxury")
     */
    public String getCategoryName() {
        return categoryName;
    }

    /**
     * Sets the category name.
     * @param categoryName The category name to set
     */
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    /**
     * Gets the base nightly rate in LKR.
     * IMPORTANT: Always returns BigDecimal for precise currency handling.
     *
     * @return The base rate as BigDecimal
     */
    public BigDecimal getBaseRateLkr() {
        return baseRateLkr;
    }

    /**
     * Sets the base nightly rate in LKR.
     * IMPORTANT: Must be provided as BigDecimal for precision.
     *
     * @param baseRateLkr The rate to set as BigDecimal
     */
    public void setBaseRateLkr(BigDecimal baseRateLkr) {
        this.baseRateLkr = baseRateLkr;
    }

    /**
     * Gets the category description.
     * @return The description text
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets the category description.
     * @param description The description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "RoomCategory{" +
                "categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", baseRateLkr=" + baseRateLkr +
                ", description='" + description + '\'' +
                '}';
    }
}

