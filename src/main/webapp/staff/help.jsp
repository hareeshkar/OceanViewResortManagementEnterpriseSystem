<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Staff Guidelines | OceanView</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/elite_ui.css">
        <link
            href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Playfair+Display:wght@700&display=swap"
            rel="stylesheet">
        <style>
            .help-card {
                max-width: 900px;
                margin: 0 auto;
                padding: 40px;
            }

            .help-card h1 {
                color: var(--accent-gold, #cba86a);
                border-bottom: 1px solid rgba(203, 168, 106, 0.15);
                padding-bottom: 10px;
                margin-bottom: 20px;
                font-family: var(--font-heading, 'Cormorant Garamond', serif);
                font-weight: 400;
                font-size: 1.8rem;
            }

            .toc {
                background: rgba(255, 255, 255, 0.02);
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
                border: 1px solid rgba(255, 255, 255, 0.06);
            }

            .toc h3 {
                margin-bottom: 10px;
                font-family: var(--font-heading, 'Cormorant Garamond', serif);
                color: var(--text-main, #f4f0e6);
                font-weight: 400;
            }

            .toc ol {
                margin-left: 20px;
            }

            .toc a {
                color: var(--accent-gold, #cba86a);
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s ease;
            }

            .toc a:hover {
                color: var(--accent-gold-hover, #dfc08a);
            }

            section h2 {
                color: var(--accent-gold, #cba86a);
                margin-top: 30px;
                margin-bottom: 15px;
                font-family: var(--font-heading, 'Cormorant Garamond', serif);
                font-weight: 400;
                font-size: 1.4rem;
            }

            ul {
                margin-left: 20px;
                margin-bottom: 20px;
            }

            li {
                margin-bottom: 8px;
                color: var(--text-muted, #7a8290);
            }

            p {
                margin-bottom: 15px;
                color: var(--text-muted, #7a8290);
            }
        </style>
    </head>

    <body class="animate-in">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>OceanView</h2>
            </div>
            <nav class="nav-menu">
                <a href="dashboard.jsp" class="nav-item"><i>📅</i> Dashboard</a>
                <a href="view_bookings.jsp" class="nav-item"><i>📋</i> All Bookings</a>
                <a href="help.jsp" class="nav-item active"><i>📖</i> Guidelines</a>
            </nav>
            <div class="logout-container">
                <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
            </div>
        </aside>

        <main class="main-wrapper">
            <div class="card help-card">
                <h1>📖 Staff Guidelines</h1>

                <div class="toc">
                    <h3>Contents</h3>
                    <ol>
                        <li><a href="#new-booking">Creating a New Reservation</a></li>
                        <li><a href="#view-invoice">Viewing and Printing Invoices</a></li>
                        <li><a href="#policies">Billing Policies and Tax</a></li>
                        <li><a href="#troubleshooting">Help and Support</a></li>
                    </ol>
                </div>

                <section id="new-booking">
                    <h2>1. Creating a New Reservation</h2>
                    <p>To prevent double-bookings and ensure smooth operations, follow these steps:</p>
                    <ul>
                        <li>Navigate to the <strong>Dashboard</strong> to start a new reservation.</li>
                        <li>Enter the guest's 10-digit phone number starting with '0' (e.g., 07XXXXXXXX).</li>
                        <li>Select the <strong>Arrival</strong> and <strong>Departure</strong> dates. The system
                            prevents selecting past dates.</li>
                        <li>Choose a <strong>Room Category</strong>; the system will display available rooms for those
                            dates.</li>
                        <li>Select a room and click "Confirm Reservation" to complete the booking.</li>
                    </ul>
                </section>

                <section id="view-invoice">
                    <h2>2. Viewing and Printing Invoices</h2>
                    <p>All booking records are maintained in the system and can be accessed anytime:</p>
                    <ul>
                        <li>Go to <strong>All Bookings</strong> to view the complete reservation history.</li>
                        <li>Click the "Invoice" button next to any booking to view the billing details.</li>
                        <li>Use your browser's print function (Ctrl + P or Cmd + P) to print the invoice on A4 paper.
                        </li>
                    </ul>
                </section>

                <section id="policies">
                    <h2>3. Billing Policies and Tax</h2>
                    <p>The system automatically calculates all costs according to these rules:</p>
                    <ul>
                        <li><strong>Stay Duration:</strong> Calculated as the number of nights between arrival and
                            departure dates.</li>
                        <li><strong>Service Tax:</strong> A mandatory 5% service charge is applied to the room rate.
                        </li>
                        <li><strong>Currency:</strong> All amounts are in LKR and calculated with high precision using
                            BigDecimal.</li>
                    </ul>
                </section>

                <section id="troubleshooting">
                    <h2>4. Help and Support</h2>
                    <p>If you encounter issues, try refreshing the page. If you cannot access certain features, it may
                        be due to your account role (Staff vs Admin). Contact your administrator for assistance.</p>
                </section>
            </div>
        </main>
    </body>

    </html>