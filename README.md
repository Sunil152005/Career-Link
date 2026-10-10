# Career Link – Online Job Portal & Recruitment Management System

Career Link is a web-based recruitment management system designed to connect job seekers, HR professionals, and administrators through a centralized platform. Candidates can register, manage their profiles, search for jobs, and apply for suitable positions.

## Features

### Candidate Module
- Candidate registration and login
- Profile management
- Education and skills management
- Resume upload
- Job search and application
- Application status tracking

### HR Module
- HR registration and login
- Create, edit, and delete job postings
- View and manage applicants
- Shortlist candidates
- Schedule interviews
- Update application status

### Admin Module
- Admin login
- Manage candidate and HR accounts
- Monitor and approve job postings
- View recruitment reports
- Dashboard analytics

*Note: Features listed above represent the project scope. Update this section to reflect the features currently implemented.*

## Technology Stack

| Technology | Purpose |
|---|---|
| HTML5 | Web page structure |
| CSS3 | Styling |
| JavaScript | Client-side functionality |
| Bootstrap | Responsive user interface |
| Java | Backend programming |
| JSP | Dynamic web pages |
| Jakarta Servlets | Request handling |
| MySQL | Database |
| Apache Tomcat 10 | Web application server |
| Apache Maven | Build and dependency management |
| Visual Studio Code | Development environment |

## Project Structure

```text
CareerLink/
├── pom.xml
├── README.md
└── src/
    └── main/
        ├── java/
        │   └── com/careerlink/
        │       ├── controller/
        │       ├── dao/
        │       ├── model/
        │       ├── service/
        │       └── util/
        └── webapp/
            ├── css/
            ├── js/
            ├── images/
            ├── candidate/
            ├── hr/
            ├── admin/
            ├── WEB-INF/
            ├── index.jsp
            ├── login.jsp
            └── register.jsp
```

## Prerequisites

Install the following software:

- JDK 17
- Apache Maven
- MySQL Server
- MySQL Workbench
- Apache Tomcat 10
- Visual Studio Code

## Database Setup

1. Open MySQL Workbench.
2. Connect to your MySQL server.
3. Execute the following SQL commands:

```sql
CREATE DATABASE careerlink;
USE careerlink;
```

4. Create the required tables:
   - `candidate`
   - `hr`
   - `job_post`
   - `application`
   - `interview`

## Configuration

Open the database connection file:

```text
src/main/java/com/careerlink/util/DBConnection.java
```

Configure your MySQL connection details:

```java
private static final String URL =
        "jdbc:mysql://localhost:3306/careerlink";

private static final String USER = "root";

private static final String PASSWORD =
        "YOUR_MYSQL_PASSWORD";
```

Replace `YOUR_MYSQL_PASSWORD` with your local MySQL password. Do not upload actual credentials to GitHub.

## How to Run the Project

### Step 1: Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/CareerLink.git
```

### Step 2: Open the Project

Open the `CareerLink` folder in Visual Studio Code.

### Step 3: Verify Java and Maven

Open the VS Code terminal and run:

```bash
java -version
mvn -version
```

### Step 4: Build the Project

Run this command from the folder containing `pom.xml`:

```bash
mvn clean package
```

After a successful build, Maven generates:

```text
target/CareerLink.war
```

### Step 5: Start Apache Tomcat

On Windows, open the Tomcat `bin` folder and run:

```bat
startup.bat
```

### Step 6: Deploy the Application

Copy `target/CareerLink.war` into the Tomcat `webapps` folder.

### Step 7: Open the Application

Open your browser and visit:

```text
http://localhost:8080/CareerLink/
```

To open the registration page directly:

```text
http://localhost:8080/CareerLink/register.jsp
```

## Application Workflow

```text
Candidate / HR / Admin
          |
          v
    Web Interface
       JSP / HTML
          |
          v
    Java Servlets
          |
          v
    MySQL Database
          |
          v
 Recruitment Management
```

## Future Enhancements

- AI-based resume screening
- Skill-based job recommendations
- Email and SMS notifications
- Video interview integration
- Mobile application
- LinkedIn integration
- Machine-learning-based job recommendations

## Security Considerations

- Store passwords using secure password hashing.
- Validate user inputs on the server.
- Use prepared SQL statements.
- Implement session management and role-based authorization.
- Validate uploaded resume files.
- Keep database credentials out of source control.

## Project Status

**Status:** Initial development

The project begins with the candidate registration and login foundation. HR management, administrative features, job applications, interview scheduling, and reporting should be marked complete after implementation and testing.

## Author

**Sunil Jadhav**

- GitHub: https://github.com/Sunil152005
- Project Repository: https://github.com/Sunil152005/Career-Link
