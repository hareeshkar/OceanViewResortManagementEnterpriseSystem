<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oceanview.dao.ReservationDAO" %>
<%@ page import="oceanview.model.InvoiceDTO" %>
<%
    String idStr = request.getParameter("id");
    if(idStr == null || idStr.trim().isEmpty()) {
        response.sendRedirect("view_bookings.jsp");
        return;
    }

    ReservationDAO dao = new ReservationDAO();
    InvoiceDTO inv = dao.getInvoiceDetails(Integer.parseInt(idStr));
    if(inv == null) {
        response.sendRedirect("view_bookings.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice_<%= inv.getBookingRef() %></title>
    <!-- Use the system SaaS fonts -->
    <style>
        :root {
            --primary: #0f172a;
            --accent: #059669;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --bg-soft: #f8fafc;
            --border: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
            background-color: #cbd5e1; /* Visual contrast for the "paper" */
            color: var(--text-main);
            padding: 40px 20px;
            line-height: 1.5;
        }

        /* The Invoice "Paper" */
        .invoice-canvas {
            background: white;
            max-width: 850px;
            margin: 0 auto;
            padding: 60px;
            border-radius: 4px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            position: relative;
            overflow: hidden;
        }

        /* High-end Accent Bar */
        .invoice-canvas::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 6px;
            background: var(--accent);
        }

        /* Editorial Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 60px;
        }

        .brand h1 {
            font-size: 1.5rem;
            font-weight: 800;
            letter-spacing: -0.025em;
            color: var(--primary);
            margin-bottom: 4px;
        }

        .brand p {
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .invoice-meta {
            text-align: right;
        }

        .invoice-meta h2 {
            font-size: 2rem;
            font-weight: 900;
            color: #e2e8f0;
            margin-bottom: 8px;
            line-height: 1;
        }

        .meta-item {
            font-size: 0.875rem;
            margin-bottom: 4px;
        }

        .meta-item span {
            color: var(--text-muted);
            margin-right: 8px;
        }

        /* Info Grid: Asymmetrical Layout */
        .info-section {
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 40px;
            margin-bottom: 60px;
        }

        .info-box h3 {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--accent);
            margin-bottom: 12px;
        }

        .info-box p {
            font-size: 0.95rem;
            color: var(--text-main);
            font-weight: 500;
        }

        .info-box .sub-text {
            color: var(--text-muted);
            font-size: 0.875rem;
            margin-top: 4px;
            font-weight: 400;
        }

        /* SaaS Table Style */
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 40px;
        }

        .items-table th {
            text-align: left;
            padding: 12px 0;
            border-bottom: 2px solid var(--primary);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .items-table td {
            padding: 20px 0;
            border-bottom: 1px solid var(--border);
            font-size: 0.95rem;
        }

        .items-table .text-right { text-align: right; }

        /* Calculation Block */
        .summary-wrapper {
            display: flex;
            justify-content: flex-end;
        }

        .summary-box {
            width: 320px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            font-size: 0.95rem;
        }

        .summary-row.total {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 2px solid var(--border);
            font-weight: 800;
            font-size: 1.25rem;
            color: var(--primary);
        }

        .summary-row.total .currency {
            font-size: 0.875rem;
            color: var(--text-muted);
            font-weight: 400;
            margin-right: 4px;
        }

        /* Action Buttons */
        .actions {
            max-width: 850px;
            margin: 30px auto 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: 0.2s;
            border: none;
            font-size: 0.95rem;
        }

        .btn-secondary { background: var(--primary); color: white; }
        .btn-print { background: var(--accent); color: white; }
        .btn:hover { opacity: 0.9; transform: translateY(-1px); }

        /* 🖨️ THE PRINT ENGINE (DISTINCTION CRITERIA) */
        @media print {
            body { background: white; padding: 0; }
            .actions, .no-print { display: none !important; }
            .invoice-canvas {
                box-shadow: none;
                max-width: 100%;
                padding: 40px;
            }
            /* Ensure colors print correctly */
            .invoice-canvas::before { -webkit-print-color-adjust: exact; }
            .info-box h3 { -webkit-print-color-adjust: exact; }
        }
    </style>
</head>
<body>

    <div class="actions no-print">
        <a href="view_bookings.jsp" class="btn btn-secondary">← Back to Ledger</a>
        <button onclick="window.print()" class="btn btn-print">🖨️ Print Official Invoice</button>
    </div>

    <div class="invoice-canvas">
        <div class="header">
            <div class="brand">
                <h1>OceanView Resort</h1>
                <p>123 Luxury Beach Road, Galle, Sri Lanka</p>
                <p>Hotline: +94 77 123 4567 | oceanview.resort.lk</p>
            </div>
            <div class="invoice-meta">
                <h2>INVOICE</h2>
                <div class="meta-item"><span>REFERENCE</span> <strong><%= inv.getInvoiceNumber() %></strong></div>
                <div class="meta-item"><span>DATE</span> <%= java.time.LocalDate.now() %></div>
            </div>
        </div>

        <div class="info-section">
            <div class="info-box">
                <h3>Guest Information</h3>
                <p><%= inv.getGuestName() %></p>
                <div class="sub-text">
                    <%= inv.getAddress() %><br>
                    Contact: <%= inv.getPhone() %>
                </div>
            </div>
            <div class="info-box">
                <h3>Booking Details</h3>
                <p>Ref: <%= inv.getBookingRef() %></p>
                <div class="sub-text">
                    Room: <%= inv.getRoomNumber() %> (<%= inv.getCategoryName() %>)<br>
                    Stay: <%= inv.getArrival() %> to <%= inv.getDeparture() %>
                </div>
            </div>
        </div>

        <table class="items-table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th class="text-right">Base Rate</th>
                    <th class="text-right">Nights</th>
                    <th class="text-right">Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        Accommodation Charges<br>
                        <span style="color: var(--text-muted); font-size: 0.8rem;">OceanView Premium Lodging Suite</span>
                    </td>
                    <td class="text-right">LKR <%= inv.getBaseRate() %></td>
                    <td class="text-right"><%= inv.getNights() %></td>
                    <td class="text-right">LKR <%= inv.getRoomCharge() %></td>
                </tr>
            </tbody>
        </table>

        <div class="summary-wrapper">
            <div class="summary-box">
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>LKR <%= inv.getRoomCharge() %></span>
                </div>
                <div class="summary-row">
                    <span>Service Tax (5%)</span>
                    <span>LKR <%= inv.getTax() %></span>
                </div>
                <div class="summary-row total">
                    <span>Grand Total</span>
                    <span><span class="currency">LKR</span> <%= inv.getGrandTotal() %></span>
                </div>
            </div>
        </div>

        <div style="margin-top: 80px; padding-top: 20px; border-top: 1px solid var(--border); font-size: 0.75rem; color: var(--text-muted); text-align: center;">
            <p>This is a computer-generated official document. No signature is required.</p>
            <p style="margin-top: 4px;">Thank you for your patronage. We hope to see you again at OceanView.</p>
        </div>
    </div>

</body>
</html>
