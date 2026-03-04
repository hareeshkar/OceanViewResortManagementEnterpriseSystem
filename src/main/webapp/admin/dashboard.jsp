<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.ReportDAO" %>
<%@ page import="oceanview.dao.ReservationDAO" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%
    // ── RBAC Guard ──────────────────────────────────────────────
    if (!"ADMIN".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ── Business Intelligence Data ──────────────────────────────
    ReportDAO reportDao        = new ReportDAO();
    ReservationDAO resDao      = new ReservationDAO();

    BigDecimal totalRevenue    = reportDao.getTotalRevenue();
    int        totalBookings   = reportDao.getTotalBookingsCount();
    int        todayCheckins   = resDao.getCheckinCountForDate(java.time.LocalDate.now().toString());
    Map<String, Integer> catStats = reportDao.getCategoryPerformance();
    List<String> auditLogs     = reportDao.getRecentAuditLogs(10);

    String loggedIn = (String) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Intelligence | OceanView Enterprise</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_ui.css">
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
        <a href="dashboard.jsp"     class="nav-link active"><span class="nav-icon">📊</span> Executive Dashboard</a>
        <a href="manage_users.jsp"  class="nav-link">        <span class="nav-icon">👥</span> Manage Staff Access</a>
        <a href="admin_ledger.jsp"  class="nav-link">        <span class="nav-icon">📋</span> Global Financial Ledger</a>
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
            <h1>Executive Intelligence Overview</h1>
            <p>Welcome back, <strong style="color:white;"><%= loggedIn %></strong>. Real-time financial &amp; operational analytics.</p>
        </div>
        <div class="status-badge">
            <div class="status-dot"></div>
            <span>System Operational</span>
        </div>
    </div>

    <!-- KPI Metric Cards -->
    <div class="grid grid-3" style="margin-bottom: 28px;">
        <div class="kpi-card accent-green">
            <div class="kpi-icon">💰</div>
            <div class="kpi-label">Gross Revenue Yield</div>
            <div class="kpi-value">
                <span class="unit" style="font-size:0.85rem; margin-right:2px;">LKR</span><%= totalRevenue %>
            </div>
            <div class="kpi-sub">Total billed across all reservations</div>
        </div>
        <div class="kpi-card accent-blue">
            <div class="kpi-icon">📅</div>
            <div class="kpi-label">Total Reservation Volume</div>
            <div class="kpi-value"><%= totalBookings %> <span class="unit">bookings</span></div>
            <div class="kpi-sub">All-time confirmed reservations</div>
        </div>
        <div class="kpi-card accent-purple">
            <div class="kpi-icon">🚪</div>
            <div class="kpi-label">Today's Check-ins</div>
            <div class="kpi-value"><%= todayCheckins %> <span class="unit">guests</span></div>
            <div class="kpi-sub">Arrivals scheduled for today</div>
        </div>
    </div>

    <!-- Charts + Audit Console -->
    <div class="grid grid-2-3" style="margin-bottom: 28px;">

        <!-- Pure CSS Bar Chart -->
        <div class="card">
            <div class="card-header">
                <div>
                    <div class="card-title">Category Demand Distribution</div>
                    <div class="card-subtitle">Booking volume per room tier (live data)</div>
                </div>
            </div>
            <%
                int maxCount = 1;
                for (Integer c : catStats.values()) { if (c > maxCount) maxCount = c; }
                if (catStats.isEmpty()) {
            %>
                <p style="color: var(--admin-muted); font-size: 0.9rem;">No booking data available yet.</p>
            <% } else {
                for (Map.Entry<String, Integer> entry : catStats.entrySet()) {
                    int pct = (int)(((double)entry.getValue() / maxCount) * 100);
            %>
            <div class="chart-row">
                <div class="chart-meta">
                    <span class="chart-cat"><%= entry.getKey() %></span>
                    <span class="chart-count"><%= entry.getValue() %> bookings</span>
                </div>
                <div class="bar-track">
                    <div class="bar-fill" style="width: <%= pct %>%;"></div>
                </div>
            </div>
            <% }} %>
        </div>

        <!-- Live Audit Console -->
        <div class="card">
            <div class="card-header">
                <div>
                    <div class="card-title">Live Audit Console</div>
                    <div class="card-subtitle">MySQL trigger events — real-time log stream</div>
                </div>
            </div>
            <div class="audit-wrap">
                <% if (auditLogs.isEmpty()) { %>
                    <div class="audit-empty">SYSTEM_INIT :: Awaiting database trigger events...</div>
                <% } else {
                    for (String log : auditLogs) {
                        int closeIdx = log.indexOf(']');
                        String ts   = log.substring(0, closeIdx + 1);
                        String rest = log.substring(closeIdx + 1).trim();
                        int dashIdx = rest.indexOf(" - ");
                        String type = dashIdx >= 0 ? rest.substring(0, dashIdx).trim() : rest;
                        String desc = dashIdx >= 0 ? rest.substring(dashIdx + 3).trim() : "";
                %>
                <div class="audit-line">
                    <span class="audit-ts"><%= ts %></span>
                    <span class="audit-type"><%= type %></span>
                    <% if (!desc.isEmpty()) { %>
                        <span class="audit-desc"> — <%= desc %></span>
                    <% } %>
                </div>
                <% }} %>
                <div class="audit-cursor">&gt; END_OF_STREAM_</div>
            </div>
        </div>
    </div>

    <!-- Quick Navigation to Admin Features -->
    <div class="grid grid-2">
        <a href="manage_users.jsp" style="text-decoration:none;">
            <div class="kpi-card accent-yellow" style="cursor:pointer; display:flex; align-items:center; gap:16px;">
                <div style="font-size:2.5rem;">👥</div>
                <div>
                    <div class="kpi-label">User Management</div>
                    <div style="font-size:0.95rem; font-weight:700; color:var(--admin-primary); margin-top:4px;">Manage Staff Access →</div>
                    <div class="kpi-sub">View and manage system account roles</div>
                </div>
            </div>
        </a>
        <a href="admin_ledger.jsp" style="text-decoration:none;">
            <div class="kpi-card accent-blue" style="cursor:pointer; display:flex; align-items:center; gap:16px;">
                <div style="font-size:2.5rem;">📋</div>
                <div>
                    <div class="kpi-label">Financial Ledger</div>
                    <div style="font-size:0.95rem; font-weight:700; color:var(--admin-primary); margin-top:4px;">View Global Ledger →</div>
                    <div class="kpi-sub">Full reservation and billing records</div>
                </div>
            </div>
        </a>
    </div>

</main>
</body>
</html>
