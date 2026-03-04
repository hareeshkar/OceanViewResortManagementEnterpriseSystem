package oceanview.test;

import oceanview.service.BillingService;
import org.junit.Before;
import org.junit.Test;
import java.math.BigDecimal;
import java.time.LocalDate;
import static org.junit.Assert.*;

/**
 * Enterprise Test Suite for Financial Business Logic.
 */
public class BillingServiceTest {

    private BillingService billingService;

    @Before
    public void setUp() {
        billingService = new BillingService();
    }

    @Test
    public void testCalculateTotalNights() {
        LocalDate arrival = LocalDate.of(2025, 10, 1);
        LocalDate departure = LocalDate.of(2025, 10, 5); // 4 nights

        long nights = billingService.calculateTotalNights(arrival, departure);
        assertEquals("Should accurately calculate 4 nights", 4, nights);
    }

    @Test
    public void testMinimumOneNightStay() {
        LocalDate arrival = LocalDate.of(2025, 10, 1);
        LocalDate departure = LocalDate.of(2025, 10, 1); // Same day departure

        long nights = billingService.calculateTotalNights(arrival, departure);
        assertEquals("Minimum stay must be enforced to 1 night", 1, nights);
    }

    @Test
    public void testFinancialCalculations() {
        // Assume Ocean Deluxe rate is 25000.00 LKR, guest stays 2 nights
        BigDecimal baseRate = new BigDecimal("25000.00");
        long nights = 2;

        // 1. Room Charge: 2 * 25000 = 50000.00
        BigDecimal roomCharge = billingService.calculateRoomCharge(nights, baseRate);
        assertEquals(new BigDecimal("50000.00"), roomCharge);

        // 2. Tax: 5% of 50000 = 2500.00
        BigDecimal tax = billingService.calculateServiceTax(roomCharge);
        assertEquals(new BigDecimal("2500.00"), tax);

        // 3. Grand Total: 50000 + 2500 = 52500.00
        BigDecimal grandTotal = billingService.calculateGrandTotal(roomCharge, tax);
        assertEquals(new BigDecimal("52500.00"), grandTotal);

        System.out.println("✅ BillingService Test PASSED: All financial BigDecimal calculations are mathematically exact.");
    }
}

