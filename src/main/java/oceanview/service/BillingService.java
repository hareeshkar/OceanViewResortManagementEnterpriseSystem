package oceanview.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * Enterprise Business Logic Layer for Financial Operations.
 * STRICT RULE: All calculations use java.math.BigDecimal.
 */
public class BillingService {

    private static final BigDecimal TAX_RATE = new BigDecimal("0.05"); // 5% Service Tax

    /**
     * Calculates the number of nights. Enforces a minimum of 1 night.
     */
    public long calculateTotalNights(LocalDate arrivalDate, LocalDate departureDate) {
        long nights = ChronoUnit.DAYS.between(arrivalDate, departureDate);
        return nights < 1 ? 1 : nights; // Minimum stay is 1 night
    }

    /**
     * Calculates the base room charge (Nights * Base Rate).
     */
    public BigDecimal calculateRoomCharge(long nights, BigDecimal baseRateLkr) {
        BigDecimal totalNights = new BigDecimal(nights);
        return baseRateLkr.multiply(totalNights).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculates exactly 5% service tax on the room charge.
     */
    public BigDecimal calculateServiceTax(BigDecimal roomChargeLkr) {
        return roomChargeLkr.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculates the Grand Total (Room Charge + Tax).
     */
    public BigDecimal calculateGrandTotal(BigDecimal roomChargeLkr, BigDecimal taxLkr) {
        return roomChargeLkr.add(taxLkr).setScale(2, RoundingMode.HALF_UP);
    }
}

