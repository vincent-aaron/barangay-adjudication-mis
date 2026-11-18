<?php
/**
 * BPAMIS configuration template.
 *
 * Copy this file to config/config.local.php and fill in your own values.
 * config.local.php is git-ignored. Never commit real credentials.
 *
 * Environment variables, when set, override the values below:
 * BPAMIS_DB_HOST, BPAMIS_DB_PORT, BPAMIS_DB_NAME, BPAMIS_DB_USER, BPAMIS_DB_PASS,
 * BPAMIS_DEMO_MODE, BPAMIS_BASE_URL, OPENROUTER_API_KEY, OCR_SPACE_API_KEY
 */
return [
    'app' => [
        // Leave empty to detect automatically. Set only if detection fails,
        // for example '/bpamis' for a subfolder or '' for the domain root.
        'base_path' => null,
        // Never enable on a public site. Shows PHP errors in the browser.
        'debug'     => false,
        'timezone'  => 'Asia/Manila',
    ],

    'demo' => [
        // true: shows demo logins and the fictional-data notice, simulates all
        // email and OTP steps, blocks uploads and account credential changes.
        'enabled'  => true,
        // Shown on the login page. Must match the hash in database/demo_seed.sql.
        'password' => 'BpamisDemo#2026',
        // Code accepted by the simulated forgot-password step.
        'otp'      => '123456',
    ],

    'db' => [
        'host' => 'localhost',
        'port' => 3306,
        'name' => '',
        'user' => '',
        'pass' => '',
    ],

    'mail' => [
        // Set to true only with working SMTP credentials and demo mode off.
        'enabled'    => false,
        'host'       => 'smtp.example.com',
        'port'       => 587,
        'encryption' => 'tls', // tls, ssl or ''
        'username'   => '',
        'password'   => '',
        'from_email' => 'no-reply@example.com',
        'from_name'  => 'Barangay Secretary',
    ],

    'recaptcha' => [
        // Leave both empty to turn reCAPTCHA off.
        'site_key'   => '',
        'secret_key' => '',
    ],

    'chatbot' => [
        // OpenRouter key. Leave empty and the assistant shows a friendly offline message.
        'openrouter_api_key' => '',
        'model'              => 'openai/gpt-4o-mini',
        'app_title'          => 'BPAMIS',
    ],

    'ocr' => [
        // OCR.Space key for valid ID checks. Optional.
        'api_key' => '',
    ],
];
