<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="oceanview.dao.ReservationDAO" %>
        <%@ page import="oceanview.model.InvoiceDTO" %>
            <% String idStr=request.getParameter("id"); if(idStr==null || idStr.trim().isEmpty()) {
                response.sendRedirect("view_bookings.jsp"); return; } ReservationDAO dao=new ReservationDAO();
                InvoiceDTO inv=dao.getInvoiceDetails(Integer.parseInt(idStr)); if(inv==null) {
                response.sendRedirect("view_bookings.jsp"); return; } %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <title>Invoice_<%= inv.getBookingRef() %>
                    </title>
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500&family=Outfit:wght@200;300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <style>
                        :root {
                            --primary: #0b0d10;
                            --accent: #cba86a;
                            --accent-hover: #dfc08a;
                            --text-main: #f4f0e6;
                            --text-muted: #7a8290;
                            --bg: #111316;
                            --bg-card: rgba(20, 23, 27, 0.8);
                            --border: rgba(255, 255, 255, 0.06);
                            --border-accent: rgba(203, 168, 106, 0.15);
                            --font-display: 'Cormorant Garamond', serif;
                            --font-sans: 'Outfit', system-ui, sans-serif;
                            --ease: cubic-bezier(0.19, 1, 0.22, 1);
                        }

                        * {
                            box-sizing: border-box;
                            margin: 0;
                            padding: 0;
                        }

                        body {
                            font-family: var(--font-sans);
                            background-color: var(--bg);
                            color: var(--text-main);
                            padding: 40px 20px;
                            line-height: 1.5;
                            -webkit-font-smoothing: antialiased;
                        }

                        ::selection {
                            background: rgba(203, 168, 106, 0.3);
                            color: #fff;
                        }

                        /* The Invoice "Paper" */
                        .invoice-canvas {
                            background: var(--bg-card);
                            max-width: 850px;
                            margin: 0 auto;
                            padding: 60px;
                            border-radius: 12px;
                            border: 1px solid var(--border);
                            backdrop-filter: blur(12px);
                            -webkit-backdrop-filter: blur(12px);
                            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
                            position: relative;
                            overflow: hidden;
                        }

                        /* Accent Bar */
                        .invoice-canvas::before {
                            content: "";
                            position: absolute;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 3px;
                            background: linear-gradient(90deg, var(--accent), var(--accent-hover));
                        }

                        /* Editorial Header */
                        .header {
                            display: flex;
                            justify-content: space-between;
                            align-items: flex-start;
                            margin-bottom: 60px;
                        }

                        .brand h1 {
                            font-family: var(--font-display);
                            font-size: 1.8rem;
                            font-weight: 400;
                            letter-spacing: -0.02em;
                            color: var(--text-main);
                            margin-bottom: 4px;
                        }

                        .brand p {
                            font-size: 0.85rem;
                            color: var(--text-muted);
                        }

                        .invoice-meta {
                            text-align: right;
                        }

                        .invoice-meta h2 {
                            font-family: var(--font-display);
                            font-size: 2rem;
                            font-weight: 300;
                            color: rgba(255, 255, 255, 0.08);
                            margin-bottom: 8px;
                            line-height: 1;
                            letter-spacing: 0.1em;
                        }

                        .meta-item {
                            font-size: 0.85rem;
                            margin-bottom: 4px;
                            color: var(--text-main);
                        }

                        .meta-item span {
                            color: var(--text-muted);
                            margin-right: 8px;
                            font-size: 0.7rem;
                            text-transform: uppercase;
                            letter-spacing: 0.08em;
                        }

                        /* Info Grid */
                        .info-section {
                            display: grid;
                            grid-template-columns: 1.5fr 1fr;
                            gap: 40px;
                            margin-bottom: 60px;
                        }

                        .info-box h3 {
                            font-size: 0.68rem;
                            font-weight: 600;
                            text-transform: uppercase;
                            letter-spacing: 0.12em;
                            color: var(--accent);
                            margin-bottom: 12px;
                        }

                        .info-box p {
                            font-size: 0.95rem;
                            color: var(--text-main);
                            font-weight: 400;
                        }

                        .info-box .sub-text {
                            color: var(--text-muted);
                            font-size: 0.85rem;
                            margin-top: 4px;
                            font-weight: 300;
                        }

                        /* Table */
                        .items-table {
                            width: 100%;
                            border-collapse: collapse;
                            margin-bottom: 40px;
                        }

                        .items-table th {
                            text-align: left;
                            padding: 12px 0;
                            border-bottom: 1px solid var(--border-accent);
                            font-size: 0.68rem;
                            font-weight: 600;
                            text-transform: uppercase;
                            letter-spacing: 0.08em;
                            color: var(--text-muted);
                        }

                        .items-table td {
                            padding: 20px 0;
                            border-bottom: 1px solid var(--border);
                            font-size: 0.95rem;
                            color: var(--text-main);
                        }

                        .items-table .text-right {
                            text-align: right;
                        }

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
                            color: var(--text-muted);
                        }

                        .summary-row.total {
                            margin-top: 16px;
                            padding-top: 16px;
                            border-top: 1px solid var(--border-accent);
                            font-weight: 600;
                            font-size: 1.25rem;
                            color: var(--text-main);
                        }

                        .summary-row.total .currency {
                            font-size: 0.85rem;
                            color: var(--text-muted);
                            font-weight: 300;
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
                            font-weight: 500;
                            text-decoration: none;
                            cursor: pointer;
                            transition: all 0.35s var(--ease);
                            border: 1px solid;
                            font-size: 0.88rem;
                            font-family: var(--font-sans);
                        }

                        .btn-secondary {
                            background: transparent;
                            color: var(--text-main);
                            border-color: var(--border);
                        }

                        .btn-secondary:hover {
                            border-color: var(--accent);
                            color: var(--accent);
                        }

                        .btn-print {
                            background: transparent;
                            color: var(--accent);
                            border-color: var(--accent);
                        }

                        .btn-print:hover {
                            background: var(--accent);
                            color: var(--primary);
                        }

                        /* Print */
                        @media print {
                            body {
                                background: white;
                                padding: 0;
                                color: #333;
                            }

                            .actions,
                            .no-print {
                                display: none !important;
                            }

                            .invoice-canvas {
                                box-shadow: none;
                                max-width: 100%;
                                padding: 40px;
                                backdrop-filter: none;
                                background: white;
                                border: none;
                                color: #333;
                            }

                            .invoice-canvas::before {
                                -webkit-print-color-adjust: exact;
                                print-color-adjust: exact;
                            }

                            .info-box h3 {
                                -webkit-print-color-adjust: exact;
                                print-color-adjust: exact;
                                color: #b8963e;
                            }

                            .brand h1,
                            .meta-item,
                            .info-box p,
                            .items-table td,
                            .summary-row.total {
                                color: #333;
                            }

                            .brand p,
                            .meta-item span,
                            .info-box .sub-text,
                            .summary-row,
                            .items-table th,
                            .text-muted {
                                color: #666;
                            }

                            .items-table th {
                                border-bottom-color: #ddd;
                            }

                            .items-table td {
                                border-bottom-color: #eee;
                            }

                            .summary-row.total {
                                border-top-color: #ddd;
                            }
                        }

                        @keyframes fadeUp {
                            from {
                                opacity: 0;
                                transform: translateY(12px);
                            }

                            to {
                                opacity: 1;
                                transform: translateY(0);
                            }
                        }

                        body {
                            animation: fadeUp 0.5s var(--ease) forwards;
                        }
                    </style>
                </head>

                <body>

                    <div class="actions no-print">
                        <a href="view_bookings.jsp" class="btn btn-secondary">← Back to Ledger</a>
                        <button onclick="window.print()" class="btn btn-print">Print Official Invoice</button>
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
                                <div class="meta-item"><span>Reference</span> <strong>
                                        <%= inv.getInvoiceNumber() %>
                                    </strong></div>
                                <div class="meta-item"><span>Date</span>
                                    <%= java.time.LocalDate.now() %>
                                </div>
                            </div>
                        </div>

                        <div class="info-section">
                            <div class="info-box">
                                <h3>Guest Information</h3>
                                <p>
                                    <%= inv.getGuestName() %>
                                </p>
                                <div class="sub-text">
                                    <%= inv.getAddress() %><br>
                                        Contact: <%= inv.getPhone() %>
                                </div>
                            </div>
                            <div class="info-box">
                                <h3>Booking Details</h3>
                                <p>Ref: <%= inv.getBookingRef() %>
                                </p>
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
                                        <span style="color: var(--text-muted); font-size: 0.8rem;">OceanView Premium
                                            Lodging Suite</span>
                                    </td>
                                    <td class="text-right">LKR <%= inv.getBaseRate() %>
                                    </td>
                                    <td class="text-right">
                                        <%= inv.getNights() %>
                                    </td>
                                    <td class="text-right">LKR <%= inv.getRoomCharge() %>
                                    </td>
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
                                    <span><span class="currency">LKR</span>
                                        <%= inv.getGrandTotal() %>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div
                            style="margin-top: 80px; padding-top: 20px; border-top: 1px solid var(--border); font-size: 0.75rem; color: var(--text-muted); text-align: center;">
                            <p>This is a computer-generated official document. No signature is required.</p>
                            <p style="margin-top: 4px;">Thank you for your patronage. We hope to see you again at
                                OceanView.</p>
                        </div>
                    </div>

                </body>

                </html>