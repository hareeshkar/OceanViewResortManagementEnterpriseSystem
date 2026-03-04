<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Portal - OceanView Resort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <header>
        <div class="container">
            <h1>OceanView Resort - Staff Portal</h1>
            <nav>
                <a href="${pageContext.request.contextPath}/staff/dashboard.jsp">Dashboard</a>
                <a href="${pageContext.request.contextPath}/staff/bookings.jsp">Bookings</a>
                <a href="${pageContext.request.contextPath}/staff/guests.jsp">Guests</a>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </nav>
        </div>
    </header>

    <main class="container">
        <div class="card">
            <h2>Welcome to Staff Portal</h2>
            <p>This is the staff area of OceanView Resort Management Enterprise System.</p>
            <p>Staff members can manage bookings, guests, and resort operations through this portal.</p>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 OceanView Resort Management System. All rights reserved.</p>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

