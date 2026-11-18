# Barangay Panducot Adjudication Management Information System (BPAMIS)

BPAMIS is a web-based case management system for barangay complaints and adjudication under the Katarungang Pambarangay process. It replaces manual record keeping with one place to file complaints, track cases, schedule hearings, keep records and produce reports.

## Capstone group project

This system was built as a Bachelor of Science in Information Technology capstone project by:

- Vincent Aaron B. Vicente
- Justfer F. Carabuena
- Lougene A. Guinto
- Shamel B. Baje
- Ashley O. Santiago

**Vincent Aaron B. Vicente's contributions:** the AI chat assistant using the OpenRouter API, OCR integration for document text extraction, Service Workers for push notifications, and support across API integration, debugging and system development.

## What the system does

| Role | Main tasks |
| --- | --- |
| Barangay Secretary | Validates complaints, opens cases, schedules hearings, manages accounts, verifies residents, prints KP forms, views reports |
| Lupon Head | Assigns and reassigns cases, schedules hearings, updates case progress |
| Barangay Captain | Monitors cases, hearings and reports |
| Lupon Member | Works on assigned cases, records feedback, views the hearing calendar |
| Resident | Files complaints, follows case status and hearings, receives notifications |
| External complainant | Files complaints against residents and follows their progress |

Other features include an AI chat assistant with a built-in barangay guide, OCR checks of valid IDs, browser notifications and PDF report export.

## Technology

- PHP 8.3 and MySQL or MariaDB (mysqli)
- HTML, CSS, JavaScript, Tailwind CSS and FullCalendar
- PHPMailer, Dompdf and PhpSpreadsheet
- OpenRouter API (chat assistant) and OCR.Space API (ID checks), both optional

## Project structure

| Path | Purpose |
| --- | --- |
| `bpamis_website/` | Public website, login, registration and password reset |
| `SecMenu/`, `LuponHeadMenu/`, `OfficialMenu/`, `ResidentMenu/`, `ExternalMenu/` | Pages for each role |
| `controllers/` | Form handlers and JSON endpoints |
| `includes/` | Bootstrap, access control, demo mode, mailer, upload checks, navigation |
| `server/server.php` | Database connection |
| `chatbot/` | Chat assistant and knowledge base |
| `config/` | `config.example.php` template and your private `config.local.php` |
| `database/demo_seed.sql` | Full schema with fictional demo data |

## Demo mode

Demo mode is on by default in `config/config.example.php`. While it is on:

- The login page shows one-click demo logins.
- Every page shows a small "Demo with fictional data" notice.
- No email is sent. The forgot-password step accepts code `123456` and does not change any password.
- Uploaded files are discarded, and public registration is turned off so nobody submits a real ID.
- Passwords and email addresses of demo accounts cannot be changed, and accounts cannot be deactivated or removed.
- New accounts must use an `@example.com` address.

### Demo logins

Every account uses the password `BpamisDemo#2026`. This password exists only for the fictional demo data.

| Role | Email |
| --- | --- |
| Secretary | `secretary@example.com` |
| Lupon Head | `luponhead@example.com` |
| Barangay Captain | `captain@example.com` |
| Lupon Member | `lupon@example.com` |
| Resident | `resident@example.com` |
| External complainant | `external@example.com` |

All names, addresses, phone numbers, emails and cases in `database/demo_seed.sql` are invented.

## Local setup

1. Install XAMPP with PHP 8.3 (or any PHP 8.3 and MySQL or MariaDB setup).
2. Put this folder in `htdocs`, for example `C:\xampp\htdocs\bpamis`.
3. Create an empty database named `bpamis_demo` in phpMyAdmin and import `database/demo_seed.sql`.
4. Copy `config/config.example.php` to `config/config.local.php`.
5. In `config/config.local.php`, set the `db` values. For a default XAMPP install use host `localhost`, user `root` and an empty password.
6. Start Apache and MySQL, then open `http://localhost/bpamis/`.

## Deploy on InfinityFree

These steps use the free plan (PHP 8.3, MySQL, no outbound email needed).

### 1. Create the hosting account and database

1. Create a hosting account at InfinityFree and open its **Control Panel**.
2. Open **MySQL Databases**, create a database, and note these four values:
   - MySQL hostname, such as `sql123.infinityfree.com`
   - Database name, such as `if0_12345678_bpamis`
   - MySQL username, such as `if0_12345678`
   - MySQL password, shown on the account page in the client area
3. Click **phpMyAdmin** next to the database, open the **Import** tab, choose `database/demo_seed.sql` and click **Import**.

### 2. Prepare the files

Copy the project to a new folder and **leave these out**. Some of them can hold real personal data or keys:

- `.git/` and `.vscode/`
- Everything inside `uploads/`, `uploads_id/` and `SecMenu/uploads/`, except each folder's `.htaccess`
- `sql/`
- `chatbot/config.env`, `chatbot/.env.example`, `chatbot/log.txt` and `controllers/ocr.env`
- Your local `config/config.local.php`
- Everything inside `storage/logs/`, except `.gitkeep`

Keep `phpmailer/` only if you plan to send real email later. Keep `SecMenu/vendor/` and `OfficialMenu/vendor/` because PDF export uses them.

### 3. Upload

1. In the client area, open **FTP Details** and connect with an FTP client such as FileZilla (host `ftpupload.net`, port `21`).
2. Upload the prepared files into `htdocs/`. Delete InfinityFree's default `index2.html` if it is there.
3. Make sure hidden `.htaccess` files were uploaded. In FileZilla, turn on **Server > Force showing hidden files**.

To run the app in a subfolder, upload into `htdocs/bpamis/` instead. Paths are detected automatically.

### 4. Configure

Create `htdocs/config/config.local.php` with your own values:

```php
<?php
return [
    'db' => [
        'host' => 'sql123.infinityfree.com',
        'port' => 3306,
        'name' => 'if0_12345678_bpamis',
        'user' => 'if0_12345678',
        'pass' => 'your-mysql-password',
    ],
    'demo' => ['enabled' => true],
];
```

### 5. Check the site

1. Open your domain. The BPAMIS home page should load.
2. Open the login page and sign in with each demo login.
3. Confirm these addresses are blocked with a 403 or 404 error:
   - `/config/config.local.php`
   - `/database/demo_seed.sql`
   - `/includes/bootstrap.php`
4. Turn on the free SSL certificate in the Control Panel so the site uses HTTPS.

### Reset the demo data

In phpMyAdmin, select all tables, choose **Drop**, then import `database/demo_seed.sql` again.

## Configuration reference

All settings live in `config/config.local.php`. Anything you leave out uses the default from `config/config.example.php`.

| Setting | Purpose |
| --- | --- |
| `db.*` | Database connection |
| `demo.enabled` | Turns demo mode on or off |
| `mail.*` | SMTP delivery. Only used when `mail.enabled` is true and demo mode is off |
| `chatbot.openrouter_api_key` | Optional. Without a key, the assistant answers from the built-in guide |
| `ocr.api_key` | Optional OCR.Space key for ID checks |
| `app.base_path` | Optional override when the site path is not detected correctly |
| `app.debug` | Shows PHP errors. Keep this `false` on a public site |

Never commit `config/config.local.php`. It is listed in `.gitignore`.

## Before using real data

This repository is prepared for a public demo with fictional data. Before storing real residents' information:

- Turn demo mode off and set new SMTP, API and database credentials.
- Use HTTPS only.
- Review the access rules in `includes/bootstrap.php` and escape all stored text when it is displayed.
- Keep complaint attachments and valid IDs in storage that is not reachable by URL.
