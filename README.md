# Barangay Panducot Adjudication Management Information System

The Barangay Panducot Adjudication Management Information System is a web-based case management platform developed to streamline the handling of barangay complaints, case records, and adjudication processes. The system replaces manual record keeping with a centralized digital solution while integrating modern technologies such as AI-assisted support, OCR document processing, and real-time notifications.

## System overview

The application allows barangay personnel to manage complaints from filing through resolution while maintaining organized records of cases, parties involved, hearings, and official documents. Administrative users can monitor activities, manage users, and generate reports from a centralized dashboard.

To improve efficiency, the system incorporates artificial intelligence for user assistance, Optical Character Recognition (OCR) for document digitization, and push notifications to keep users informed of important updates.

## About this project

- **Created by:** Vincent Aaron B. Vicete, Justfer F. Carabuena, Lougene A. Guinto, Shamel B. Baje, Ashley O. Santiago
- **Purpose:** Develop a modern information management system that digitizes barangay adjudication workflows and improves record management.
- **Academic context:** Bachelor of Science in Information Technology Capstone Project.
- **Why it was made:** To reduce or completely elimenate the inefficiency of  manual processes, reduce document redundancy, improve accessibility of case records, and demonstrate the integration latest technologies into government information systems.
- **My contributions:**
  - Developed the AI Chat Assistant using the OpenRouter API.
  - Integrated OCR services for document text extraction.
  - Implemented Service Workers for push notifications.
  - Assisted in API integration, debugging, and system development.

## Core features

- Secure user authentication and role-based access.
- Complaint and case management.
- Digital document storage.
- ID verification using OCR.
- AI-powered chat assistant.
- Push notifications using Service Workers.
- Dashboard for monitoring cases and activities.
- User account management.
- Search and filtering capabilities.
- Report generation.

## AI integration

The system includes an AI-powered chat assistant built using the OpenRouter API. The assistant helps users navigate the system, answer common questions, and improve accessibility without requiring direct administrator assistance.

## OCR integration

The system integrates Optical Character Recognition (OCR) during user verfication to assist in verifying uploaded IDs. The OCR service reads information from the submitted ID, helping validate the user's identity and confirm that the applicant is a registered resident of the barangay before account approval.

## Notification system

The application utilizes Service Workers to provide browser push notifications for important updates, allowing users to receive alerts even when the application is running in the background.

## Technologies used

### Backend

- PHP
- MySQL

### Frontend

- HTML5
- CSS3
- JavaScript

### APIs & Services

- OpenRouter API
- OCR API
- Service Workers
- Push Notifications

### Development Tools

- Visual Studio Code
- XAMPP
- Git
- GitHub

## Project structure

- `assets/`
  - Images, icons, stylesheets, and client-side resources.
- `controllers/`
  - Business logic and request handling.
- `models/`
  - Database interactions and application models.
- `views/`
  - User interface pages.
- `api/`
  - AI and OCR integrations.
- `database/`
  - SQL schema and migration files.
- `service-worker.js`
  - Push notification implementation.
- `README.md`

## How to run the project

1. Clone the repository.
2. Install XAMPP or another PHP development environment.
3. Import the provided MySQL database.
4. Configure the database connection.
5. Configure the required API keys for OpenRouter and OCR services.
6. Start Apache and MySQL.
7. Open the project in your browser.

## Development notes

- The application follows a modular PHP structure.
- AI functionality requires a valid OpenRouter API key.
- OCR functionality requires configuration of the supported OCR provider.
- Push notifications require browser notification permissions and Service Worker support.

## Future enhancements

- Mobile-responsive redesign.
- SMS and email notification support.
- Advanced analytics dashboard.
- Automated case scheduling.
- Document version history.
- Multi-barangay deployment support.
