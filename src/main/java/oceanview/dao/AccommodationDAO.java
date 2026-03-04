package oceanview.dao;

import oceanview.model.Accommodation;
import oceanview.model.RoomCategory;
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

    /**
     * Fetches all Room Categories to populate the frontend dropdown.
     */
    public List<RoomCategory> getAllCategories() {
        List<RoomCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM ov_room_category ORDER BY base_rate_lkr ASC";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomCategory cat = new RoomCategory();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setCategoryName(rs.getString("category_name"));
                cat.setBaseRateLkr(rs.getBigDecimal("base_rate_lkr"));
                categories.add(cat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Advanced SQL: Fetches all rooms for a specific category and dynamically calculates
     * if they are AVAILABLE, BOOKED, or in MAINTENANCE for the requested dates.
     */
    public List<Accommodation> getRoomsWithCalculatedStatus(LocalDate arrival, LocalDate departure, int categoryId) {
        List<Accommodation> rooms = new ArrayList<>();

        String sql = "SELECT a.room_pk, a.room_number, a.operational_status, c.base_rate_lkr, " +
                     "CASE " +
                     "  WHEN a.operational_status = 'MAINTENANCE' THEN 'MAINTENANCE' " +
                     "  WHEN EXISTS ( " +
                     "      SELECT 1 FROM ov_reservation r " +
                     "      WHERE r.room_pk = a.room_pk " +
                     "      AND r.booking_status IN ('CONFIRMED', 'CHECKED_IN') " +
                     "      AND (r.arrival_date < ? AND r.departure_date > ?) " +
                     "  ) THEN 'BOOKED' " +
                     "  ELSE 'AVAILABLE' " +
                     "END AS calculated_status " +
                     "FROM ov_accommodation a " +
                     "JOIN ov_room_category c ON a.category_id = c.category_id " +
                     "WHERE a.category_id = ? ORDER BY a.room_number";

        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(departure));
            ps.setDate(2, java.sql.Date.valueOf(arrival));
            ps.setInt(3, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Accommodation room = new Accommodation();
                    room.setRoomPk(rs.getInt("room_pk"));
                    room.setRoomNumber(rs.getString("room_number"));
                    room.setBaseRateLkr(rs.getBigDecimal("base_rate_lkr"));
                    room.setCalculatedStatus(rs.getString("calculated_status"));
                    rooms.add(room);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
}
