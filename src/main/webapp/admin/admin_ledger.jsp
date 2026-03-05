<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.ReservationDAO,oceanview.dao.ReportDAO" %>
<%@ page import="oceanview.model.Reservation" %>
<%@ page import="java.util.List,java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%
    if (!"ADMIN".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    int pageSize = 15, pageNo = 1;
    try { String p = request.getParameter("page"); if (p != null) pageNo = Math.max(1, Integer.parseInt(p)); } catch (NumberFormatException ignored) {}
    int offset = (pageNo - 1) * pageSize;

    ReservationDAO resDao = new ReservationDAO();
    ReportDAO      repDao = new ReportDAO();

    List<Reservation>       bookings      = resDao.getPaginatedReservations(offset, pageSize);
    BigDecimal              totalRevenue  = repDao.getTotalRevenue();
    int                     totalBookings = repDao.getTotalBookingsCount();
    BigDecimal              avgValue      = repDao.getAverageBookingValue();
    Map<String, BigDecimal> dailyTrend    = repDao.getDailyRevenueTrend();
    Map<String, BigDecimal> roomRevenue   = repDao.getRevenuePerRoom();
    String loggedIn = (String) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing Ledger | OceanView Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_ui.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Cormorant+Garamond:wght@300;400&display=swap" rel="stylesheet">
    <style>
        /* ── Chart card ── */
        .chart-card {
            background: var(--admin-card);
            border: 1px solid var(--admin-border);
            border-radius: 14px;
            padding: 28px 32px 20px;
            backdrop-filter: blur(8px);
            box-shadow: 0 4px 28px rgba(0,0,0,0.22);
            margin-bottom: 28px;
            overflow: hidden;
        }
        .chart-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 28px;
        }
        .chart-card-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.25rem;
            font-weight: 400;
            color: var(--admin-text);
            letter-spacing: -0.01em;
        }
        .chart-card-sub {
            font-size: 0.78rem;
            color: var(--admin-muted);
            margin-top: 4px;
        }
        .chart-card-stat {
            text-align: right;
        }
        .chart-card-stat-val {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--admin-accent);
            letter-spacing: -0.04em;
            line-height: 1;
        }
        .chart-card-stat-lbl {
            font-size: 0.68rem;
            color: var(--admin-muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-top: 4px;
        }
        /* SVG host — key: fixed pixel height, overflow visible for labels */
        .svg-host {
            width: 100%;
            height: 260px;
            position: relative;
        }
        .svg-host svg {
            display: block;
            width: 100%;
            height: 100%;
        }
        /* Floating tooltip */
        .chart-tip {
            position: absolute;
            background: #181c22;
            border: 1px solid rgba(203,168,106,0.3);
            border-radius: 8px;
            padding: 10px 16px;
            font-size: 0.78rem;
            color: #f4f0e6;
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.18s, left 0.06s, top 0.06s;
            z-index: 20;
            box-shadow: 0 12px 40px rgba(0,0,0,0.5);
            white-space: nowrap;
            min-width: 120px;
        }
        .chart-tip-lbl { color: #7a8290; font-size: 0.65rem; text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 3px; }
        .chart-tip-val { color: #cba86a; font-weight: 700; font-size: 1.1rem; font-family: 'Cormorant Garamond', serif; }
        /* Two-col chart grid */
        .chart-grid-2 { display: grid; grid-template-columns: 1.8fr 1fr; gap: 24px; margin-bottom: 28px; }
        /* Bar chart (rooms) */
        .bar-chart-wrap { padding: 4px 0; }
        .bc-row { margin-bottom: 14px; }
        .bc-row:last-child { margin-bottom: 0; }
        .bc-meta { display: flex; justify-content: space-between; margin-bottom: 6px; font-size: 0.82rem; }
        .bc-label { color: var(--admin-text); font-weight: 500; }
        .bc-val   { color: var(--admin-muted); font-weight: 600; font-size: 0.75rem; }
        .bc-track { height: 7px; background: rgba(255,255,255,0.04); border-radius: 99px; overflow: hidden; }
        .bc-fill  { height: 100%; border-radius: 99px; background: linear-gradient(90deg, var(--admin-accent) 0%, #dfc08a 100%); min-width: 3px; transition: width 1.2s cubic-bezier(0.19,1,0.22,1); }
        /* Status chips */
        .chip { display:inline-flex; align-items:center; padding:3px 10px; border-radius:99px; font-size:0.68rem; font-weight:600; text-transform:uppercase; letter-spacing:0.05em; }
        .chip-confirmed  { background:rgba(93,190,138,0.12);  color:#5dbe8a; }
        .chip-cancelled  { background:rgba(245,197,66,0.12);  color:#f5c542; }
        .chip-completed  { background:rgba(167,139,250,0.12); color:#a78bfa; }
        .chip-checked_in { background:rgba(107,163,232,0.12); color:#6ba3e8; }
        .chip-default    { background:rgba(255,255,255,0.06); color:#7a8290; }
        @media (max-width: 900px) {
            .chart-grid-2 { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>
        </svg>
        <span>OceanView Admin</span>
    </div>
    <div class="sidebar-role">Administrator</div>
    <nav class="sidebar-nav">
        <a href="dashboard.jsp"    class="nav-link"><span class="nav-icon">📊</span> Dashboard</a>
        <a href="manage_users.jsp" class="nav-link"><span class="nav-icon">👥</span> Staff Access</a>
        <a href="admin_ledger.jsp" class="nav-link active"><span class="nav-icon">📋</span> Billing Ledger</a>
        <a href="help.jsp"         class="nav-link"><span class="nav-icon">📖</span> Guide</a>
        <div class="sidebar-divider"></div>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
            </svg>
            Secure Logout
        </a>
    </div>
</aside>

<main class="admin-main">

    <!-- Header -->
    <div class="exec-header">
        <div>
            <h1>Billing Ledger</h1>
            <p>Revenue analytics &amp; full invoice records. Logged in as <strong style="color:white;"><%= loggedIn %></strong>.</p>
        </div>
        <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap;">
            <a href="javascript:window.print()" class="btn btn-sm btn-outline no-print">🖨️ Print</a>
            <div class="status-badge"><div class="status-dot"></div><span>Read-Only View</span></div>
        </div>
    </div>

    <!-- KPI Row -->
    <div class="grid grid-3" style="margin-bottom:28px;">
        <div class="kpi-card accent-green">
            <div class="kpi-icon">💰</div>
            <div class="kpi-label">Total Gross Revenue</div>
            <div class="kpi-value"><span class="unit" style="font-size:0.8rem;margin-right:3px;">LKR</span><%= totalRevenue %></div>
            <div class="kpi-sub">All-time billed invoices</div>
        </div>
        <div class="kpi-card accent-blue">
            <div class="kpi-icon">📑</div>
            <div class="kpi-label">Total Reservations</div>
            <div class="kpi-value"><%= totalBookings %> <span class="unit">bookings</span></div>
            <div class="kpi-sub">Complete reservation history</div>
        </div>
        <div class="kpi-card accent-purple">
            <div class="kpi-icon">📈</div>
            <div class="kpi-label">Avg. Booking Value</div>
            <div class="kpi-value"><span class="unit" style="font-size:0.8rem;margin-right:3px;">LKR</span><%= avgValue %></div>
            <div class="kpi-sub">Per-invoice average</div>
        </div>
    </div>

    <!-- ── CHARTS ROW ── -->
    <div class="chart-grid-2 no-print">

        <!-- Daily Revenue Line Chart -->
        <div class="chart-card">
            <div class="chart-card-header">
                <div>
                    <div class="chart-card-title">Daily Revenue</div>
                    <div class="chart-card-sub">Last 14 days · booking creation date</div>
                </div>
                <div class="chart-card-stat">
                    <div class="chart-card-stat-val">LKR <%= totalRevenue %></div>
                    <div class="chart-card-stat-lbl">All-time total</div>
                </div>
            </div>
            <div class="svg-host" id="daily-host">
                <div class="chart-tip" id="daily-tip">
                    <div class="chart-tip-lbl" id="daily-tip-lbl"></div>
                    <div class="chart-tip-val" id="daily-tip-val"></div>
                </div>
                <!-- SVG injected by JS — no preserveAspectRatio distortion -->
                <svg id="daily-svg" xmlns="http://www.w3.org/2000/svg"></svg>
            </div>
        </div>

        <!-- Per-Room Revenue Bar Chart -->
        <div class="chart-card">
            <div class="chart-card-header">
                <div>
                    <div class="chart-card-title">Revenue by Room</div>
                    <div class="chart-card-sub">Total billed per room</div>
                </div>
            </div>
            <div class="bar-chart-wrap" id="room-bars">
                <%
                    BigDecimal maxRoom = BigDecimal.ONE;
                    for (BigDecimal v : roomRevenue.values()) if (v.compareTo(maxRoom) > 0) maxRoom = v;
                    for (Map.Entry<String, BigDecimal> e : roomRevenue.entrySet()) {
                        double pct = e.getValue().doubleValue() / maxRoom.doubleValue() * 100.0;
                        String lkr = e.getValue().compareTo(BigDecimal.ZERO) == 0 ? "—" : "LKR " + e.getValue().toPlainString();
                %>
                <div class="bc-row">
                    <div class="bc-meta">
                        <span class="bc-label"><%= e.getKey() %></span>
                        <span class="bc-val"><%= lkr %></span>
                    </div>
                    <div class="bc-track"><div class="bc-fill" style="width:<%= String.format("%.1f", pct) %>%"></div></div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Summary -->
    <div class="summary-row no-print">
        <span>Page <strong><%= pageNo %></strong></span>
        <span>Records <strong><%= offset + 1 %></strong>–<strong><%= offset + bookings.size() %></strong> of <strong><%= totalBookings %></strong></span>
    </div>

    <!-- Ledger Table -->
    <div class="card">
        <div class="card-header">
            <div>
                <div class="card-title">All Reservations &amp; Invoices</div>
                <div class="card-subtitle">ov_reservation ⋈ ov_accommodation ⋈ ov_billing_invoice</div>
            </div>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Booking Ref</th><th>Guest</th><th>Room</th>
                        <th>Arrival</th><th>Departure</th>
                        <th style="text-align:center;">Nights</th>
                        <th>Total (LKR)</th><th>Status</th>
                        <th class="no-print">Invoice</th>
                    </tr>
                </thead>
                <tbody>
                <% if (bookings.isEmpty()) { %>
                    <tr><td colspan="9" style="text-align:center;padding:2.5rem;color:var(--admin-muted);">No records found.</td></tr>
                <% } else { for (Reservation r : bookings) {
                    String st = r.getBookingStatus();
                    String chipCls = "chip-default";
                    if      ("CONFIRMED".equals(st))  chipCls = "chip-confirmed";
                    else if ("CANCELLED".equals(st))  chipCls = "chip-cancelled";
                    else if ("COMPLETED".equals(st))  chipCls = "chip-completed";
                    else if ("CHECKED_IN".equals(st)) chipCls = "chip-checked_in";
                %>
                    <tr>
                        <td><strong><%= r.getBookingRef() %></strong></td>
                        <td><%= r.getGuestName() %></td>
                        <td>Room <strong><%= r.getRoomNumber() %></strong></td>
                        <td><%= r.getArrivalDate() %></td>
                        <td><%= r.getDepartureDate() %></td>
                        <td style="text-align:center;"><%= r.getTotalNights() %></td>
                        <td><strong>LKR <%= r.getGrandTotal() %></strong></td>
                        <td><span class="chip <%= chipCls %>"><%= st %></span></td>
                        <td class="no-print">
                            <a href="<%= request.getContextPath() %>/staff/invoice.jsp?id=<%= r.getReservationPk() %>" class="btn btn-sm btn-outline" target="_blank">📄 Invoice</a>
                        </td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
        <nav class="pagination no-print">
            <% if (pageNo > 1) { %><a href="admin_ledger.jsp?page=<%= pageNo-1 %>" class="page-btn">← Prev</a><% } %>
            <% if (pageNo > 2) { %><a href="admin_ledger.jsp?page=1" class="page-btn">1</a><% if (pageNo > 3) { %><span style="padding:7px 4px;color:var(--admin-muted);">…</span><% } } %>
            <a href="admin_ledger.jsp?page=<%= pageNo %>" class="page-btn active"><%= pageNo %></a>
            <% if (bookings.size() == pageSize) { %>
                <a href="admin_ledger.jsp?page=<%= pageNo+1 %>" class="page-btn"><%= pageNo+1 %></a>
                <a href="admin_ledger.jsp?page=<%= pageNo+1 %>" class="page-btn">Next →</a>
            <% } %>
        </nav>
    </div>

</main>

<script>
/* ──────────────────────────────────────────────────
   DAILY REVENUE LINE CHART
   Uses intrinsic SVG coordinate system — no distortion
────────────────────────────────────────────────── */
(function () {
    'use strict';

    var raw = [
        <% boolean f = true;
           for (Map.Entry<String,BigDecimal> e : dailyTrend.entrySet()) {
               if (!f) out.print(",");
               out.print("{l:'" + e.getKey() + "',v:" + e.getValue().doubleValue() + "}");
               f = false;
           } %>
    ];

    if (!raw.length) return;

    /* ── dimensions ── */
    var W      = 900;   /* SVG intrinsic width  */
    var H      = 220;   /* SVG intrinsic height (data area) */
    var padL   = 58;    /* left  — y-axis labels  */
    var padR   = 20;    /* right */
    var padT   = 16;    /* top   */
    var padB   = 36;    /* bottom — x-axis labels */
    var plotW  = W - padL - padR;
    var plotH  = H - padT - padB;

    var svg = document.getElementById('daily-svg');
    /* Set viewBox to natural dimensions; let CSS scale to 100%×260px */
    svg.setAttribute('viewBox', '0 0 ' + W + ' ' + H);
    svg.setAttribute('preserveAspectRatio', 'xMidYMid meet');
    svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');

    /* ── helpers ── */
    function el(tag, attrs) {
        var e = document.createElementNS('http://www.w3.org/2000/svg', tag);
        for (var k in attrs) e.setAttribute(k, attrs[k]);
        return e;
    }
    function txt(content, attrs) {
        var t = el('text', attrs);
        t.textContent = content;
        return t;
    }

    /* ── gradient + glow defs ── */
    var defs = el('defs', {});
    var grad = el('linearGradient', {id:'dlg', x1:'0', y1:'0', x2:'0', y2:'1'});
    grad.appendChild(el('stop', {offset:'0%',   'stop-color':'#cba86a', 'stop-opacity':'0.30'}));
    grad.appendChild(el('stop', {offset:'100%', 'stop-color':'#cba86a', 'stop-opacity':'0.00'}));
    var filt = el('filter', {id:'dlglow', x:'-30%', y:'-30%', width:'160%', height:'160%'});
    var blur = el('feGaussianBlur', {stdDeviation:'3.5', result:'b'});
    var comp = el('feComposite', {in:'SourceGraphic', in2:'b', operator:'over'});
    filt.appendChild(blur); filt.appendChild(comp);
    defs.appendChild(grad); defs.appendChild(filt);
    svg.appendChild(defs);

    /* ── compute points ── */
    var maxV = 0;
    raw.forEach(function(d){ if (d.v > maxV) maxV = d.v; });
    if (maxV === 0) maxV = 1;

    var step = plotW / Math.max(raw.length - 1, 1);
    var pts = raw.map(function(d, i) {
        return {
            l: d.l,
            v: d.v,
            x: padL + i * step,
            y: padT + plotH - (d.v / maxV) * plotH
        };
    });

    /* ── grid lines + y-axis labels ── */
    var gridG = el('g', {});
    [0, 0.25, 0.5, 0.75, 1].forEach(function(p) {
        var gy = padT + plotH - p * plotH;
        gridG.appendChild(el('line', {
            x1: padL, x2: W - padR, y1: gy, y2: gy,
            stroke: 'rgba(255,255,255,0.05)', 'stroke-width': '1'
        }));
        var lkrK = (maxV * p / 1000).toFixed(0);
        gridG.appendChild(txt(lkrK + 'k', {
            x: padL - 6, y: gy + 4,
            'text-anchor': 'end', fill: '#475569',
            'font-size': '10', 'font-family': 'Outfit, sans-serif'
        }));
    });
    svg.appendChild(gridG);

    /* baseline */
    svg.appendChild(el('line', {
        x1: padL, x2: W - padR,
        y1: padT + plotH, y2: padT + plotH,
        stroke: 'rgba(255,255,255,0.08)', 'stroke-width': '1'
    }));

    /* ── smooth spline path ── */
    function spline(pts) {
        var d = 'M ' + pts[0].x + ' ' + pts[0].y;
        for (var i = 0; i < pts.length - 1; i++) {
            var p0 = pts[Math.max(i-1,0)];
            var p1 = pts[i];
            var p2 = pts[i+1];
            var p3 = pts[Math.min(i+2, pts.length-1)];
            var tension = 0.4;
            var cp1x = p1.x + (p2.x - p0.x) * tension / 2;
            var cp1y = p1.y + (p2.y - p0.y) * tension / 2;
            var cp2x = p2.x - (p3.x - p1.x) * tension / 2;
            var cp2y = p2.y - (p3.y - p1.y) * tension / 2;
            d += ' C ' + cp1x + ' ' + cp1y + ', ' + cp2x + ' ' + cp2y + ', ' + p2.x + ' ' + p2.y;
        }
        return d;
    }
    var linePath = spline(pts);
    var areaPath = linePath +
        ' L ' + pts[pts.length-1].x + ' ' + (padT + plotH) +
        ' L ' + pts[0].x + ' ' + (padT + plotH) + ' Z';

    /* area fill */
    var areaEl = el('path', { d: areaPath, fill: 'url(#dlg)' });
    areaEl.style.opacity = '0';
    areaEl.style.animation = 'dlFade 1s ease forwards 0.7s';
    svg.appendChild(areaEl);

    /* line stroke */
    var lineEl = el('path', {
        d: linePath, fill: 'none',
        stroke: '#cba86a', 'stroke-width': '2.5',
        'stroke-linecap': 'round', 'stroke-linejoin': 'round',
        filter: 'url(#dlglow)'
    });
    lineEl.style.strokeDasharray = '3000';
    lineEl.style.strokeDashoffset = '3000';
    lineEl.style.animation = 'dlDraw 1.6s cubic-bezier(0.19,1,0.22,1) forwards 0.1s';
    svg.appendChild(lineEl);

    /* ── x-axis labels (skip if too many) ── */
    var lblStep = raw.length > 10 ? 2 : 1;
    var lblG = el('g', {});
    pts.forEach(function(pt, i) {
        if (i % lblStep !== 0 && i !== pts.length - 1) return;
        lblG.appendChild(txt(pt.l, {
            x: pt.x, y: padT + plotH + 22,
            'text-anchor': 'middle', fill: '#4a5568',
            'font-size': '10', 'font-family': 'Outfit, sans-serif'
        }));
    });
    svg.appendChild(lblG);

    /* ── interactive dots ── */
    var tip     = document.getElementById('daily-tip');
    var tipLbl  = document.getElementById('daily-tip-lbl');
    var tipVal  = document.getElementById('daily-tip-val');
    var host    = document.getElementById('daily-host');

    var dotsG = el('g', {});
    pts.forEach(function(pt) {
        /* visible dot */
        var dot = el('circle', {
            cx: pt.x, cy: pt.y, r: '4',
            fill: '#111316', stroke: '#cba86a', 'stroke-width': '2'
        });
        dot.style.transition = 'r 0.2s, fill 0.2s';

        /* invisible large hit area */
        var hit = el('circle', {
            cx: pt.x, cy: pt.y, r: '18', fill: 'transparent'
        });
        hit.style.cursor = 'pointer';

        hit.addEventListener('mouseenter', function() {
            dot.setAttribute('r', '6');
            dot.setAttribute('fill', '#cba86a');
            tipLbl.textContent = pt.l;
            tipVal.textContent = pt.v > 0 ? 'LKR ' + pt.v.toLocaleString() : '—';
            /* position tooltip relative to svg host */
            var hostRect = host.getBoundingClientRect();
            var svgRect  = svg.getBoundingClientRect();
            var scaleX   = svgRect.width  / W;
            var scaleY   = svgRect.height / H;
            var tx = svgRect.left - hostRect.left + pt.x * scaleX;
            var ty = svgRect.top  - hostRect.top  + pt.y * scaleY;
            tip.style.left   = Math.min(tx - 60, hostRect.width - 150) + 'px';
            tip.style.top    = (ty - 64) + 'px';
            tip.style.opacity = '1';
        });
        hit.addEventListener('mouseleave', function() {
            dot.setAttribute('r', '4');
            dot.setAttribute('fill', '#111316');
            tip.style.opacity = '0';
        });

        dotsG.appendChild(dot);
        dotsG.appendChild(hit);
    });
    svg.appendChild(dotsG);

    /* ── keyframes ── */
    if (!document.getElementById('dl-kf')) {
        var s = document.createElement('style'); s.id = 'dl-kf';
        s.textContent =
            '@keyframes dlDraw{to{stroke-dashoffset:0}}' +
            '@keyframes dlFade{to{opacity:1}}';
        document.head.appendChild(s);
    }
})();
</script>

</body>
</html>

