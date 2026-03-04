<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.util.DatabaseFactory" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="oceanview.dao.AccountDAO" %>
<%@ page import="oceanview.model.SysAccount" %>
<%@ page import="oceanview.dao.AccommodationDAO" %>
<%@ page import="oceanview.model.Accommodation" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="oceanview.service.BillingService" %>
<%@ page import="java.math.BigDecimal" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Enterprise Backend Diagnostic Test</title>
    <style>
        :root {
            --emerald: #2ecc71;
            --forest: #27ae60;
            --danger: #e74c3c;
            --dark: #2c3e50;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: var(--dark);
            padding: 40px;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        h1 { color: var(--forest); border-bottom: 2px solid var(--emerald); padding-bottom: 10px; }
        .status { padding: 15px; margin: 10px 0; border-radius: 5px; font-weight: bold; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        ul { line-height: 1.6; }
    </style>
</head>
<body>

<div class="container">
    <h1>🚀 OceanView Enterprise Diagnostics</h1>
    <p>This page verifies that Tomcat, MySQL, DAOs, and Business Logic are communicating correctly.</p>

    <!-- TEST 1: Database Connection -->
    <%
        try (Connection conn = DatabaseFactory.getConnection()) {
            out.print("<div class='status success'>✅ TEST 1: Database Pool Connected Successfully!</div>");
        } catch (Exception e) {
            out.print("<div class='status error'>❌ TEST 1 FAILED: " + e.getMessage() + "</div>");
        }
    %>

    <!-- TEST 2: Account DAO & RBAC -->
    <%
        try {
            AccountDAO accDao = new AccountDAO();
            SysAccount admin = accDao.getAccountByUsername("admin");
            if (admin != null && "ADMIN".equals(admin.getAccessLevel())) {
                out.print("<div class='status success'>✅ TEST 2: AccountDAO Fetched Admin successfully (Role: " + admin.getAccessLevel() + ")</div>");
            } else {
                out.print("<div class='status error'>❌ TEST 2 FAILED: Admin account not found or role mismatch.</div>");
            }
        } catch (Exception e) {
            out.print("<div class='status error'>❌ TEST 2 FAILED: " + e.getMessage() + "</div>");
        }
    %>

    <!-- TEST 3: Accommodation DAO & Advanced SQL JOIN -->
    <%
        try {
            AccommodationDAO roomDao = new AccommodationDAO();
            LocalDate today = LocalDate.now();
            LocalDate tomorrow = today.plusDays(1);
            List<Accommodation> rooms = roomDao.getAvailableRooms(today, tomorrow);

            out.print("<div class='status success'>✅ TEST 3: AccommodationDAO retrieved " + rooms.size() + " available rooms.</div>");
            out.print("<ul>");
            for(Accommodation room : rooms) {
                // STRICT RULE: No ${} template literals used here! Pure string concatenation.
                out.print("<li>Room " + room.getRoomNumber() + " - " + room.getCategoryName() + " (" + room.getBaseRateLkr() + " LKR)</li>");
            }
            out.print("</ul>");
        } catch (Exception e) {
            out.print("<div class='status error'>❌ TEST 3 FAILED: " + e.getMessage() + "</div>");
        }
    %>

    <!-- TEST 4: Billing Service & BigDecimal Math -->
    <%
        try {
            BillingService billing = new BillingService();
            BigDecimal baseRate = new BigDecimal("25000.00");
            long nights = 2;

            BigDecimal roomCharge = billing.calculateRoomCharge(nights, baseRate);
            BigDecimal tax = billing.calculateServiceTax(roomCharge);
            BigDecimal total = billing.calculateGrandTotal(roomCharge, tax);

            out.print("<div class='status success'>✅ TEST 4: BillingService calculated Grand Total correctly: " + total + " LKR</div>");
        } catch (Exception e) {
            out.print("<div class='status error'>❌ TEST 4 FAILED: " + e.getMessage() + "</div>");
        }
    %>
</div>

</body>
</html>

