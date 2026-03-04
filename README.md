# 🏨 OceanView Resort Management Enterprise System 

![Java](https://img.shields.io/badge/Java-11+-orange?style=flat-square)
![Maven](https://img.shields.io/badge/Maven-3.6+-blue?style=flat-square)
![MySQL](https://img.shields.io/badge/MySQL-8.0+-green?style=flat-square)
![Tomcat](https://img.shields.io/badge/Tomcat-9.0+-red?style=flat-square)
![License](https://img.shields.io/badge/License-Enterprise-gold?style=flat-square)

---

## 📖 Table of Contents

- [Project Overview](#project-overview)
- [Architecture & Design Patterns](#architecture--design-patterns)
- [System Requirements](#system-requirements)
- [Installation & Setup](#installation--setup)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Core Modules](#core-modules)
  - [Authentication Module](#authentication-module)
  - [Staff Module](#staff-module)
  - [Admin Module](#admin-module)
  - [Billing Service](#billing-service)
- [API Endpoints](#api-endpoints)
- [Security Architecture](#security-architecture)
- [Testing & Validation](#testing--validation)
- [Deployment Guide](#deployment-guide)
- [Troubleshooting](#troubleshooting)
- [Development Notes](#development-notes)

---

## 🎯 Project Overview

**OceanView Resort Management Enterprise System** is an enterprise-grade web application built with Java, JSP, and MySQL designed to manage all aspects of a luxury resort's operations. The system handles guest reservations, room management, billing invoicing, financial reporting, and administrative oversight.

### Key Features

✅ **Role-Based Access Control (RBAC)**
   - Admin: Full access to financials, user management, and system logs
   - Staff: Restricted to booking creation, invoice generation, and guest management

✅ **Enterprise-Grade Security**
   - SHA-256 password hashing with unique per-account salts
   - Session-based authentication
   - XSS and SQL injection prevention
   - Secure logout with session invalidation

✅ **Complete Reservation Workflow**
   - Room availability check (with overlap detection)
   - Multi-step booking process with validation
   - Automatic invoice generation
   - Billing and payment processing

✅ **Financial Management**
   - Real-time revenue calculations
   - Precise decimal arithmetic using `java.math.BigDecimal`
   - Service tax calculations (5% on room charges)
   - Global ledger and invoicing

✅ **Executive Dashboard**
   - Real-time Key Performance Indicators (KPIs)
   - Revenue metrics and occupancy analytics
   - Live audit console for security events
   - Category-wise performance distribution

✅ **Professional UI/UX**
   - SaaS-style dashboard with Montserrat & Playfair Display fonts
   - Responsive design with Flexbox
   - Role-based interface isolation
   - Clean card-based layouts

---

## 🏗️ Architecture & Design Patterns

The system follows the **Model-View-Controller (MVC)** architectural pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER (JSP)                    │
│         [Login] [Staff Dashboard] [Admin Dashboard] [Invoices]  │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                    CONTROLLER LAYER (Servlet)                   │
│   [LoginController] [BookingController] [LogoutController] ...  │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                     BUSINESS LOGIC LAYER                        │
│                   [BillingService] [Validators]                 │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                    DATA ACCESS LAYER (DAO)                      │
│   [AccountDAO] [ReservationDAO] [AccommodationDAO] [ReportDAO]  │
└─────────────────────────────────────────────────────────────────┘
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                    DATABASE LAYER (MySQL)                       │
│    [ov_sys_account] [ov_reservation] [ov_accommodation] ...     │
└─────────────────────────────────────────────────────────────────┘
```

### Design Patterns Used

- **DAO Pattern:** Encapsulates database access logic in dedicated objects
- **Factory Pattern:** `DatabaseFactory` creates connection pools
- **Service Layer:** `BillingService` encapsulates financial business logic
- **POJO Pattern:** Domain models (`Accommodation`, `Reservation`, `SysAccount`)
- **Template Method Pattern:** Base servlet functionality inherited
- **Strategy Pattern:** Different role-based access strategies (RBAC)

---

## 💻 System Requirements

### Minimum Requirements

| Component | Version | Details |
|-----------|---------|---------|
| **Java** | 11+ | JDK 11 or OpenJDK 11 |
| **Maven** | 3.6+ | For build and dependency management |
| **MySQL** | 8.0+ | Database server |
| **Tomcat** | 9.0+ | Web application server |
| **MySQL Connector** | 8.0.33 | JDBC driver included in pom.xml |

### Development Tools

- **IDE:** IntelliJ IDEA (recommended) or Eclipse
- **Git:** Version control
- **Terminal:** zsh/bash for Maven commands

---

## 🚀 Installation & Setup

### Step 1: Clone Repository

```bash
git clone https://github.com/hareeshkar/OceanViewResortManagementEnterpriseSystem.git
cd OceanViewResortManagementEnterpriseSystem
```

### Step 2: Configure MySQL Database

```bash
# Connect to MySQL
mysql -u root -p

# Run the setup script
SOURCE src/main/resources/sql/oceanview_setup.sql;

# Verify database creation
SHOW DATABASES;
USE oceanview_management_enterprice_db;
SHOW TABLES;
```

### Step 3: Create Database Connection File

Create `src/main/java/oceanview/util/DatabaseConfig.properties`:

```properties
# MySQL Database Configuration
db.url=jdbc:mysql://localhost:3306/oceanview_management_enterprice_db?useSSL=false&serverTimezone=UTC
db.user=root
db.password=your_mysql_password
db.driver=com.mysql.cj.jdbc.Driver
```

### Step 4: Build Project with Maven

```bash
mvn clean compile
```

### Step 5: Deploy WAR File to Tomcat

```bash
# Build WAR file
mvn package

# Copy to Tomcat
cp target/OceanViewResort.war /path/to/tomcat/webapps/

# Start Tomcat
/path/to/tomcat/bin/startup.sh
```

### Step 6: Access Application

- **Login Page:** `http://localhost:8080/OceanViewResort/`
- **Test Credentials:**
  - Admin: `admin` / `Admin@123`
  - Staff: `staff1` / `Staff@123`

---

## 📂 Project Structure

```
OceanViewResortManagementEnterpriseSystem/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── oceanview/
│   │   │   │   ├── controller/        # ← HTTP Request Handlers
│   │   │   │   │   ├── LoginController.java
│   │   │   │   │   ├── BookingController.java
│   │   │   │   │   └── LogoutController.java
│   │   │   │   ├── model/             # ← Domain Objects (POJOs)
│   │   │   │   │   ├── Accommodation.java
│   │   │   │   │   ├── Reservation.java
│   │   │   │   │   ├── SysAccount.java
│   │   │   │   │   ├── InvoiceDTO.java
│   │   │   │   │   └── RoomCategory.java
│   │   │   │   ├── dao/               # ← Data Access Layer
│   │   │   │   │   ├── AccountDAO.java
│   │   │   │   │   ├── ReservationDAO.java
│   │   │   │   │   ├── AccommodationDAO.java
│   │   │   │   │   └── ReportDAO.java
│   │   │   │   ├── service/           # ← Business Logic Layer
│   │   │   │   │   └── BillingService.java
│   │   │   │   ├── util/              # ← Utility Classes
│   │   │   │   │   ├── DatabaseFactory.java
│   │   │   │   │   ├── HashProvider.java
│   │   │   │   │   └── SecuritySetupTool.java
│   │   │   │   └── filter/            # ← Request Filters
│   │   │   │       └── SecurityFilter.java
│   │   │   └── com/oceanview/         # ← Placeholder Namespace
│   │   ├── resources/
│   │   │   └── sql/
│   │   │       └── oceanview_setup.sql     # ← Database Schema
│   │   └── webapp/
│   │       ├── index.jsp              # ← Home Page
│   │       ├── login.jsp              # ← Login Page
│   │       ├── css/
│   │       │   ├── styles.css         # ← Global Styles
│   │       │   ├── elite_ui.css       # ← Staff UI
│   │       │   └── admin_ui.css       # ← Admin UI
│   │       ├── js/
│   │       │   └── main.js            # ← Client-side Scripts
│   │       ├── staff/                 # ← Staff Module
│   │       │   ├── dashboard.jsp      # ← Staff Dashboard
│   │       │   ├── view_bookings.jsp  # ← Booking List
│   │       │   ├── invoice.jsp        # ← Invoice Printing
│   │       │   └── help.jsp           # ← Staff Guidelines
│   │       └── admin/                 # ← Admin Module
│   │           ├── dashboard.jsp      # ← Executive Dashboard
│   │           ├── manage_users.jsp   # ← User Management
│   │           ├── admin_ledger.jsp   # ← Financial Ledger
│   │           └── help.jsp           # ← Admin Guide
│   └── test/
│       └── java/
│           └── oceanview/
│               └── test/              # ← Test Suite
│                   ├── AccommodationDAOTest.java
│                   ├── AccountDAOTest.java
│                   ├── BillingServiceTest.java
│                   ├── PhaseOneTest.java
│                   ├── ReservationIntegrationTest.java
│                   └── MasterTestSuite.java
├── pom.xml                            # ← Maven Configuration
├── README.md                          # ← This File
└── PHASE_*.md                         # ← Phase Completion Docs
```

---

## 🗄️ Database Schema

### Core Tables

#### 1. `ov_sys_account` - System User Accounts

| Column | Type | Notes |
|--------|------|-------|
| `account_id` | INT (PK) | Auto-increment |
| `login_name` | VARCHAR(50) | Unique username |
| `secure_hash` | VARCHAR(64) | SHA-256 hash |
| `secure_salt` | VARCHAR(32) | Random salt for security |
| `access_level` | VARCHAR(20) | 'ADMIN' or 'STAFF' |
| `created_at` | TIMESTAMP | Account creation time |

**Security Note:** Passwords are stored as salted SHA-256 hashes using `HashProvider.java`.

#### 2. `ov_room_category` - Room Tiers

| Column | Type | Notes |
|--------|------|-------|
| `category_id` | INT (PK) | Auto-increment |
| `category_name` | VARCHAR(50) | e.g., 'Deluxe', 'Suite' |
| `base_rate_lkr` | DECIMAL(15,2) | Daily room rate |
| `description` | VARCHAR(255) | Category details |

#### 3. `ov_accommodation` - Physical Rooms

| Column | Type | Notes |
|--------|------|-------|
| `room_pk` | INT (PK) | Auto-increment |
| `room_number` | VARCHAR(10) | Unique room identifier |
| `category_id` | INT (FK) | References `ov_room_category` |
| `operational_status` | VARCHAR(20) | AVAILABLE, MAINTENANCE, OCCUPIED |

#### 4. `ov_reservation` - Guest Bookings

| Column | Type | Notes |
|--------|------|-------|
| `reservation_pk` | INT (PK) | Auto-increment |
| `booking_ref` | VARCHAR(12) | Unique reference (e.g., OVR-8821) |
| `guest_name` | VARCHAR(100) | Full guest name |
| `contact_phone` | VARCHAR(15) | Guest phone number |
| `guest_address` | VARCHAR(255) | Guest address |
| `room_pk` | INT (FK) | References `ov_accommodation` |
| `arrival_date` | DATE | Check-in date |
| `departure_date` | DATE | Check-out date |
| `booking_status` | VARCHAR(20) | CONFIRMED, CHECKED_IN, CANCELLED, COMPLETED |
| `created_timestamp` | TIMESTAMP | Booking creation time |

#### 5. `ov_billing_invoice` - Financial Records

| Column | Type | Notes |
|--------|------|-------|
| `invoice_pk` | INT (PK) | Auto-increment |
| `reservation_pk` | INT (FK) | References `ov_reservation` |
| `total_nights` | INT | Number of nights |
| `room_charge_lkr` | DECIMAL(15,2) | Room cost (Nights × Base Rate) |
| `service_tax_lkr` | DECIMAL(15,2) | 5% service tax |
| `grand_total_lkr` | DECIMAL(15,2) | Total amount (Room Charge + Tax) |
| `created_timestamp` | TIMESTAMP | Invoice generation time |

**Formula:** `Grand Total = (Nights × Base Rate) + Tax`  
**Tax Rate:** 5% on room charges

---

## 🔧 Core Modules

### 🔐 Authentication Module

**File:** `src/main/java/oceanview/controller/LoginController.java`

**Purpose:** Secure user authentication and session initialization

**Key Features:**
- SHA-256 password validation
- Session-based authentication
- RBAC-driven routing (Admin → dashboard.jsp, Staff → dashboard.jsp)
- Password validation with regex patterns
- Database connection pooling

**Endpoint:** `POST /authenticate`

**Request Parameters:**
```
username: string
password: string
```

**Response:**
```
Success: Redirect to appropriate dashboard
Failure: Redirect to login.jsp with error message
```

**Security Measures:**
- No SQL injection (PreparedStatement)
- No plaintext password storage
- Secure session timeout
- Generic error messages (no username/password hints)

---

### 👥 Staff Module

**Location:** `src/main/webapp/staff/`

**Features:**
1. **Dashboard** (`dashboard.jsp`)
   - Room availability display
   - Room category selection
   - Recent booking history
   - Personal booking summary

2. **Booking Management** (`view_bookings.jsp`)
   - View all personal bookings
   - Pagination support
   - Booking status display
   - Invoice generation links

3. **Invoice System** (`invoice.jsp`)
   - Guest invoice generation
   - Printable format
   - Itemized billing details
   - Booking reference display

4. **Help & Guidelines** (`help.jsp`)
   - User documentation
   - System navigation guide
   - FAQs

**RBAC Protection:**
```java
String role = (String) session.getAttribute("userRole");
if (!"STAFF".equals(role) && !"ADMIN".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
}
```

---

### 👨‍💼 Admin Module

**Location:** `src/main/webapp/admin/`

**Features:**
1. **Executive Dashboard** (`dashboard.jsp`)
   - Real-time KPI cards
     - Gross Revenue Yield (Total Billed Amount)
     - Total Reservation Volume
     - Today's Check-ins
   - Category-wise demand distribution (bar chart)
   - Live Audit Console (MySQL trigger events)
   - System health indicators
   - Quick navigation links

2. **User Management** (`manage_users.jsp`)
   - View all system accounts
   - User access levels
   - Account creation timestamps
   - Security architecture documentation
   - Password security details

3. **Global Financial Ledger** (`admin_ledger.jsp`)
   - Complete reservation history
   - Billing records
   - Pagination with navigation
   - Invoice regeneration capability
   - Read-only audit view
   - Print functionality

4. **Administrator Guide** (`help.jsp`)
   - System overview documentation
   - Business Intelligence guide
   - Audit trail explanation
   - User management instructions
   - Financial ledger walkthrough

**RBAC Protection:**
```java
if (!"ADMIN".equals(session.getAttribute("userRole"))) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
}
```

---

### 💳 Billing Service

**File:** `src/main/java/oceanview/service/BillingService.java`

**Purpose:** Enterprise-grade financial calculations

**Methods:**

```java
// Calculate nights between arrival and departure
long calculateTotalNights(LocalDate arrival, LocalDate departure)

// Calculate room charge: Nights × Base Rate
BigDecimal calculateRoomCharge(long nights, BigDecimal baseRateLkr)

// Calculate 5% service tax
BigDecimal calculateServiceTax(BigDecimal roomChargeLkr)

// Calculate grand total: Room Charge + Tax
BigDecimal calculateGrandTotal(BigDecimal roomCharge, BigDecimal tax)
```

**Key Rules:**
- Uses `java.math.BigDecimal` for precise currency calculations
- Minimum 1-night stay enforced
- RoundingMode: HALF_UP (standard financial rounding)
- Tax rate: Fixed at 5%
- All operations return 2-decimal precision

**Example Calculation:**
```
Nights:            3
Base Rate:         10,000 LKR
Room Charge:       30,000 LKR (3 × 10,000)
Service Tax:       1,500 LKR (30,000 × 0.05)
Grand Total:       31,500 LKR (30,000 + 1,500)
```

---

## 🔗 API Endpoints

### Authentication

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/login.jsp` | Login page | Public |
| POST | `/authenticate` | Submit credentials | Public |
| GET | `/logout` | Logout and invalidate session | Authenticated |

### Staff Operations

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/staff/dashboard.jsp` | Staff dashboard | STAFF, ADMIN |
| GET | `/staff/view_bookings.jsp` | View bookings | STAFF, ADMIN |
| GET | `/staff/invoice.jsp?id=<reservationPk>` | Generate invoice | STAFF, ADMIN |
| GET | `/staff/help.jsp` | Staff guidelines | STAFF, ADMIN |
| POST | `/staff/book-room` | Create new booking | STAFF, ADMIN |

### Admin Operations

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/admin/dashboard.jsp` | Executive dashboard | ADMIN |
| GET | `/admin/manage_users.jsp` | User management | ADMIN |
| GET | `/admin/admin_ledger.jsp` | Financial ledger | ADMIN |
| GET | `/admin/help.jsp` | Administrator guide | ADMIN |

### Availability API

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/api/availability?arrival=YYYY-MM-DD&departure=YYYY-MM-DD` | Check room availability | AJAX |

---

## 🛡️ Security Architecture

### Authentication & Authorization

1. **Password Security**
   - SHA-256 cryptographic hashing
   - Unique salt per account
   - Generated using `HashProvider.java`
   - Never stored in plaintext

2. **Session Management**
   - Server-side session storage
   - Attributes: `loggedInUser`, `userRole`
   - Automatic invalidation on logout
   - Session timeout handled by Tomcat

3. **Role-Based Access Control (RBAC)**
   - Two roles: ADMIN, STAFF
   - Access checks on every page load
   - Automatic redirect to login on unauthorized access
   - Different UI for different roles

4. **Input Validation**
   - Server-side validation on all inputs
   - Phone number regex: `0[0-9]{9}` (Sri Lankan format)
   - Guest name: Non-empty string
   - Date validation: LocalDate parsing
   - SQL injection prevention: PreparedStatement

5. **Error Handling**
   - Generic error messages to users
   - Detailed errors logged server-side
   - No stack traces exposed to clients
   - Graceful exception recovery

### Database Security

- **Connection Pooling:** `DatabaseFactory.java`
- **Prepared Statements:** Prevent SQL injection
- **Transaction Management:** Auto-commit disabled for multi-statement operations
- **Foreign Key Constraints:** Referential integrity
- **Unique Constraints:** Prevent duplicate data

---

## 🧪 Testing & Validation

### Unit Tests

**Test Suite:** `src/test/java/oceanview/test/`

#### 1. AccommodationDAOTest.java
```java
@Test
public void testAvailableRoomsFetch() {
    LocalDate start = LocalDate.now().plusMonths(1);
    LocalDate end = start.plusDays(3);
    List<Accommodation> rooms = dao.getAvailableRooms(start, end);
    
    assertNotNull("Room list should not be null", rooms);
    assertTrue("Should find available rooms", rooms.size() > 0);
}
```

#### 2. AccountDAOTest.java
```java
@Test
public void testPasswordValidation() {
    SysAccount account = dao.getAccountByUsername("admin");
    assertTrue("Password should verify", 
        HashProvider.verify("Admin@123", account.getSecureHash(), account.getSecureSalt()));
}
```

#### 3. BillingServiceTest.java
```java
@Test
public void testFinancialCalculations() {
    BigDecimal roomCharge = billingService.calculateRoomCharge(3, new BigDecimal("10000"));
    BigDecimal tax = billingService.calculateServiceTax(roomCharge);
    BigDecimal total = billingService.calculateGrandTotal(roomCharge, tax);
    
    assertEquals("Grand total should be 31500", new BigDecimal("31500.00"), total);
}
```

#### 4. MasterTestSuite.java
```java
@RunWith(Suite.class)
@Suite.SuiteClasses({
    AccommodationDAOTest.class,
    AccountDAOTest.class,
    BillingServiceTest.class,
    ReservationIntegrationTest.class
})
public class MasterTestSuite { }
```

### Running Tests

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=BillingServiceTest

# Run with verbose output
mvn test -X
```

---

## 📦 Deployment Guide

### Prerequisites

- MySQL database running
- Tomcat server configured
- Java 11+ installed
- Environment variables set: `JAVA_HOME`, `CATALINA_HOME`

### Step-by-Step Deployment

1. **Build WAR File**
   ```bash
   mvn clean package -DskipTests
   ```

2. **Stop Tomcat**
   ```bash
   /path/to/tomcat/bin/shutdown.sh
   ```

3. **Deploy WAR**
   ```bash
   cp target/OceanViewResort.war /path/to/tomcat/webapps/ROOT.war
   ```

4. **Start Tomcat**
   ```bash
   /path/to/tomcat/bin/startup.sh
   ```

5. **Verify Deployment**
   ```bash
   tail -f /path/to/tomcat/logs/catalina.out
   curl http://localhost:8080/OceanViewResort/
   ```

### Production Checklist

- [ ] Database backups configured
- [ ] HTTPS/SSL enabled
- [ ] Session timeout set appropriately
- [ ] Error logging configured
- [ ] Connection pool size tuned
- [ ] Database credentials secured
- [ ] Admin password changed from default

---

## 🔧 Troubleshooting

### Common Issues

#### 1. "Cannot find database"
```
Error: com.mysql.cj.jdbc.exceptions.CommunicationsException
Solution: Verify MySQL is running and credentials in DatabaseConfig.properties
```

#### 2. "Login fails with correct credentials"
```
Error: Invalid Username or Password
Solution: Check if database tables are seeded. Run oceanview_setup.sql
```

#### 3. "Booking creation fails"
```
Error: SQLException in createReservationWithInvoice
Solution: Verify room availability, date ranges, and guest data validity
```

#### 4. "Admin dashboard shows no data"
```
Error: NULL_POINTER_EXCEPTION in ReportDAO
Solution: Ensure database has sample data (run setup script)
```

#### 5. "Session expires immediately"
```
Error: Redirect to login after page load
Solution: Check Tomcat session timeout in web.xml (default: 30 minutes)
```

### Debug Mode

Enable detailed logging:

```java
// In your servlet
e.printStackTrace();  // Logs to catalina.out
System.err.println("Debug: " + message);  // stderr
```

View logs:
```bash
tail -f /path/to/tomcat/logs/catalina.out
```

---

## 📝 Development Notes

### Code Style Guidelines

1. **Naming Conventions**
   - Classes: PascalCase (`LoginController`, `BillingService`)
   - Methods: camelCase (`calculateTotalNights()`)
   - Constants: UPPER_SNAKE_CASE (`TAX_RATE`)
   - Package names: lowercase (`oceanview.controller`)

2. **Database Operations**
   ```java
   // ✅ CORRECT: Try-with-resources
   try (Connection conn = DatabaseFactory.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
       // Use ps
   } catch (SQLException e) {
       e.printStackTrace();
   }
   
   // ❌ WRONG: Not closing resources
   Connection conn = DriverManager.getConnection(...);
   PreparedStatement ps = conn.prepareStatement(...);
   ```

3. **Financial Calculations**
   ```java
   // ✅ CORRECT: Use BigDecimal
   BigDecimal total = new BigDecimal("100.50");
   total = total.multiply(new BigDecimal("1.05"));
   
   // ❌ WRONG: Use double for currency
   double total = 100.50 * 1.05;  // Precision loss!
   ```

4. **Date Handling**
   ```java
   // ✅ CORRECT: Use java.time.LocalDate
   LocalDate arrival = LocalDate.parse("2026-03-10");
   
   // ❌ WRONG: Use java.util.Date
   Date arrival = new Date(/*...*/);  // Deprecated
   ```

### Adding New Features

1. **Create Database Table**
   - Add SQL to `oceanview_setup.sql`
   - Add foreign key constraints
   - Add indexes for performance

2. **Create Model Class**
   - Location: `src/main/java/oceanview/model/`
   - Implement getters/setters
   - Document properties

3. **Create DAO Class**
   - Location: `src/main/java/oceanview/dao/`
   - Implement CRUD operations
   - Use PreparedStatement
   - Handle ResultSet properly

4. **Create Service Logic** (if needed)
   - Location: `src/main/java/oceanview/service/`
   - Encapsulate business logic
   - Validate inputs

5. **Create Controller** (if needed)
   - Location: `src/main/java/oceanview/controller/`
   - Extend HttpServlet
   - Implement doGet/doPost
   - Add @WebServlet annotation

6. **Create JSP Page** (if needed)
   - Location: `src/main/webapp/`
   - Add RBAC checks at top
   - Use consistent CSS classes
   - Follow UI patterns

7. **Write Tests**
   - Location: `src/test/java/oceanview/test/`
   - Follow JUnit conventions
   - Use @Before, @Test, @After
   - Assert expected behavior

### Performance Optimization Tips

1. **Database Queries**
   - Use indexes on frequently queried columns
   - Limit JOIN complexity
   - Use pagination for large result sets
   - Cache query results when appropriate

2. **Connection Pool**
   ```properties
   # In DatabaseFactory.java
   pool.setMaximumPoolSize(20);  // Adjust based on load
   pool.setMinimumIdle(5);
   ```

3. **Session Management**
   - Don't store large objects in session
   - Use session only for essential data
   - Implement proper timeout

---

## 📚 Additional Resources

- **Java SE 11 Documentation:** https://docs.oracle.com/en/java/javase/11/
- **MySQL 8.0 Manual:** https://dev.mysql.com/doc/refman/8.0/en/
- **Servlet 4.0 Specification:** https://javaee.github.io/servlet-spec/
- **JSP Specification:** https://javaee.github.io/jsp-spec/

---

## 📄 License & Attribution

**Project:** OceanView Resort Management Enterprise System v3.0  
**Grade Target:** Distinction (A+)  
**Course:** ICBT CIS6003 - Enterprise Application Development  
**Author:** Hareeshkar  
**Created:** March 4, 2026  

---

## 🤝 Contributing

This is an educational project. For improvements or bug reports, please create an issue or submit a pull request on GitHub.

---

## 📞 Support

For technical support or clarifications:
- Review the PHASE_*.md completion documents
- Check troubleshooting section above
- Review code comments in source files
- Consult database schema documentation





