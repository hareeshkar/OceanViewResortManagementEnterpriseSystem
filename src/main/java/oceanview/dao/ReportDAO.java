package oceanview.dao;

import oceanview.util.DatabaseFactory;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Enterprise Business Intelligence Data Access Object.
 */
public class ReportDAO {

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(grand_total_lkr), 0) as total FROM ov_billing_invoice";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal("total");
        } catch (Exception e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    public int getTotalBookingsCount() {
        String sql = "SELECT COUNT(*) as count FROM ov_reservation";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("count");
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String, Integer> getCategoryPerformance() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        String sql = "SELECT c.category_name, COUNT(r.reservation_pk) as count " +
                     "FROM ov_room_category c " +
                     "LEFT JOIN ov_accommodation a ON c.category_id = a.category_id " +
                     "LEFT JOIN ov_reservation r ON a.room_pk = r.room_pk " +
                     "GROUP BY c.category_id, c.category_name ORDER BY c.category_id ASC";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) stats.put(rs.getString("category_name"), rs.getInt("count"));
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    public List<String> getRecentAuditLogs(int limit) {
        List<String> logs = new ArrayList<>();
        String sql = "SELECT action_type, description, log_time FROM ov_audit_log ORDER BY log_time DESC LIMIT ?";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String time = rs.getTimestamp("log_time").toString().substring(0, 16);
                    logs.add("[" + time + "] " + rs.getString("action_type") + " - " + rs.getString("description"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return logs;
    }

    /**
     * Daily revenue for the last 14 days — granular enough to show real variation.
     * Falls back gracefully if no data. Key = "DD Mon" (e.g. "04 Mar"), Value = revenue.
     */
    public Map<String, BigDecimal> getDailyRevenueTrend() {
        Map<String, BigDecimal> trend = new LinkedHashMap<>();
        // Generate 14-day skeleton so chart always has shape even with gaps
        String sql =
            "SELECT DATE_FORMAT(gen.d, '%d %b') AS day_label, " +
            "       COALESCE(SUM(i.grand_total_lkr), 0) AS revenue " +
            "FROM (" +
            "  SELECT CURDATE() - INTERVAL (a.a + b.a * 10) DAY AS d " +
            "  FROM (SELECT 0 a UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 " +
            "              UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a " +
            "  CROSS JOIN (SELECT 0 a UNION SELECT 1) b " +
            "  WHERE (a.a + b.a * 10) <= 13 " +
            ") gen " +
            "LEFT JOIN ov_reservation r ON DATE(r.created_timestamp) = gen.d " +
            "LEFT JOIN ov_billing_invoice i ON r.reservation_pk = i.reservation_pk " +
            "GROUP BY gen.d " +
            "ORDER BY gen.d ASC";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                trend.put(rs.getString("day_label"), rs.getBigDecimal("revenue"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return trend;
    }

    /**
     * Per-room revenue breakdown — which room earns the most.
     * Key = "Room NNN", Value = total revenue.
     */
    public Map<String, BigDecimal> getRevenuePerRoom() {
        Map<String, BigDecimal> stats = new LinkedHashMap<>();
        String sql =
            "SELECT a.room_number, COALESCE(SUM(i.grand_total_lkr), 0) AS revenue " +
            "FROM ov_accommodation a " +
            "LEFT JOIN ov_reservation r ON a.room_pk = r.room_pk " +
            "LEFT JOIN ov_billing_invoice i ON r.reservation_pk = i.reservation_pk " +
            "GROUP BY a.room_pk, a.room_number ORDER BY revenue DESC";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) stats.put("Rm " + rs.getString("room_number"), rs.getBigDecimal("revenue"));
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    /**
     * Monthly revenue — uses created_timestamp so same-month bookings on different days show variation.
     */
    public Map<String, BigDecimal> getMonthlyRevenueTrend() {
        Map<String, BigDecimal> trend = new LinkedHashMap<>();
        String sql =
            "SELECT DATE_FORMAT(r.created_timestamp, '%b %Y') AS month_label, " +
            "       DATE_FORMAT(r.created_timestamp, '%Y-%m') AS month_sort, " +
            "       COALESCE(SUM(i.grand_total_lkr), 0) AS revenue " +
            "FROM ov_billing_invoice i " +
            "JOIN ov_reservation r ON i.reservation_pk = r.reservation_pk " +
            "GROUP BY month_sort, month_label " +
            "ORDER BY month_sort ASC";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                trend.put(rs.getString("month_label"), rs.getBigDecimal("revenue"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return trend;
    }

    /** Average revenue per booking */
    public BigDecimal getAverageBookingValue() {
        String sql = "SELECT COALESCE(AVG(grand_total_lkr), 0) FROM ov_billing_invoice";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1).setScale(2, java.math.RoundingMode.HALF_UP);
        } catch (Exception e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    /** Count bookings created today */
    public int getTodayBookingsCount() {
        String sql = "SELECT COUNT(*) FROM ov_reservation WHERE DATE(created_timestamp) = CURDATE()";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
