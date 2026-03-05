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
ReportDAO reportDao = new ReportDAO();
ReservationDAO resDao = new ReservationDAO();
BigDecimal totalRevenue = reportDao.getTotalRevenue();
int totalBookings = reportDao.getTotalBookingsCount();
int todayCheckins = resDao.getCheckinCountForDate(java.time.LocalDate.now().toString());
int todayBookings = reportDao.getTodayBookingsCount();
java.math.BigDecimal avgBookingValue = reportDao.getAverageBookingValue();
Map<String, Integer> catStats = reportDao.getCategoryPerformance();
Map<String, java.math.BigDecimal> dailyTrend = reportDao.getDailyRevenueTrend();
List<String> auditLogs = reportDao.getRecentAuditLogs(10);
String loggedIn = (String) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Intelligence | OceanView Enterprise</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_ui.css">
    <link
        href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Playfair+Display:wght@700&display=swap"
        rel="stylesheet">
</head>

<body>

    <!-- ══════════════════════════════════════════════
 SIDEBAR
══════════════════════════════════════════════ -->
    <aside class="admin-sidebar">
        <div class="sidebar-brand">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                <polyline points="9 22 9 12 15 12 15 22" />
            </svg>
            <span>OceanView Admin</span>
        </div>
        <div class="sidebar-role">Administrator</div>
        <nav class="sidebar-nav">
            <a href="dashboard.jsp" class="nav-link active"><span
                    class="nav-icon">📊</span> Dashboard</a>
            <a href="manage_users.jsp" class="nav-link"> <span
                    class="nav-icon">👥</span> Staff Access</a>
            <a href="admin_ledger.jsp" class="nav-link"> <span
                    class="nav-icon">📋</span> Billing Ledger</a>
            <a href="help.jsp" class="nav-link"> <span class="nav-icon">📖</span>
                Guide</a>
            <div class="sidebar-divider"></div>
        </nav>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                    <polyline points="16 17 21 12 16 7" />
                    <line x1="21" y1="12" x2="9" y2="12" />
                </svg>
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
                <p>Welcome back, <strong style="color:white;">
                    <%= loggedIn %>
                </strong>. Real-time financial &amp; operational analytics.</p>
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
                    <span class="unit" style="font-size:0.85rem; margin-right:2px;">LKR</span>
                    <%= totalRevenue %>
                </div>
                <div class="kpi-sub">Total billed across all reservations</div>
            </div>
            <div class="kpi-card accent-blue">
                <div class="kpi-icon">📅</div>
                <div class="kpi-label">Total Reservation Volume</div>
                <div class="kpi-value">
                    <%= totalBookings %> <span class="unit">bookings</span>
                </div>
                <div class="kpi-sub">All-time confirmed reservations</div>
            </div>
            <div class="kpi-card accent-purple">
                <div class="kpi-icon">🚪</div>
                <div class="kpi-label">Today's Check-ins</div>
                <div class="kpi-value">
                    <%= todayCheckins %> <span class="unit">guests</span>
                </div>
                <div class="kpi-sub">Arrivals scheduled for today</div>
            </div>
        </div>
        <div class="grid grid-2" style="margin-bottom: 28px;">
            <div class="kpi-card accent-yellow">
                <div class="kpi-icon">📊</div>
                <div class="kpi-label">Avg. Booking Value</div>
                <div class="kpi-value">
                    <span class="unit" style="font-size:0.85rem; margin-right:2px;">LKR</span>
                    <%= avgBookingValue %>
                </div>
                <div class="kpi-sub">Average revenue per invoice</div>
            </div>
            <div class="kpi-card" style="border-top: 3px solid var(--admin-success);">
                <div class="kpi-icon">🗓️</div>
                <div class="kpi-label">Today's New Bookings</div>
                <div class="kpi-value">
                    <%= todayBookings %> <span class="unit">created</span>
                </div>
                <div class="kpi-sub">Reservations created today</div>
            </div>
        </div>

        <!-- Charts + Audit Console -->
        <div class="grid grid-2-3" style="margin-bottom: 28px;">

            <!-- Daily Revenue Line Chart -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="card-title">Daily Revenue Trend</div>
                        <div class="card-subtitle">Last 14 days — bookings by creation date</div>
                    </div>
                </div>
                <div style="position:relative; width:100%; height:240px; margin-top:8px;">
                    <!-- Tooltip -->
                    <div id="chart-tooltip" style="position:absolute;opacity:0;background:#181c22;border:1px solid rgba(203,168,106,0.3);padding:10px 16px;border-radius:8px;font-size:0.78rem;color:#f4f0e6;pointer-events:none;transition:opacity 0.18s;z-index:20;box-shadow:0 12px 40px rgba(0,0,0,0.5);white-space:nowrap;">
                        <div id="tt-label" style="color:#7a8290;font-size:0.65rem;text-transform:uppercase;letter-spacing:0.1em;margin-bottom:3px;"></div>
                        <div id="tt-val" style="color:#cba86a;font-weight:700;font-size:1.1rem;font-family:'Cormorant Garamond',serif;"></div>
                    </div>
                    <svg id="demand-chart" xmlns="http://www.w3.org/2000/svg"
                         style="display:block;width:100%;height:100%;"></svg>
                </div>
                <script>
                (function () {
                    var rawData = [
                        <%
                        boolean firstD = true;
                        for (Map.Entry<String, java.math.BigDecimal> entry : dailyTrend.entrySet()) {
                            if (!firstD) out.print(",");
                            out.print("{l:'" + entry.getKey() + "',v:" + entry.getValue().doubleValue() + "}");
                            firstD = false;
                        }
                        %>
                    ];
                    if (!rawData.length) return;

                    var W=900,H=200,padL=54,padR=18,padT=14,padB=32;
                    var plotW=W-padL-padR, plotH=H-padT-padB;
                    var svg=document.getElementById('demand-chart');
                    svg.setAttribute('viewBox','0 0 '+W+' '+H);
                    svg.setAttribute('preserveAspectRatio','xMidYMid meet');

                    function el(tag,a){var e=document.createElementNS('http://www.w3.org/2000/svg',tag);for(var k in a)e.setAttribute(k,a[k]);return e;}
                    function tx(t,a){var e=el('text',a);e.textContent=t;return e;}

                    var defs=el('defs',{});
                    var g=el('linearGradient',{id:'dg2',x1:'0',y1:'0',x2:'0',y2:'1'});
                    g.appendChild(el('stop',{offset:'0%','stop-color':'#cba86a','stop-opacity':'0.28'}));
                    g.appendChild(el('stop',{offset:'100%','stop-color':'#cba86a','stop-opacity':'0'}));
                    var fl=el('filter',{id:'dglow2',x:'-30%',y:'-30%',width:'160%',height:'160%'});
                    var fb=el('feGaussianBlur',{stdDeviation:'3',result:'b'});
                    fl.appendChild(fb);fl.appendChild(el('feComposite',{in:'SourceGraphic',in2:'b',operator:'over'}));
                    defs.appendChild(g);defs.appendChild(fl);svg.appendChild(defs);

                    var maxV=0; rawData.forEach(function(d){if(d.v>maxV)maxV=d.v;}); if(maxV===0)maxV=1;
                    var step=plotW/Math.max(rawData.length-1,1);
                    var pts=rawData.map(function(d,i){return{l:d.l,v:d.v,x:padL+i*step,y:padT+plotH-(d.v/maxV)*plotH};});

                    // grid
                    var gg=el('g',{});
                    [0,0.25,0.5,0.75,1].forEach(function(p){
                        var gy=padT+plotH-p*plotH;
                        gg.appendChild(el('line',{x1:padL,x2:W-padR,y1:gy,y2:gy,stroke:'rgba(255,255,255,0.05)','stroke-width':'1'}));
                        gg.appendChild(tx(Math.round(maxV*p/1000)+'k',{x:padL-6,y:gy+4,'text-anchor':'end',fill:'#475569','font-size':'10','font-family':'Outfit,sans-serif'}));
                    });
                    svg.appendChild(gg);
                    svg.appendChild(el('line',{x1:padL,x2:W-padR,y1:padT+plotH,y2:padT+plotH,stroke:'rgba(255,255,255,0.08)','stroke-width':'1'}));

                    // spline
                    function sp(pts){
                        var d='M '+pts[0].x+' '+pts[0].y;
                        for(var i=0;i<pts.length-1;i++){
                            var p0=pts[Math.max(i-1,0)],p1=pts[i],p2=pts[i+1],p3=pts[Math.min(i+2,pts.length-1)];
                            var t=0.4,c1x=p1.x+(p2.x-p0.x)*t/2,c1y=p1.y+(p2.y-p0.y)*t/2,c2x=p2.x-(p3.x-p1.x)*t/2,c2y=p2.y-(p3.y-p1.y)*t/2;
                            d+=' C '+c1x+' '+c1y+','+c2x+' '+c2y+','+p2.x+' '+p2.y;
                        }
                        return d;
                    }
                    var lp=sp(pts),ap=lp+' L '+pts[pts.length-1].x+' '+(padT+plotH)+' L '+pts[0].x+' '+(padT+plotH)+' Z';
                    var ae=el('path',{d:ap,fill:'url(#dg2)'});ae.style.opacity='0';ae.style.animation='dcFade 1s ease forwards 0.7s';svg.appendChild(ae);
                    var le=el('path',{d:lp,fill:'none',stroke:'#cba86a','stroke-width':'2.5','stroke-linecap':'round','stroke-linejoin':'round',filter:'url(#dglow2)'});
                    le.style.strokeDasharray='3000';le.style.strokeDashoffset='3000';le.style.animation='dcDraw 1.6s cubic-bezier(0.19,1,0.22,1) forwards 0.1s';
                    svg.appendChild(le);

                    // x-labels (every 2nd)
                    var lg=el('g',{});
                    pts.forEach(function(pt,i){
                        if(i%2!==0&&i!==pts.length-1)return;
                        lg.appendChild(tx(pt.l,{x:pt.x,y:padT+plotH+22,'text-anchor':'middle',fill:'#4a5568','font-size':'10','font-family':'Outfit,sans-serif'}));
                    });
                    svg.appendChild(lg);

                    // dots + tooltips
                    var tip=document.getElementById('chart-tooltip'),ttL=document.getElementById('tt-label'),ttV=document.getElementById('tt-val');
                    var wrap=svg.parentElement;
                    var dg=el('g',{});
                    pts.forEach(function(pt){
                        var dot=el('circle',{cx:pt.x,cy:pt.y,r:'4',fill:'#111316',stroke:'#cba86a','stroke-width':'2'});
                        dot.style.transition='r 0.2s,fill 0.2s';
                        var hit=el('circle',{cx:pt.x,cy:pt.y,r:'18',fill:'transparent'});hit.style.cursor='pointer';
                        hit.addEventListener('mouseenter',function(){
                            dot.setAttribute('r','6');dot.setAttribute('fill','#cba86a');
                            ttL.textContent=pt.l;ttV.textContent=pt.v>0?'LKR '+pt.v.toLocaleString():'—';
                            var wr=wrap.getBoundingClientRect(),sr=svg.getBoundingClientRect();
                            var tx2=(pt.x/W)*sr.width+(sr.left-wr.left),ty2=(pt.y/H)*sr.height+(sr.top-wr.top);
                            tip.style.left=Math.min(tx2-60,wr.width-150)+'px';
                            tip.style.top=(ty2-64)+'px';tip.style.opacity='1';
                        });
                        hit.addEventListener('mouseleave',function(){dot.setAttribute('r','4');dot.setAttribute('fill','#111316');tip.style.opacity='0';});
                        dg.appendChild(dot);dg.appendChild(hit);
                    });
                    svg.appendChild(dg);

                    if(!document.getElementById('dc-kf')){
                        var s=document.createElement('style');s.id='dc-kf';
                        s.textContent='@keyframes dcDraw{to{stroke-dashoffset:0}}@keyframes dcFade{to{opacity:1}}';
                        document.head.appendChild(s);
                    }
                })();
                </script>
            </div>

            <!-- Live Audit Console -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="card-title">Live Audit Console</div>
                        <div class="card-subtitle">MySQL trigger events — real-time log
                            stream</div>
                    </div>
                </div>
                <div class="audit-wrap">
                    <% if (auditLogs.isEmpty()) { %>
                    <div class="audit-empty">SYSTEM_INIT :: Awaiting database
                        trigger events...</div>
                    <% } else { for (String log : auditLogs) { int
                        closeIdx=log.indexOf(']'); String ts=log.substring(0,
                        closeIdx + 1); String rest=log.substring(closeIdx +
                        1).trim(); int dashIdx=rest.indexOf(" - ");
    String type = dashIdx >= 0 ? rest.substring(0, dashIdx).trim() : rest;
    String desc = dashIdx >= 0 ? rest.substring(dashIdx + 3).trim() : "";
%>
                    <div class=" audit-line">
                        <span class="audit-ts">
                            <%= ts %>
                        </span>
                        <span class="audit-type">
                            <%= type %>
                        </span>
                        <% if (!desc.isEmpty()) { %>
                        <span class="audit-desc"> &mdash; <%= desc %></span>
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
                <div class="kpi-card accent-yellow"
                    style="cursor:pointer; display:flex; align-items:center; gap:16px;">
                    <div style="font-size:2.5rem;">👥</div>
                    <div>
                        <div class="kpi-label">User Management</div>
                        <div
                            style="font-size:0.95rem; font-weight:700; color:var(--admin-accent); margin-top:4px;">
                            Manage Accounts →</div>
                        <div class="kpi-sub">View and manage system account roles</div>
                    </div>
                </div>
            </a>
            <a href="admin_ledger.jsp" style="text-decoration:none;">
                <div class="kpi-card accent-blue"
                    style="cursor:pointer; display:flex; align-items:center; gap:16px;">
                    <div style="font-size:2.5rem;">📋</div>
                    <div>
                        <div class="kpi-label">Billing Ledger</div>
                        <div
                            style="font-size:0.95rem; font-weight:700; color:var(--admin-accent); margin-top:4px;">
                            View Ledger →</div>
                        <div class="kpi-sub">Full reservation and billing records</div>
                    </div>
                </div>
            </a>
        </div>

    </main>
</body>

</html>
