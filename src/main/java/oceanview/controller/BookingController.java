package oceanview.controller;

import oceanview.dao.ReservationDAO;
import oceanview.model.Reservation;
import oceanview.service.BillingService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * Enterprise Controller for handling new Bookings.
 */
@WebServlet(name = "BookingController", urlPatterns = {"/staff/book-room"})
public class BookingController extends HttpServlet {

    private ReservationDAO reservationDAO;
    private BillingService billingService;

    @Override
    public void init() {
        reservationDAO = new ReservationDAO();
        billingService = new BillingService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Extract Parameters
            String guestName = request.getParameter("guestName");
            String contactPhone = request.getParameter("contactPhone");
            String guestAddress = request.getParameter("guestAddress");
            String roomPkStr = request.getParameter("roomPk");
            String baseRateStr = request.getParameter("baseRateLkr");
            String arrivalStr = request.getParameter("arrivalDate");
            String departureStr = request.getParameter("departureDate");

            // 2. 🛡️ STRICT SERVER-SIDE VALIDATION
            if (guestName == null || contactPhone == null || roomPkStr == null || arrivalStr == null) {
                throw new IllegalArgumentException("Missing required fields.");
            }
            if (!contactPhone.matches("0[0-9]{9}")) {
                throw new IllegalArgumentException("Invalid phone format. Must be 10 digits starting with 0.");
            }

            LocalDate arrivalDate = LocalDate.parse(arrivalStr);
            LocalDate departureDate = LocalDate.parse(departureStr);
            if (arrivalDate.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Arrival date cannot be in the past.");
            }
            if (!departureDate.isAfter(arrivalDate)) {
                throw new IllegalArgumentException("Departure date must be after arrival date.");
            }

            // 3. Map to Model
            Reservation res = new Reservation();
            // Generate unique reference (e.g., OVR-A1B2)
            String bookingRef = "OVR-" + UUID.randomUUID().toString().substring(0, 4).toUpperCase();

            res.setBookingRef(bookingRef);
            res.setGuestName(guestName);
            res.setContactPhone(contactPhone);
            res.setGuestAddress(guestAddress);
            res.setRoomPk(Integer.parseInt(roomPkStr));
            res.setArrivalDate(arrivalDate);
            res.setDepartureDate(departureDate);

            // 4. Billing Logic (Phase 6 Forward Thinking)
            BigDecimal baseRate = new BigDecimal(baseRateStr);
            long nights = billingService.calculateTotalNights(arrivalDate, departureDate);
            BigDecimal roomCharge = billingService.calculateRoomCharge(nights, baseRate);
            BigDecimal tax = billingService.calculateServiceTax(roomCharge);
            BigDecimal grandTotal = billingService.calculateGrandTotal(roomCharge, tax);

            // 5. Save via DAO Transaction
            boolean success = reservationDAO.createReservationWithInvoice(res, nights, roomCharge, tax, grandTotal);

            if (success) {
                response.sendRedirect("dashboard.jsp?msg=Booking " + bookingRef + " created successfully!");
            } else {
                response.sendRedirect("dashboard.jsp?error=Database error during booking.");
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect("dashboard.jsp?error=" + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=System Failure: Invalid Data Format.");
        }
    }
}
