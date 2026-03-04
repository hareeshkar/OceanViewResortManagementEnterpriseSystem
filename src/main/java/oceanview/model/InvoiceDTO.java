package oceanview.model;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class InvoiceDTO {
    private String bookingRef, guestName, address, phone, roomNumber, categoryName, invoiceNumber;
    private LocalDate arrival, departure;
    private LocalDateTime bookingDate;
    private long nights;
    private BigDecimal baseRate, roomCharge, tax, grandTotal;

    // Standard Getters and Setters
    public String getBookingRef() { return bookingRef; } public void setBookingRef(String b) { this.bookingRef = b; }
    public String getGuestName() { return guestName; } public void setGuestName(String g) { this.guestName = g; }
    public String getAddress() { return address; } public void setAddress(String a) { this.address = a; }
    public String getPhone() { return phone; } public void setPhone(String p) { this.phone = p; }
    public String getRoomNumber() { return roomNumber; } public void setRoomNumber(String r) { this.roomNumber = r; }
    public String getCategoryName() { return categoryName; } public void setCategoryName(String c) { this.categoryName = c; }
    public String getInvoiceNumber() { return invoiceNumber; } public void setInvoiceNumber(String i) { this.invoiceNumber = i; }
    public LocalDate getArrival() { return arrival; } public void setArrival(LocalDate a) { this.arrival = a; }
    public LocalDate getDeparture() { return departure; } public void setDeparture(LocalDate d) { this.departure = d; }
    public LocalDateTime getBookingDate() { return bookingDate; } public void setBookingDate(LocalDateTime b) { this.bookingDate = b; }
    public long getNights() { return nights; } public void setNights(long n) { this.nights = n; }
    public BigDecimal getBaseRate() { return baseRate; } public void setBaseRate(BigDecimal b) { this.baseRate = b; }
    public BigDecimal getRoomCharge() { return roomCharge; } public void setRoomCharge(BigDecimal r) { this.roomCharge = r; }
    public BigDecimal getTax() { return tax; } public void setTax(BigDecimal t) { this.tax = t; }
    public BigDecimal getGrandTotal() { return grandTotal; } public void setGrandTotal(BigDecimal g) { this.grandTotal = g; }
}
