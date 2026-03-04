package oceanview.dao;

import oceanview.model.Accommodation;
import oceanview.util.DatabaseFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Enterprise DAO for Room Availability.
 */
public class AccommodationDAO {

    /**
     * Finds all available rooms for a specific date range.
     * Prevents overlapping bookings using advanced SQL subqueries.
     */
    public List<Accommodation> getAvailableRooms(LocalDate arrival, LocalDate departure) {
        List<Accommodation> availableRooms = new ArrayList<>();

        // Advanced SQL: Select rooms that DO NOT have an overlapping CONFIRMED or CHECKED_IN reservation
        String sql = "SELECT a.room_pk, a.room_number, a.category_id, a.operational_status, " +
                     "c.category_name, c.base_rate_lkr " +
                     "FROM ov_accommodation a " +
                     "JOIN ov_room_category c ON a.category_id = c.category_id " +
                     "WHERE a.operational_status = 'AVAILABLE' " +
                     "AND a.room_pk NOT IN (" +
                     "    SELECT room_pk FROM ov_reservation " +
                     "    WHERE booking_status IN ('CONFIRMED', 'CHECKED_IN') " +
                     "    AND (arrival_date < ? AND departure_date > ?)" +
                     ") ORDER BY a.room_number ASC";

        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Convert java.time.LocalDate to java.sql.Date for JDBC
            ps.setDate(1, java.sql.Date.valueOf(departure));
            ps.setDate(2, java.sql.Date.valueOf(arrival));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Accommodation room = new Accommodation();
                    room.setRoomPk(rs.getInt("room_pk"));
                    room.setRoomNumber(rs.getString("room_number"));
                    room.setCategoryId(rs.getInt("category_id"));
                    room.setOperationalStatus(rs.getString("operational_status"));
                    room.setCategoryName(rs.getString("category_name"));
                    room.setBaseRateLkr(rs.getBigDecimal("base_rate_lkr")); // Strict BigDecimal mapping
                    availableRooms.add(room);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching available rooms.", e);
        }
        return availableRooms;
    }
}

