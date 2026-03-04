package oceanview.model;

import java.math.BigDecimal;

/**
 * Enterprise Domain Model for Physical Rooms.
 * Includes joined data from RoomCategory for convenience.
 */
public class Accommodation {
    private int roomPk;
    private String roomNumber;
    private int categoryId;
    private String operationalStatus;

    // Joined details from ov_room_category
    private String categoryName;
    private BigDecimal baseRateLkr;

    // Getters and Setters
    public int getRoomPk() { return roomPk; }
    public void setRoomPk(int roomPk) { this.roomPk = roomPk; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getOperationalStatus() { return operationalStatus; }
    public void setOperationalStatus(String operationalStatus) { this.operationalStatus = operationalStatus; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public BigDecimal getBaseRateLkr() { return baseRateLkr; }
    public void setBaseRateLkr(BigDecimal baseRateLkr) { this.baseRateLkr = baseRateLkr; }
}

