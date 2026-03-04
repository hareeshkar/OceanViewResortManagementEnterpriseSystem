<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.ReservationDAO" %>
<%@ page import="oceanview.model.InvoiceDTO" %>
<%
    String idStr = request.getParameter("id");
    if(idStr == null) { response.sendRedirect("view_bookings.jsp"); return; }

    ReservationDAO dao = new ReservationDAO();
    InvoiceDTO inv = dao.getInvoiceDetails(Integer.parseInt(idStr));
    if(inv == null) { response.sendRedirect("view_bookings.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invoice <%= inv.getInvoiceNumber() %></title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding: 40px; color: #333; }
        .invoice-box { max-width: 800px; margin: auto; padding: 30px; border: 1px solid #eee; box-shadow: 0 0 10px rgba(0, 0, 0, 0.15); }
        .header { display: flex; justify-content: space-between; border-bottom: 2px solid #2ecc71; padding-bottom: 20px; margin-bottom: 30px; }
        .header h1 { color: #27ae60; margin: 0; }

        .details-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-bottom: 30px; }
        .details h3 { margin-bottom: 10px; color: #2c3e50; border-bottom: 1px solid #eee; padding-bottom: 5px; }

        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th, td { padding: 12px; text-align: right; border-bottom: 1px solid #eee; }
        th { background: #f8f9fa; color: #2c3e50; }
        th:first-child, td:first-child { text-align: left; }

        .totals-grid { display: grid; grid-template-columns: 1fr 300px; }
        .total-box { background: #f8f9fa; padding: 20px; border-radius: 5px; }
        .total-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 16px; }
        .total-row.grand { font-size: 20px; font-weight: bold; color: #27ae60; border-top: 2px solid #ccc; padding-top: 10px; }

        .controls { text-align: center; margin-top: 30px; }
        .btn { padding: 12px 25px; font-size: 16px; border: none; cursor: pointer; border-radius: 5px; font-weight: bold; }
        .btn-print { background: #2980b9; color: white; }
        .btn-back { background: #95a5a6; color: white; text-decoration: none; }

        /* 🖨️ STRICT PRINTING RULE APPLIED */
        @media print {
            body { padding: 0; background: white; }
            .invoice-box { border: none; box-shadow: none; max-width: 100%; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body>
    <div class="controls no-print" style="margin-bottom:20px; text-align:left;">
        <a href="view_bookings.jsp" class="btn btn-back">← Back to Ledger</a>
    </div>

    <div class="invoice-box">
        <div class="header">
            <div>
                <h1>OceanView Resort</h1>
                <p>123 Beach Road, Galle, Sri Lanka<br>Tel: +94 77 123 4567</p>
            </div>
            <div style="text-align: right;">
                <h2 style="color:#7f8c8d; margin:0;">INVOICE</h2>
                <p><strong>Ref:</strong> <%= inv.getInvoiceNumber() %><br>
                <strong>Date:</strong> <%= java.time.LocalDate.now() %></p>
            </div>
        </div>

        <div class="details-grid">
            <div class="details">
                <h3>Billed To:</h3>
                <p><strong><%= inv.getGuestName() %></strong><br>
                <%= inv.getAddress() %><br>
                Tel: <%= inv.getPhone() %></p>
            </div>
            <div class="details">
                <h3>Reservation Info:</h3>
                <p><strong>Booking Ref:</strong> <%= inv.getBookingRef() %><br>
                <strong>Check-In:</strong> <%= inv.getArrival() %><br>
                <strong>Check-Out:</strong> <%= inv.getDeparture() %></p>
            </div>
        </div>

        <table>
            <tr>
                <th>Description</th>
                <th>Rate (LKR)</th>
                <th>Nights</th>
                <th>Amount (LKR)</th>
            </tr>
            <tr>
                <td>Accommodation - Room <%= inv.getRoomNumber() %><br>
                <small>(<%= inv.getCategoryName() %>)</small></td>
                <td><%= inv.getBaseRate() %></td>
                <td><%= inv.getNights() %></td>
                <td><%= inv.getRoomCharge() %></td>
            </tr>
        </table>

        <div class="totals-grid">
            <div></div> <!-- Empty spacer -->
            <div class="total-box">
                <div class="total-row"><span>Subtotal:</span> <span><%= inv.getRoomCharge() %></span></div>
                <div class="total-row"><span>Service Tax (5%):</span> <span><%= inv.getTax() %></span></div>
                <div class="total-row grand"><span>GRAND TOTAL:</span> <span>LKR <%= inv.getGrandTotal() %></span></div>
            </div>
        </div>

        <p style="text-align:center; margin-top:50px; color:#7f8c8d; font-size:12px;">Thank you for choosing OceanView Resort. This is a computer generated invoice.</p>
    </div>

    <!-- The Print Button uses pure JS window.print() -->
    <div class="controls no-print">
        <button onclick="window.print()" class="btn btn-print">🖨️ Print Official Invoice</button>
    </div>
</body>
</html>
