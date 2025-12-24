# PerformancePlus - Employee Performance Management System

PerformancePlus is a Java-based web application designed to help organizations track employee goals (KPIs), provide managerial feedback, and maintain system transparency through audit logs.

## 🌟 Key Features
- **Admin Dashboard**: Manage users, view system-wide stats, and monitor audit logs.
- **Manager Portal**: Assign goals (KPIs) to team members and track their progress live.
- **Employee View**: Update progress on active goals and view feedback from managers.
- **Live Sync**: Automatic session refresh ensures progress bars update immediately upon changes.

## 📺 Project Demo
Watch the system in action: https://youtu.be/0kiP5wumt8c

## 🛠️ Technology Stack
- **Backend**: Java Servlets, JSP
- **Database**: MySQL (SQLyog)
- **Frontend**: HTML5, Bootstrap 5 (Darkish Theme)
- **Server**: Apache Tomcat 9.0+

## ⚙️ Setup Instructions
1. Clone the repository.
2. Import the `schema.sql` file into your MySQL database (using SQLyog or PHPMyAdmin).
3. Update `DBConnection.java` with your database credentials.
4. Deploy the project on an Apache Tomcat server.
5. Access via `http://localhost:8080/PerformancePlus`.