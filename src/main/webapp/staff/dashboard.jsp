<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.AccommodationDAO" %>
<%@ page import="oceanview.dao.ReservationDAO" %>
<%@ page import="oceanview.model.RoomCategory" %>
<%@ page import="oceanview.model.Reservation" %>
<%@ page import="java.util.List" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || (!role.equals("STAFF") && !role.equals("ADMIN"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Server-side data fetch for UI
    AccommodationDAO accDao = new AccommodationDAO();
    List<RoomCategory> categories = accDao.getAllCategories();

    ReservationDAO resDao = new ReservationDAO();
    List<Reservation> recentBookings = resDao.getRecentReservations(5); // Get last 5
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard | OceanView Enterprise</title>
    <style>
        :root { --emerald: #2ecc71; --forest: #27ae60; --dark-ocean: #2c3e50; --light-bg: #f4f6f9; --border: #bdc3c7; }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
        body { display: grid; grid-template-columns: 250px 1fr; min-height: 100vh; background-color: var(--light-bg); }

        /* Sidebar */
        .sidebar { background-color: var(--dark-ocean); color: white; padding: 20px 0; }
        .sidebar h2 { text-align: center; color: var(--emerald); margin-bottom: 30px; }
        .nav-link { display: block; padding: 15px 25px; color: white; text-decoration: none; border-left: 4px solid transparent; }
        .nav-link.active { background-color: #34495e; border-left-color: var(--emerald); }
        .logout-btn { margin-top: 50px; background: #e74c3c; text-align: center; margin: 20px; border-radius: 5px; }

        /* Content */
        .main-content { padding: 40px; }
        .card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 30px; }
        h3 { color: var(--dark-ocean); margin-bottom: 20px; border-bottom: 2px solid var(--emerald); padding-bottom: 10px; }

        /* Form */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group.full { grid-column: span 3; }
        label { font-weight: 600; color: #34495e; font-size: 14px; margin-bottom: 5px; }
        input, select { padding: 10px; border: 1px solid var(--border); border-radius: 5px; }
        .btn-submit { background: var(--forest); color: white; padding: 15px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; grid-column: span 3; }
        .btn-submit:disabled { background: #95a5a6; cursor: not-allowed; }

        /* Table */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: var(--dark-ocean); color: white; }
        tr:hover { background-color: #f5f5f5; }
        .badge { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; color: white; }
        .badge-CONFIRMED { background-color: var(--emerald); }

        .alert { padding: 15px; border-radius: 5px; margin-bottom: 20px; font-weight: bold; }
        .alert-success { background: #eafaf1; color: var(--forest); border: 1px solid #d5f5e3; }
        .alert-error { background: #fdeaea; color: #e74c3c; border: 1px solid #fad2d2; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>🏨 Staff Panel</h2>
        <a href="dashboard.jsp" class="nav-link active">📅 Dashboard & Booking</a>
        <a href="<%= request.getContextPath() %>/logout" class="nav-link logout-btn">Log Out</a>
    </div>

    <div class="main-content">
        <%
            if (request.getParameter("msg") != null) out.print("<div class='alert alert-success'>✅ " + request.getParameter("msg") + "</div>");
            if (request.getParameter("error") != null) out.print("<div class='alert alert-error'>⚠ " + request.getParameter("error") + "</div>");
        %>

        <!-- 1. Booking Form Section -->
        <div class="card">
            <h3>Create New Reservation</h3>
            <form action="<%= request.getContextPath() %>/staff/book-room" method="POST">
                <div class="form-grid">
                    <div class="form-group"><label>Guest Name</label><input type="text" name="guestName" required></div>
                    <div class="form-group"><label>Phone (10 Digits)</label><input type="tel" name="contactPhone" pattern="0[0-9]{9}" required></div>
                    <div class="form-group"><label>Address</label><input type="text" name="guestAddress" required></div>

                    <div class="form-group"><label>Arrival</label><input type="date" id="arrivalDate" name="arrivalDate" required></div>
                    <div class="form-group"><label>Departure</label><input type="date" id="departureDate" name="departureDate" required></div>

                    <div class="form-group">
                        <label>Room Category</label>
                        <select id="categorySelector" required>
                            <option value="">-- Select Category --</option>
                            <% for(RoomCategory cat : categories) { %>
                                <option value="<%= cat.getCategoryId() %>"><%= cat.getCategoryName() %> (<%= cat.getBaseRateLkr() %> LKR)</option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group full">
                        <label>Select Room (Filtered by Status)</label>
                        <select id="roomSelector" name="roomPk" required disabled>
                            <option value="">Select Dates & Category First</option>
                        </select>
                        <input type="hidden" id="baseRateLkr" name="baseRateLkr" value="0">
                    </div>

                    <button type="submit" class="btn-submit" id="submitBtn" disabled>Confirm Reservation</button>
                </div>
            </form>
        </div>

        <!-- 2. Recent Bookings Table Section -->
        <div class="card">
            <h3>Recent Bookings</h3>
            <table>
                <thead>
                    <tr>
                        <th>Ref</th>
                        <th>Guest</th>
                        <th>Room</th>
                        <th>Dates</th>
                        <th>Nights</th>
                        <th>Grand Total (LKR)</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if(recentBookings.isEmpty()) { %>
                        <tr><td colspan="7" style="text-align:center;">No recent bookings found.</td></tr>
                    <% } else {
                        for(Reservation r : recentBookings) { %>
                        <tr>
                            <td><strong><%= r.getBookingRef() %></strong></td>
                            <td><%= r.getGuestName() %></td>
                            <td>Room <%= r.getRoomNumber() %></td>
                            <td><%= r.getArrivalDate() %> to <%= r.getDepartureDate() %></td>
                            <td><%= r.getTotalNights() %></td>
                            <td><%= r.getGrandTotal() %></td>
                            <td><span class="badge badge-<%= r.getBookingStatus() %>"><%= r.getBookingStatus() %></span></td>
                        </tr>
                    <% }} %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var arrIn = document.getElementById("arrivalDate");
            var depIn = document.getElementById("departureDate");
            var catSel = document.getElementById("categorySelector");
            var roomSel = document.getElementById("roomSelector");
            var rateIn = document.getElementById("baseRateLkr");
            var btn = document.getElementById("submitBtn");

            var today = new Date().toISOString().split('T')[0];
            arrIn.setAttribute('min', today);

            function validateAndFetch() {
                var a = arrIn.value; var d = depIn.value; var c = catSel.value;
                if(a && d && c && a < d) fetchRooms(a, d, c);
                else { roomSel.innerHTML = '<option value="">Complete selection...</option>'; roomSel.disabled = true; btn.disabled = true; }
            }

            arrIn.addEventListener("change", function() {
                var next = new Date(this.value); next.setDate(next.getDate() + 1);
                depIn.setAttribute('min', next.toISOString().split('T')[0]);
                if(depIn.value <= this.value) depIn.value = '';
                validateAndFetch();
            });
            depIn.addEventListener("change", validateAndFetch);
            catSel.addEventListener("change", validateAndFetch);

            function fetchRooms(arr, dep, cat) {
                roomSel.innerHTML = '<option value="">Loading...</option>';
                roomSel.disabled = true;
                btn.disabled = true;

                fetch("<%= request.getContextPath() %>/api/availability?arrival="+arr+"&departure="+dep+"&categoryId="+cat+"&_t="+new Date().getTime())
                .then(res => res.json())
                .then(data => {
                    roomSel.innerHTML = '<option value="">-- Choose a Room --</option>';
                    if(data.length === 0) { roomSel.innerHTML = '<option value="">No rooms in this category</option>'; return; }

                    data.forEach(room => {
                        var opt = document.createElement('option');
                        opt.value = room.roomPk;
                        opt.setAttribute('data-rate', room.baseRateLkr);

                        // Dynamically append status and disable if not available
                        var label = "Room " + room.roomNumber + " - [" + room.status + "]";
                        opt.text = label;

                        if(room.status !== "AVAILABLE") {
                            opt.disabled = true;
                            opt.style.color = 'red';
                        } else {
                            opt.style.color = 'green';
                        }
                        roomSel.appendChild(opt);
                    });
                    roomSel.disabled = false;
                });
            }

            roomSel.addEventListener("change", function() {
                if(this.value) {
                    rateIn.value = this.options[this.selectedIndex].getAttribute('data-rate');
                    btn.disabled = false;
                } else btn.disabled = true;
            });
        });
    </script>
</body>
</html>
