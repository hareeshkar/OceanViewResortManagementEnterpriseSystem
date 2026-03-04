<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.ReservationDAO" %>
<%@ page import="oceanview.dao.ReportDAO" %>
<%@ page import="oceanview.model.Reservation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    // ── RBAC Guard ──────────────────────────────────────────────
    if (!"ADMIN".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ── Pagination ──────────────────────────────────────────────
    int pageSize = 15;
    int pageNo   = 1;
    try {
        String p = request.getParameter("page");
        if (p != null) pageNo = Math.max(1, Integer.parseInt(p));
    } catch (NumberFormatException ignored) {}
    int offset = (pageNo - 1) * pageSize;

    // ── Data ────────────────────────────────────────────────────
    ReservationDAO resDao  = new ReservationDAO();
    ReportDAO      repDao  = new ReportDAO();

    List<Reservation> bookings = resDao.getPaginatedReservations(offset, pageSize);
    BigDecimal totalRevenue    = repDao.getTotalRevenue();
    int        totalBookings   = repDao.getTotalBookingsCount();

    String loggedIn = (String) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Global Financial Ledger | OceanView Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_ui.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
</head>
<body>

<!-- ══════════════════════════════════════════════
     SIDEBAR
══════════════════════════════════════════════ -->
<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
        <span>OceanView Admin</span>
    </div>
    <div class="sidebar-role">Administrator</div>
    <nav class="sidebar-nav">
        <a href="dashboard.jsp"    class="nav-link">        <span class="nav-icon">📊</span> Executive Dashboard</a>
        <a href="manage_users.jsp" class="nav-link">        <span class="nav-icon">👥</span> Manage Staff Access</a>
        <a href="admin_ledger.jsp" class="nav-link active"><span class="nav-icon">📋</span> Global Financial Ledger</a>
        <a href="help.jsp"         class="nav-link">        <span class="nav-icon">📖</span> Administrator Guide</a>
        <div class="sidebar-divider"></div>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            Secure Logout
        </a>
    </div>
</aside>

<!-- ══════════════════════════════════════════════
     MAIN CONTENT
══════════════════════════════════════════════ -->
<main class="admin-main">

    <!-- Executive Header -->
    <div class="exec-header">
        <div>
            <h1>Global Financial Ledger</h1>
            <p>Complete reservation and billing records. Viewing as <strong style="color:white;"><%= loggedIn %></strong>.</p>
        </div>
        <div class="status-badge">
            <div class="status-dot"></div>
            <span>Read-Only Audit View</span>
        </div>
    </div>

    <!-- Revenue Summary KPIs -->
    <div class="grid grid-2" style="margin-bottom: 28px;">
        <div class="kpi-card accent-green">
            <div class="kpi-icon">💰</div>
            <div class="kpi-label">Total Gross Revenue</div>
            <div class="kpi-value">
                <span class="unit" style="font-size:0.85rem; margin-right:2px;">LKR</span><%= totalRevenue %>
            </div>
            <div class="kpi-sub">Sum of all billed invoices (grand_total_lkr)</div>
        </div>
        <div class="kpi-card accent-blue">
            <div class="kpi-icon">📑</div>
            <div class="kpi-label">Total Reservations on Record</div>
            <div class="kpi-value"><%= totalBookings %> <span class="unit">entries</span></div>
            <div class="kpi-sub">Showing page <%= pageNo %> — <%= pageSize %> per page</div>
        </div>
    </div>

    <!-- Summary Row -->
    <div class="summary-row no-print">
        <span>Page <strong><%= pageNo %></strong></span>
        <span>Showing records <strong><%= offset + 1 %></strong> – <strong><%= offset + bookings.size() %></strong> of <strong><%= totalBookings %></strong></span>
        <span style="margin-left:auto;">
            <a href="javascript:window.print()" class="btn btn-sm btn-outline no-print">🖨️ Print Ledger</a>
        </span>
    </div>

    <!-- Ledger Table -->
    <div class="card">
        <div class="card-header">
            <div>
                <div class="card-title">All Reservations &amp; Billing Records</div>
                <div class="card-subtitle">Joined from ov_reservation, ov_accommodation, and ov_billing_invoice tables</div>
            </div>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Booking Ref</th>
                        <th>Guest Name</th>
                        <th>Room</th>
                        <th>Arrival</th>
                        <th>Departure</th>
                        <th>Nights</th>
                        <th>Grand Total (LKR)</th>
                        <th>Status</th>
                        <th class="no-print">Invoice</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (bookings.isEmpty()) { %>
                    <tr>
                        <td colspan="9" style="text-align:center; padding:2.5rem; color: var(--admin-muted);">
                            No reservation records found for this page.
                        </td>
                    </tr>
                    <% } else {
                        for (Reservation r : bookings) { %>
                    <tr>
                        <td><strong><%= r.getBookingRef() %></strong></td>
                        <td><%= r.getGuestName() %></td>
                        <td>Room <strong><%= r.getRoomNumber() %></strong></td>
                        <td><%= r.getArrivalDate() %></td>
                        <td><%= r.getDepartureDate() %></td>
                        <td style="text-align:center;"><%= r.getTotalNights() %></td>
                        <td><strong>LKR <%= r.getGrandTotal() %></strong></td>
                        <td>
                            <%
                                String status = r.getBookingStatus();
                                String badgeClass = "badge-info";
                                if ("CONFIRMED".equals(status))   badgeClass = "badge-success";
                                else if ("CANCELLED".equals(status)) badgeClass = "badge-warning";
                                else if ("COMPLETED".equals(status)) badgeClass = "badge-purple";
                                else if ("CHECKED_IN".equals(status)) badgeClass = "badge-info";
                            %>
                            <span class="badge <%= badgeClass %>"><%= status %></span>
                        </td>
                        <td class="no-print">
                            <a href="<%= request.getContextPath() %>/staff/invoice.jsp?id=<%= r.getReservationPk() %>"
                               class="btn btn-sm btn-outline" target="_blank">
                                📄 Invoice
                            </a>
                        </td>
                    </tr>
                    <% }} %>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <nav class="pagination no-print">
            <% if (pageNo > 1) { %>
                <a href="admin_ledger.jsp?page=<%= pageNo - 1 %>" class="page-btn">← Previous</a>
            <% } %>
            <% if (pageNo > 2) { %>
                <a href="admin_ledger.jsp?page=1" class="page-btn">1</a>
                <% if (pageNo > 3) { %><span style="padding: 7px 4px; color: var(--admin-muted);">…</span><% } %>
            <% } %>
            <a href="admin_ledger.jsp?page=<%= pageNo %>" class="page-btn active"><%= pageNo %></a>
            <% if (bookings.size() == pageSize) { %>
                <a href="admin_ledger.jsp?page=<%= pageNo + 1 %>" class="page-btn"><%= pageNo + 1 %></a>
                <a href="admin_ledger.jsp?page=<%= pageNo + 1 %>" class="page-btn">Next →</a>
            <% } %>
        </nav>
    </div>

</main>
</body>
</html>

