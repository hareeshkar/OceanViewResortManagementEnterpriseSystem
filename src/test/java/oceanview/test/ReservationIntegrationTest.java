package oceanview.test;

import oceanview.dao.ReservationDAO;
import oceanview.model.Reservation;
import org.junit.Test;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import static org.junit.Assert.*;

public class ReservationIntegrationTest {

    @Test
    public void testFullBookingTransaction() {
        ReservationDAO dao = new ReservationDAO();

        // 1. Create dummy reservation
        Reservation res = new Reservation();
        String ref = "TEST-" + UUID.randomUUID().toString().substring(0,4);
        res.setBookingRef(ref);
        res.setGuestName("JUnit Tester");
        res.setContactPhone("0771112223");
        res.setGuestAddress("JUnit Lab");
        res.setRoomPk(1); // Room 101
        res.setArrivalDate(LocalDate.now().plusDays(10));
        res.setDepartureDate(LocalDate.now().plusDays(12));

        // 2. Mock Billing Data
        long nights = 2;
        BigDecimal charge = new BigDecimal("30000.00");
        BigDecimal tax = new BigDecimal("1500.00");
        BigDecimal total = new BigDecimal("31500.00");

        // 3. Execute Transaction
        boolean success = dao.createReservationWithInvoice(res, nights, charge, tax, total);

        assertTrue("Transaction should commit successfully", success);
        System.out.println("✅ Transaction Test: Reservation " + ref + " written to DB.");
    }
}
