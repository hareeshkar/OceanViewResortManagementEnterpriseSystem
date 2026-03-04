-- ==========================================
-- 🏨 OCEAN VIEW RESORT - ENTERPRISE DB SETUP
-- AUTHOR: System Architect
-- VERSION: 3.0 (Distinction Grade)
-- ==========================================

DROP DATABASE IF EXISTS oceanview_management_enterprice_db;
CREATE DATABASE oceanview_management_enterprice_db;
USE oceanview_management_enterprice_db;

-- 1. SYSTEM ACCOUNTS (RBAC: Admin vs Staff)
CREATE TABLE ov_sys_account (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    login_name VARCHAR(50) NOT NULL UNIQUE,
    secure_hash VARCHAR(64) NOT NULL, -- SHA-256 Hex String
    secure_salt VARCHAR(32) NOT NULL, -- Random Salt
    access_level VARCHAR(20) NOT NULL, -- 'ADMIN' or 'STAFF'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. ROOM CATEGORIES (Tiers)
CREATE TABLE ov_room_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    base_rate_lkr DECIMAL(15, 2) NOT NULL CHECK (base_rate_lkr > 0),
    description VARCHAR(255)
);

-- 3. ACCOMMODATION UNITS (Physical Rooms)
CREATE TABLE ov_accommodation (
    room_pk INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    category_id INT NOT NULL,
    operational_status VARCHAR(20) DEFAULT 'AVAILABLE', -- AVAILABLE, MAINTENANCE, OCCUPIED
    FOREIGN KEY (category_id) REFERENCES ov_room_category(category_id)
);

-- 4. RESERVATIONS (Core Booking Data)
CREATE TABLE ov_reservation (
    reservation_pk INT AUTO_INCREMENT PRIMARY KEY,
    booking_ref VARCHAR(12) NOT NULL UNIQUE, -- e.g., OVR-8821
    guest_name VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(15) NOT NULL,
    guest_address VARCHAR(255) NOT NULL,
    room_pk INT NOT NULL,
    arrival_date DATE NOT NULL,
    departure_date DATE NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'CONFIRMED', -- CONFIRMED, CHECKED_IN, CANCELLED, COMPLETED
    created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_pk) REFERENCES ov_accommodation(room_pk)
);

-- 5. INVOICES (Financial Records)
CREATE TABLE ov_billing_invoice (
    invoice_pk INT AUTO_INCREMENT PRIMARY KEY,
    reservation_pk INT NOT NULL,
    total_nights INT NOT NULL,
    room_charge_lkr DECIMAL(15,2) NOT NULL,
    service_tax_lkr DECIMAL(15,2) NOT NULL, -- 5% Tax
    grand_total_lkr DECIMAL(15,2) NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_pk) REFERENCES ov_reservation(reservation_pk)
);

-- 6. AUDIT LOG (Advanced Requirement: Triggers)
CREATE TABLE ov_audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(50),
    description VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- ⚡ ADVANCED DB FEATURES: TRIGGERS
-- ==========================================

DELIMITER //
CREATE TRIGGER trg_after_booking_insert
AFTER INSERT ON ov_reservation
FOR EACH ROW
BEGIN
    INSERT INTO ov_audit_log (action_type, description)
    VALUES ('NEW_BOOKING', CONCAT('New reservation created: ', NEW.booking_ref));
END;
//
DELIMITER ;

-- ==========================================
-- 🌱 SEED DATA (Initial Setup)
-- ==========================================

-- Categories
INSERT INTO ov_room_category (category_name, base_rate_lkr, description) VALUES
('Standard Single', 15000.00, 'Cozy room for solo travelers'),
('Ocean Deluxe', 25000.00, 'Double room with sea view'),
('Presidential Suite', 55000.00, 'Luxury suite with full amenities');

-- Rooms
INSERT INTO ov_accommodation (room_number, category_id) VALUES
('101', 1), ('102', 1), ('103', 1),
('201', 2), ('202', 2), ('203', 2),
('301', 3);

-- Note: Admin and Staff accounts will be created via SecuritySetupTool.java
-- This ensures Java-based cryptographic hashing is used for security.

