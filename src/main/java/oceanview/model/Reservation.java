package oceanview.model;

import java.time.LocalDate;

/**
 * Enterprise Domain Model for Guest Reservations.
 * STRICT RULE: Utilizes java.time.LocalDate exclusively.
 */
public class Reservation {
    private int reservationPk;
    private String bookingRef;
    private String guestName;
    private String contactPhone;
    private String guestAddress;
    private int roomPk;
    private LocalDate arrivalDate;
    private LocalDate departureDate;
    private String bookingStatus;

    // Getters and Setters
    public int getReservationPk() { return reservationPk; }
    public void setReservationPk(int reservationPk) { this.reservationPk = reservationPk; }

    public String getBookingRef() { return bookingRef; }
    public void setBookingRef(String bookingRef) { this.bookingRef = bookingRef; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getGuestAddress() { return guestAddress; }
    public void setGuestAddress(String guestAddress) { this.guestAddress = guestAddress; }

    public int getRoomPk() { return roomPk; }
    public void setRoomPk(int roomPk) { this.roomPk = roomPk; }

    public LocalDate getArrivalDate() { return arrivalDate; }
    public void setArrivalDate(LocalDate arrivalDate) { this.arrivalDate = arrivalDate; }

    public LocalDate getDepartureDate() { return departureDate; }
    public void setDepartureDate(LocalDate departureDate) { this.departureDate = departureDate; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
}

