package oceanview.dao;

import oceanview.model.Reservation;
import oceanview.util.DatabaseFactory;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Enterprise DAO for Guest Reservations and Billing Transactions.
 */
public class ReservationDAO {

    /**
     * Inserts a reservation and its associated billing invoice within a single secure SQL Transaction.
     */
    public boolean createReservationWithInvoice(Reservation res, long nights, BigDecimal roomCharge, BigDecimal tax, BigDecimal grandTotal) {
        String insertResSql = "INSERT INTO ov_reservation (booking_ref, guest_name, contact_phone, guest_address, room_pk, arrival_date, departure_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertInvSql = "INSERT INTO ov_billing_invoice (reservation_pk, total_nights, room_charge_lkr, service_tax_lkr, grand_total_lkr) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseFactory.getConnection()) {
            // 🛡️ ENTERPRISE RULE: Begin Transaction
            conn.setAutoCommit(false);

            try (PreparedStatement psRes = conn.prepareStatement(insertResSql, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psInv = conn.prepareStatement(insertInvSql)) {

                // 1. Insert Reservation
                psRes.setString(1, res.getBookingRef());
                psRes.setString(2, res.getGuestName());
                psRes.setString(3, res.getContactPhone());
                psRes.setString(4, res.getGuestAddress());
                psRes.setInt(5, res.getRoomPk());
                psRes.setDate(6, java.sql.Date.valueOf(res.getArrivalDate()));
                psRes.setDate(7, java.sql.Date.valueOf(res.getDepartureDate()));
                psRes.executeUpdate();

                // Get the generated reservation_pk
                int reservationPk = 0;
                try (ResultSet rs = psRes.getGeneratedKeys()) {
                    if (rs.next()) {
                        reservationPk = rs.getInt(1);
                    } else {
                        throw new Exception("Failed to retrieve reservation PK.");
                    }
                }

                // 2. Insert Invoice
                psInv.setInt(1, reservationPk);
                psInv.setLong(2, nights);
                psInv.setBigDecimal(3, roomCharge);
                psInv.setBigDecimal(4, tax);
                psInv.setBigDecimal(5, grandTotal);
                psInv.executeUpdate();

                // ✅ Commit Transaction
                conn.commit();
                return true;

            } catch (Exception e) {
                // ❌ Rollback on failure to prevent partial data
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true); // Restore default state
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Fetches recent reservations joined with room and billing data.
     */
    public List<Reservation> getRecentReservations(int limit) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.reservation_pk, r.booking_ref, r.guest_name, r.arrival_date, r.departure_date, r.booking_status, " +
                     "a.room_number, i.grand_total_lkr, i.total_nights " +
                     "FROM ov_reservation r " +
                     "JOIN ov_accommodation a ON r.room_pk = a.room_pk " +
                     "JOIN ov_billing_invoice i ON r.reservation_pk = i.reservation_pk " +
                     "ORDER BY r.created_timestamp DESC LIMIT ?";

        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation res = new Reservation();
                    res.setReservationPk(rs.getInt("reservation_pk"));
                    res.setBookingRef(rs.getString("booking_ref"));
                    res.setGuestName(rs.getString("guest_name"));
                    res.setArrivalDate(rs.getDate("arrival_date").toLocalDate());
                    res.setDepartureDate(rs.getDate("departure_date").toLocalDate());
                    res.setBookingStatus(rs.getString("booking_status"));
                    res.setRoomNumber(rs.getString("room_number"));
                    res.setGrandTotal(rs.getBigDecimal("grand_total_lkr"));
                    res.setTotalNights(rs.getLong("total_nights"));
                    list.add(res);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Advanced SQL: Fetches paginated reservations for the View Bookings page.
     */
    public java.util.List<Reservation> getPaginatedReservations(int offset, int limit) {
        java.util.List<Reservation> list = new java.util.ArrayList<>();
        String sql = "SELECT r.reservation_pk, r.booking_ref, r.guest_name, r.arrival_date, r.departure_date, r.booking_status, " +
                     "a.room_number, i.grand_total_lkr, i.total_nights " +
                     "FROM ov_reservation r " +
                     "JOIN ov_accommodation a ON r.room_pk = a.room_pk " +
                     "JOIN ov_billing_invoice i ON r.reservation_pk = i.reservation_pk " +
                     "ORDER BY r.created_timestamp DESC LIMIT ? OFFSET ?";

        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation res = new Reservation();
                    res.setReservationPk(rs.getInt("reservation_pk"));
                    res.setBookingRef(rs.getString("booking_ref"));
                    res.setGuestName(rs.getString("guest_name"));
                    res.setArrivalDate(rs.getDate("arrival_date").toLocalDate());
                    res.setDepartureDate(rs.getDate("departure_date").toLocalDate());
                    res.setBookingStatus(rs.getString("booking_status"));
                    res.setRoomNumber(rs.getString("room_number"));
                    res.setGrandTotal(rs.getBigDecimal("grand_total_lkr"));
                    res.setTotalNights(rs.getLong("total_nights"));
                    list.add(res);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Fetches complete invoice data for a specific reservation PK to support printing.
     */
    public oceanview.model.InvoiceDTO getInvoiceDetails(int reservationPk) {
        String sql = "SELECT r.booking_ref, r.guest_name, r.guest_address, r.contact_phone, " +
                     "r.arrival_date, r.departure_date, r.created_timestamp, " +
                     "a.room_number, c.category_name, c.base_rate_lkr, " +
                     "i.invoice_pk, i.total_nights, i.room_charge_lkr, i.service_tax_lkr, i.grand_total_lkr " +
                     "FROM ov_reservation r " +
                     "JOIN ov_accommodation a ON r.room_pk = a.room_pk " +
                     "JOIN ov_room_category c ON a.category_id = c.category_id " +
                     "JOIN ov_billing_invoice i ON r.reservation_pk = i.reservation_pk " +
                     "WHERE r.reservation_pk = ?";

        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationPk);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    oceanview.model.InvoiceDTO dto = new oceanview.model.InvoiceDTO();
                    dto.setBookingRef(rs.getString("booking_ref"));
                    dto.setGuestName(rs.getString("guest_name"));
                    dto.setAddress(rs.getString("guest_address"));
                    dto.setPhone(rs.getString("contact_phone"));
                    dto.setArrival(rs.getDate("arrival_date").toLocalDate());
                    dto.setDeparture(rs.getDate("departure_date").toLocalDate());
                    dto.setBookingDate(rs.getTimestamp("created_timestamp").toLocalDateTime());
                    dto.setRoomNumber(rs.getString("room_number"));
                    dto.setCategoryName(rs.getString("category_name"));
                    dto.setBaseRate(rs.getBigDecimal("base_rate_lkr"));
                    dto.setInvoiceNumber("INV-" + rs.getInt("invoice_pk"));
                    dto.setNights(rs.getLong("total_nights"));
                    dto.setRoomCharge(rs.getBigDecimal("room_charge_lkr"));
                    dto.setTax(rs.getBigDecimal("service_tax_lkr"));
                    dto.setGrandTotal(rs.getBigDecimal("grand_total_lkr"));
                    return dto;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    /**
     * REDESIGN HELP: Gets the total revenue (LKR) from all billing invoices.
     */
    public BigDecimal getTotalRevenueLKR() {
        String sql = "SELECT SUM(grand_total_lkr) FROM ov_billing_invoice";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal(1);
                return total != null ? total : BigDecimal.ZERO;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    /**
     * REDESIGN HELP: Gets the count of check-ins scheduled for a specific date.
     */
    public int getCheckinCountForDate(String date) {
        String sql = "SELECT COUNT(*) FROM ov_reservation WHERE arrival_date = ?";
        try (Connection conn = DatabaseFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
