<?php
/**
 * Demo mode: keeps the public demo safe and repeatable.
 *
 * - Discards file uploads so visitors cannot store real IDs or documents.
 * - Blocks credential changes so the shared demo logins keep working.
 * - Accepts only example.com addresses for new accounts.
 * - Adds a small "Demo with fictional data" notice to every page.
 */

/** Demo accounts shown on the login page. Passwords are hashed in database/demo_seed.sql. */
function bpamis_demo_accounts(): array
{
    return [
        ['role' => 'Secretary',       'email' => 'secretary@example.com'],
        ['role' => 'Lupon Head',      'email' => 'luponhead@example.com'],
        ['role' => 'Barangay Captain', 'email' => 'captain@example.com'],
        ['role' => 'Lupon Member',    'email' => 'lupon@example.com'],
        ['role' => 'Resident',        'email' => 'resident@example.com'],
        ['role' => 'External',        'email' => 'external@example.com'],
    ];
}

function bpamis_demo_block(string $message): void
{
    bpamis_deny(403, 'Demo mode: ' . $message);
}

function bpamis_demo_guard(): void
{
    if (!bpamis_demo_mode() || PHP_SAPI === 'cli') {
        return;
    }

    // No visitor files are kept on the public demo.
    $_FILES = [];

    // Visitors share this site, so markup in form fields is removed before it is stored.
    $skip = ['login_pass', 'reg_pass', 'reg_pass_confirm', 'reg_pass_mobile'];
    array_walk_recursive($_POST, static function (&$value, $key) use ($skip) {
        if (is_string($value) && !in_array($key, $skip, true)) {
            $value = str_replace('"', "'", strip_tags($value));
        }
    });

    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
        return;
    }
    $script = bpamis_script_relative();

    if ($script === 'controllers/registerdb.php') {
        bpamis_demo_block('registration is turned off. Please use one of the demo logins.');
    }
    if (in_array($script, ['controllers/batch_create_residents.php', 'SecMenu/national_id_verifier.php'], true)) {
        bpamis_demo_block('file imports are turned off.');
    }
    if ($script !== 'controllers/verify_forgot_otp.php' && (isset($_POST['ajax_change_password']) || isset($_POST['new_password']) || isset($_POST['current_password']))) {
        bpamis_demo_block('passwords cannot be changed on shared demo accounts.');
    }
    if ($script === 'controllers/account_deactivation.php' || ($script === 'controllers/account_verification.php' && isset($_POST['remove']))) {
        bpamis_demo_block('accounts cannot be deactivated or removed.');
    }
    $profilePages = ['ExternalMenu/profile.php', 'LuponHeadMenu/profile_luponhead.php', 'OfficialMenu/profile-captain.php',
        'OfficialMenu/profilelupon.php', 'ResidentMenu/profile.php', 'SecMenu/profile.php'];
    if (in_array($script, $profilePages, true) && isset($_POST['email'])
        && strcasecmp(trim((string)$_POST['email']), (string)($_SESSION['user'] ?? '')) !== 0) {
        bpamis_demo_block('email addresses cannot be changed on shared demo accounts.');
    }
    if (isset($_POST['new_email'])) {
        bpamis_demo_block('email addresses cannot be changed on shared demo accounts.');
    }
    if (isset($_POST['reg_email'])) {
        $email = strtolower(trim((string)$_POST['reg_email']));
        if (substr($email, -12) !== '@example.com') {
            bpamis_demo_block('new accounts must use an @example.com address.');
        }
    }
}
bpamis_demo_guard();

/** Adds the demo notice to HTML pages. Other responses pass through unchanged. */
function bpamis_demo_output_filter(string $buffer): string
{
    // The first <body> tag is used because later "</body>" text can sit inside inline scripts.
    if (!preg_match('/<body\b[^>]*>/i', $buffer, $match, PREG_OFFSET_CAPTURE)) {
        return $buffer;
    }
    foreach (headers_list() as $header) {
        if (stripos($header, 'content-type:') === 0 && stripos($header, 'text/html') === false) {
            return $buffer;
        }
    }
    $notice = '<div id="bpamis-demo-notice" role="status" style="position:fixed;left:12px;bottom:12px;z-index:2147483000;'
        . 'max-width:calc(100vw - 24px);box-sizing:border-box;padding:6px 12px;border-radius:999px;background:#7c2d12;color:#fff;'
        . 'font:600 12px/1.4 system-ui,-apple-system,Segoe UI,sans-serif;box-shadow:0 2px 8px rgba(0,0,0,.25);pointer-events:none">'
        . 'Demo with fictional data</div>';
    $pos = $match[0][1] + strlen($match[0][0]);
    return substr($buffer, 0, $pos) . $notice . substr($buffer, $pos);
}

if (bpamis_demo_mode() && PHP_SAPI !== 'cli') {
    ob_start('bpamis_demo_output_filter');
}
