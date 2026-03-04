<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.AccommodationDAO" %>
<%@ page import="oceanview.dao.ReservationDAO" %>
<%@ page import="oceanview.model.RoomCategory" %>
<%@ page import="oceanview.model.Reservation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || (!role.equals("STAFF") && !role.equals("ADMIN"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Server-side data fetch
    AccommodationDAO accDao = new AccommodationDAO();
    List<RoomCategory> categories = accDao.getAllCategories();

    ReservationDAO resDao = new ReservationDAO();
    List<Reservation> recentBookings = resDao.getRecentReservations(5);

    // Summary Stats
    int totalAvailable = accDao.getAvailableRoomCount(); // Assumed method, check DAO if fails
    BigDecimal totalRevenue = resDao.getTotalRevenueLKR(); // Assumed method, check DAO if fails
    int todayCheckins = resDao.getCheckinCountForDate(java.time.LocalDate.now().toString()); // Assumed method
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SaaS Dashboard | OceanView Management</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/elite_ui.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
</head>
<body class="animate-in">

    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>OceanView</h2>
        </div>
        <nav class="nav-menu">
            <a href="dashboard.jsp" class="nav-item active"><i>📅</i> Dashboard</a>
            <a href="view_bookings.jsp" class="nav-item"><i>📋</i> All Bookings</a>
            <a href="help.jsp" class="nav-item"><i>📖</i> Guidelines</a>
        </nav>
        <div class="logout-container">
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
        </div>
    </aside>

    <main class="main-wrapper">
        <header class="page-header">
            <h1>Staff Dashboard</h1>
        </header>

        <%
            if (request.getParameter("msg") != null) out.print("<div class='alert alert-success'>✅ " + request.getParameter("msg") + "</div>");
            if (request.getParameter("error") != null) out.print("<div class='alert alert-error'>⚠ " + request.getParameter("error") + "</div>");
        %>

        <section class="stats-grid">
            <div class="stat-card">
                <span class="stat-label">Today's Check-ins</span>
                <span class="stat-value"><%= todayCheckins %></span>
            </div>
            <div class="stat-card">
                <span class="stat-label">Rooms Available</span>
                <span class="stat-value"><%= totalAvailable %></span>
            </div>
            <div class="stat-card">
                <span class="stat-label">Total Revenue (LKR)</span>
                <span class="stat-value"><%= totalRevenue %></span>
            </div>
        </section>

        <section class="form-layout">
            <div class="card">
                <h3 class="card-title">New Reservation</h3>
                <form action="<%= request.getContextPath() %>/staff/book-room" method="POST" class="form-section">
                    <div class="form-group">
                        <label>Guest Name</label>
                        <input type="text" name="guestName" placeholder="Full name" required>
                    </div>
                    <div class="form-group">
                        <label>Phone (10 Digits)</label>
                        <input type="tel" name="contactPhone" pattern="0[0-9]{9}" placeholder="07XXXXXXXX" required>
                    </div>
                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="guestAddress" placeholder="Home or office address" required>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label>Arrival</label>
                            <input type="date" id="arrivalDate" name="arrivalDate" required>
                        </div>
                        <div class="form-group">
                            <label>Departure</label>
                            <input type="date" id="departureDate" name="departureDate" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Room Category</label>
                        <select id="categorySelector" required>
                            <option value="">-- Select Category --</option>
                            <% for(RoomCategory cat : categories) { %>
                                <option value="<%= cat.getCategoryId() %>"><%= cat.getCategoryName() %> (LKR <%= cat.getBaseRateLkr() %>)</option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Select Room</label>
                        <select id="roomSelector" name="roomPk" required disabled>
                            <option value="">Choose dates and category first</option>
                        </select>
                        <input type="hidden" id="baseRateLkr" name="baseRateLkr" value="0">
                    </div>

                    <button type="submit" class="btn-primary" id="submitBtn" disabled>Confirm Reservation</button>
                </form>
            </div>

            <div class="card">
                <h3 class="card-title">Recent Bookings</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Ref</th>
                                <th>Guest</th>
                                <th>Room</th>
                                <th>Nights</th>
                                <th>Total (LKR)</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(recentBookings.isEmpty()) { %>
                                <tr><td colspan="6" style="text-align:center; padding: 2rem; color: #64748b;">No recent bookings found.</td></tr>
                            <% } else {
                                for(Reservation r : recentBookings) { %>
                                <tr>
                                    <td><strong><%= r.getBookingRef() %></strong></td>
                                    <td><%= r.getGuestName() %></td>
                                    <td>Room <%= r.getRoomNumber() %></td>
                                    <td><%= r.getTotalNights() %></td>
                                    <td>LKR <%= r.getGrandTotal() %></td>
                                    <td><a href="invoice.jsp?id=<%= r.getReservationPk() %>" style="color: var(--accent-emerald); font-weight: 600; text-decoration: none;">📄 Invoice</a></td>
                                </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>

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
                else { roomSel.innerHTML = '<option value="">Wait for selection...</option>'; roomSel.disabled = true; btn.disabled = true; }
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
                roomSel.innerHTML = '<option value="">Checking rooms...</option>';
                roomSel.disabled = true;
                btn.disabled = true;

                fetch("<%= request.getContextPath() %>/api/availability?arrival=" + arr + "&departure=" + dep + "&categoryId=" + cat + "&_t=" + new Date().getTime())
                .then(res => res.json())
                .then(data => {
                    roomSel.innerHTML = '<option value="">-- Choose a Free Room --</option>';
                    if(data.length === 0) { roomSel.innerHTML = '<option value="">No rooms available</option>'; return; }

                    data.forEach(room => {
                        var opt = document.createElement('option');
                        opt.value = room.roomPk;
                        opt.setAttribute('data-rate', room.baseRateLkr);

                        var label = "Room " + room.roomNumber + " - [" + room.status + "]";
                        opt.text = label;

                        if(room.status !== "AVAILABLE") {
                            opt.disabled = true;
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

