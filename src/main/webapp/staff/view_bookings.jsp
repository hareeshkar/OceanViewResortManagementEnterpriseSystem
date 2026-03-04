<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.ReservationDAO" %>
<%@ page import="oceanview.model.Reservation" %>
<%@ page import="java.util.List" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }

    // Pagination Logic
    int pageNo = 1;
    int limit = 12; // Higher density
    if(request.getParameter("page") != null) {
        pageNo = Integer.parseInt(request.getParameter("page"));
    }
    int offset = (pageNo - 1) * limit;

    ReservationDAO resDao = new ReservationDAO();
    List<Reservation> bookings = resDao.getPaginatedReservations(offset, limit);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Bookings | OceanView Enterprise</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/elite_ui.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
</head>
<body class="animate-in">

    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>OceanView</h2>
        </div>
        <nav class="nav-menu">
            <a href="dashboard.jsp" class="nav-item"><i>📅</i> Dashboard</a>
            <a href="view_bookings.jsp" class="nav-item active"><i>📋</i> All Bookings</a>
            <a href="help.jsp" class="nav-item"><i>📖</i> Guidelines</a>
        </nav>
        <div class="logout-container">
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
        </div>
    </aside>

    <main class="main-wrapper">
        <header class="page-header">
            <h1>Bookings Ledger</h1>
        </header>

        <section class="card">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Ref</th>
                            <th>Guest Name</th>
                            <th>Room</th>
                            <th>Arrival</th>
                            <th>Departure</th>
                            <th>Total (LKR)</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(bookings.isEmpty()) { %>
                        <tr>
                            <td colspan="8" style="text-align:center; padding:2.5rem; color: var(--text-muted);">
                                No reservation records found for this page.
                            </td>
                        </tr>
                        <% } else {
                            for(Reservation r : bookings) {
                                String bStatus = r.getBookingStatus();
                                String bClass = "badge-info";
                                if("CONFIRMED".equals(bStatus)) bClass = "badge-success";
                                else if("CANCELLED".equals(bStatus)) bClass = "badge-warning";
                                else if("COMPLETED".equals(bStatus)) bClass = "badge-purple";
                                else if("CHECKED_IN".equals(bStatus)) bClass = "badge-info";
                        %>
                        <tr>
                            <td><strong><%= r.getBookingRef() %></strong></td>
                            <td><%= r.getGuestName() %></td>
                            <td>Room <%= r.getRoomNumber() %></td>
                            <td><%= r.getArrivalDate() %></td>
                            <td><%= r.getDepartureDate() %></td>
                            <td>LKR <%= r.getGrandTotal() %></td>
                            <td><span class="badge <%= bClass %>"><%= bStatus %></span></td>
                            <td>
                                <a href="invoice.jsp?id=<%= r.getReservationPk() %>" style="color: var(--accent-emerald); font-weight: 600; text-decoration: none; display: flex; align-items: center; gap: 0.25rem;">
                                    📄 Invoice
                                </a>
                            </td>
                        </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>

            <nav class="pagination">
                <% if(pageNo > 1) { %>
                    <a href="view_bookings.jsp?page=<%= pageNo - 1 %>" class="page-link">← Previous</a>
                <% } %>
                <a href="#" class="page-link active"><%= pageNo %></a>
                <% if(bookings.size() == limit) { %>
                    <a href="view_bookings.jsp?page=<%= pageNo + 1 %>" class="page-link">Next →</a>
                <% } %>
            </nav>
        </section>
    </main>

</body>
</html>

