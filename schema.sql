-- 1. Create Database
CREATE DATABASE IF NOT EXISTS performanceplus;
USE performanceplus;

-- 2. Roles Table
CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(20) NOT NULL
);

-- 3. Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role_id INT,
    manager_id INT DEFAULT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- 4. KPIs Table (Goals)
CREATE TABLE kpis (
    kpi_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    target_value INT DEFAULT 100,
    current_value INT DEFAULT 0,
    status ENUM('Pending', 'Completed') DEFAULT 'Pending',
    FOREIGN KEY (employee_id) REFERENCES users(user_id)
);

-- 5. Feedback Table
CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    manager_id INT,
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES users(user_id),
    FOREIGN KEY (manager_id) REFERENCES users(user_id)
);

-- 6. Audit Logs Table
CREATE TABLE audit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initial Data
INSERT INTO roles (role_name) VALUES ('ADMIN'), ('MANAGER'), ('EMPLOYEE');