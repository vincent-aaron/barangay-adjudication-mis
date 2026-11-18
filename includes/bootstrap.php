<?php
/**
 * BPAMIS application bootstrap. Loaded first by every PHP entry point.
 *
 * Provides configuration, error handling, base-path detection, session hardening,
 * role-based access control, same-origin checks for POST requests and demo mode.
 */
if (defined('BPAMIS_BOOTSTRAPPED')) {
    return;
}
define('BPAMIS_BOOTSTRAPPED', true);
define('BPAMIS_ROOT', str_replace('\\', '/', dirname(__DIR__)));

/** ini_set() that is safe on hosts where the function is disabled. */
function bpamis_ini(string $key, string $value): void
{
    if (function_exists('ini_set')) {
        @ini_set($key, $value);
    }
}

/* ---------------------------------------------------------------------------
 * Configuration
 * ------------------------------------------------------------------------ */
function bpamis_load_config(): array
{
    static $config = null;
    if ($config !== null) {
        return $config;
    }
    $defaults = require __DIR__ . '/../config/config.example.php';
    $localFile = __DIR__ . '/../config/config.local.php';
    $local = is_file($localFile) ? require $localFile : [];
    $config = array_replace_recursive($defaults, is_array($local) ? $local : []);
    $config['_has_local_file'] = is_file($localFile);

    $env = [
        'BPAMIS_DB_HOST' => ['db', 'host'],
        'BPAMIS_DB_PORT' => ['db', 'port'],
        'BPAMIS_DB_NAME' => ['db', 'name'],
        'BPAMIS_DB_USER' => ['db', 'user'],
        'BPAMIS_DB_PASS' => ['db', 'pass'],
        'OPENROUTER_API_KEY' => ['chatbot', 'openrouter_api_key'],
        'OCR_SPACE_API_KEY' => ['ocr', 'api_key'],
    ];
    foreach ($env as $name => [$section, $key]) {
        $value = getenv($name);
        if ($value !== false && $value !== '') {
            $config[$section][$key] = $value;
        }
    }
    $demo = getenv('BPAMIS_DEMO_MODE');
    if ($demo !== false && $demo !== '') {
        $config['demo']['enabled'] = filter_var($demo, FILTER_VALIDATE_BOOLEAN);
    }
    $base = getenv('BPAMIS_BASE_URL');
    if ($base !== false) {
        $config['app']['base_path'] = $base;
    }
    return $config;
}

/** Reads a config value, for example bpamis_config('db.host'). */
function bpamis_config(string $path, $default = null)
{
    $node = bpamis_load_config();
    foreach (explode('.', $path) as $part) {
        if (!is_array($node) || !array_key_exists($part, $node)) {
            return $default;
        }
        $node = $node[$part];
    }
    return $node;
}

function bpamis_demo_mode(): bool
{
    return (bool)bpamis_config('demo.enabled', false);
}

/* ---------------------------------------------------------------------------
 * Errors: never shown to visitors, logged to a protected folder
 * ------------------------------------------------------------------------ */
$__bpamis_debug = (bool)bpamis_config('app.debug', false);
error_reporting(E_ALL & ~E_DEPRECATED & ~E_NOTICE);
bpamis_ini('display_errors', $__bpamis_debug ? '1' : '0');
bpamis_ini('display_startup_errors', $__bpamis_debug ? '1' : '0');
bpamis_ini('log_errors', '1');
$__bpamis_log_dir = BPAMIS_ROOT . '/storage/logs';
if (!is_dir($__bpamis_log_dir)) {
    @mkdir($__bpamis_log_dir, 0755, true);
}
if (is_dir($__bpamis_log_dir) && is_writable($__bpamis_log_dir)) {
    bpamis_ini('error_log', $__bpamis_log_dir . '/php_errors.log');
}
@date_default_timezone_set((string)bpamis_config('app.timezone', 'Asia/Manila'));
if (function_exists('mysqli_report')) {
    // Keep the classic return-false behaviour that this codebase was written against.
    mysqli_report(MYSQLI_REPORT_OFF);
}

/* ---------------------------------------------------------------------------
 * Paths: works from the domain root or any subfolder
 * ------------------------------------------------------------------------ */
function bpamis_script_relative(): string
{
    $file = realpath((string)($_SERVER['SCRIPT_FILENAME'] ?? ''));
    if ($file === false) {
        return ltrim((string)($_SERVER['SCRIPT_NAME'] ?? ''), '/');
    }
    $file = str_replace('\\', '/', $file);
    $root = str_replace('\\', '/', (string)realpath(BPAMIS_ROOT));
    if (strncmp($file, $root . '/', strlen($root) + 1) === 0) {
        return substr($file, strlen($root) + 1);
    }
    return ltrim((string)($_SERVER['SCRIPT_NAME'] ?? ''), '/');
}

function bpamis_detect_base(): string
{
    $configured = bpamis_config('app.base_path', null);
    if ($configured !== null && $configured !== 'auto') {
        return rtrim((string)$configured, '/');
    }
    $script = str_replace('\\', '/', (string)($_SERVER['SCRIPT_NAME'] ?? ''));
    $relative = bpamis_script_relative();
    if ($relative !== '' && substr($script, -strlen($relative)) === $relative) {
        return rtrim(substr($script, 0, -strlen($relative)), '/');
    }
    return '';
}

define('BPAMIS_BASE', bpamis_detect_base());

// Pages use relative includes such as '../server/server.php', which resolve against the working directory.
if (PHP_SAPI !== 'cli' && !empty($_SERVER['SCRIPT_FILENAME']) && is_dir(dirname((string)$_SERVER['SCRIPT_FILENAME']))) {
    @chdir(dirname((string)$_SERVER['SCRIPT_FILENAME']));
}

/** Builds a root-relative URL for an application path, for example bpamis_url('SecMenu/logo.png'). */
function bpamis_url(string $path = ''): string
{
    return BPAMIS_BASE . '/' . ltrim($path, '/');
}

/* ---------------------------------------------------------------------------
 * Security headers and session hardening
 * ------------------------------------------------------------------------ */
function bpamis_is_https(): bool
{
    return (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
        || (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https');
}

if (PHP_SAPI !== 'cli' && !headers_sent()) {
    header('X-Content-Type-Options: nosniff');
    header('X-Frame-Options: SAMEORIGIN');
    header('Referrer-Policy: strict-origin-when-cross-origin');
    header_remove('X-Powered-By');
}

if (PHP_SAPI !== 'cli' && session_status() === PHP_SESSION_NONE && !headers_sent()) {
    bpamis_ini('session.use_strict_mode', '1');
    bpamis_ini('session.use_only_cookies', '1');
    session_set_cookie_params([
        'lifetime' => 0,
        'path'     => BPAMIS_BASE === '' ? '/' : BPAMIS_BASE . '/',
        'secure'   => bpamis_is_https(),
        'httponly' => true,
        'samesite' => 'Lax',
    ]);
    session_start();
}

/* ---------------------------------------------------------------------------
 * Responses used by the guards below
 * ------------------------------------------------------------------------ */
function bpamis_wants_json(): bool
{
    $accept = (string)($_SERVER['HTTP_ACCEPT'] ?? '');
    $requestedWith = strtolower((string)($_SERVER['HTTP_X_REQUESTED_WITH'] ?? ''));
    $contentType = strtolower((string)($_SERVER['CONTENT_TYPE'] ?? ''));
    return strpos($accept, 'application/json') !== false
        || $requestedWith === 'xmlhttprequest'
        || strpos($contentType, 'application/json') !== false
        || isset($_POST['ajax'])
        || isset($_GET['ajax']);
}

function bpamis_deny(int $status, string $message): void
{
    while (ob_get_level() > 0) {
        @ob_end_clean();
    }
    http_response_code($status);
    if (bpamis_wants_json()) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['success' => false, 'message' => $message, 'error' => $message]);
        exit;
    }
    header('Content-Type: text/html; charset=utf-8');
    $safe = htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
    $home = htmlspecialchars(bpamis_url('bpamis_website/bpamis.php'), ENT_QUOTES, 'UTF-8');
    echo '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">'
        . '<title>BPAMIS</title></head><body style="font-family:system-ui,sans-serif;background:#f4f6fb;color:#1f2937;margin:0;padding:48px 16px;text-align:center">'
        . '<h1 style="font-size:20px;margin:0 0 8px">' . $safe . '</h1>'
        . '<p style="margin:16px 0 0"><a href="' . $home . '" style="color:#0c9ced">Return to BPAMIS</a></p></body></html>';
    exit;
}

/* ---------------------------------------------------------------------------
 * Same-origin check for state-changing requests
 * ------------------------------------------------------------------------ */
if (PHP_SAPI !== 'cli' && ($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
    $__bpamis_source = (string)($_SERVER['HTTP_ORIGIN'] ?? ($_SERVER['HTTP_REFERER'] ?? ''));
    if ($__bpamis_source !== '' && $__bpamis_source !== 'null') {
        $__bpamis_source_host = parse_url($__bpamis_source, PHP_URL_HOST);
        $__bpamis_source_port = parse_url($__bpamis_source, PHP_URL_PORT);
        $__bpamis_source_full = $__bpamis_source_host . ($__bpamis_source_port ? ':' . $__bpamis_source_port : '');
        $__bpamis_host = (string)($_SERVER['HTTP_HOST'] ?? '');
        if ($__bpamis_source_host && strcasecmp($__bpamis_source_full, $__bpamis_host) !== 0
            && strcasecmp((string)$__bpamis_source_host, $__bpamis_host) !== 0) {
            bpamis_deny(403, 'This request was blocked because it came from another site.');
        }
    }
}

/* Query strings never legitimately contain markup. */
if (PHP_SAPI !== 'cli') {
    array_walk_recursive($_GET, static function (&$value) {
        if (is_string($value)) {
            $value = str_replace(['"', '<', '>'], '', strip_tags($value));
        }
    });
}

/* ---------------------------------------------------------------------------
 * Role-based access control. Rules are evaluated from the requested file path,
 * so a page cannot be reached by forgetting a check inside the page itself.
 * ------------------------------------------------------------------------ */
/** Returns secretary, lupon_head, lupon, captain, resident, external or '' for visitors. */
function bpamis_current_role(): string
{
    $role = strtolower((string)($_SESSION['role'] ?? ''));
    if ($role === 'resident' || $role === 'external') {
        return !empty($_SESSION['user_id']) ? $role : '';
    }
    if ($role !== 'official' || empty($_SESSION['official_id'])) {
        return '';
    }
    $position = strtolower((string)($_SESSION['official_position'] ?? ''));
    if (strpos($position, 'lupon-hepe') !== false || strpos($position, 'lupon head') !== false) {
        return 'lupon_head';
    }
    if (strpos($position, 'lupon tagapamayapa') !== false) {
        return 'lupon';
    }
    if (strpos($position, 'barangay captain') !== false) {
        return 'captain';
    }
    return 'secretary';
}

/** Returns 'public', 'login', 'deny' or a list of permitted roles for an application-relative path. */
function bpamis_access_rule(string $path)
{
    $officials = ['secretary', 'lupon_head', 'lupon', 'captain'];
    $publicControllers = ['logindb.php', 'logoutdb.php', 'registerdb.php', 'forgot_password_email.php', 'verify_forgot_otp.php', 'session_check.php'];
    $loginControllers = ['notifications_summary.php', 'delete_notification.php', 'push_notifications.php'];

    if ($path === 'index.php' || strncmp($path, 'bpamis_website/', 15) === 0) {
        return 'public';
    }
    if (in_array($path, ['chatbot/ai.php', 'chatbot/standalone_assistant.php', 'includes/sw.php'], true)) {
        return 'public';
    }
    if (strncmp($path, 'controllers/', 12) === 0) {
        $name = substr($path, 12);
        if (in_array($name, $publicControllers, true)) {
            return 'public';
        }
        if (in_array($name, $loginControllers, true)) {
            return 'login';
        }
        // Creating, verifying and deactivating accounts is limited to the barangay's administrators.
        $accountControllers = ['create_officialdb.php', 'create_externaldb.php', 'create_resident.php', 'batch_create_residents.php',
            'account_activate.php', 'account_activation.php', 'account_deactivation.php', 'account_verification.php',
            'verify_resident.php', 'view_valid_id.php', 'notifications_list.php', 'mark_notification_read.php'];
        if (in_array($name, $accountControllers, true)) {
            return ['secretary', 'captain'];
        }
        return $officials;
    }
    if (strncmp($path, 'SecMenu/schedule/', 17) === 0) {
        $name = substr($path, 17);
        if ($name === 'CalendarResident.php') {
            return array_merge($officials, ['resident']);
        }
        if ($name === 'CalendarExternal.php') {
            return array_merge($officials, ['external']);
        }
        if (in_array($name, ['get_schedule_details.php', 'get_case_participants.php', 'CalendarCaptain.php', 'CalendarLupon.php', 'CalendarLuponHead.php'], true)) {
            return $officials;
        }
        return ['secretary'];
    }
    if (strncmp($path, 'SecMenu/KP-Forms/', 17) === 0) {
        return $officials;
    }
    if (strncmp($path, 'SecMenu/', 8) === 0) {
        return ['secretary'];
    }
    if (strncmp($path, 'LuponHeadMenu/', 14) === 0) {
        return ['lupon_head', 'secretary'];
    }
    if (in_array($path, ['OfficialMenu/add_external_user.php', 'OfficialMenu/add_lupon_account.php'], true)) {
        return ['secretary', 'captain'];
    }
    if (strncmp($path, 'OfficialMenu/', 13) === 0) {
        return $officials;
    }
    if (strncmp($path, 'ResidentMenu/', 13) === 0) {
        return ['resident'];
    }
    if (strncmp($path, 'ExternalMenu/', 13) === 0) {
        return ['external'];
    }
    return 'deny';
}

function bpamis_enforce_access(): void
{
    if (PHP_SAPI === 'cli') {
        return;
    }
    $rule = bpamis_access_rule(bpamis_script_relative());
    if ($rule === 'public') {
        return;
    }
    if ($rule === 'deny') {
        bpamis_deny(404, 'Page not found.');
    }
    $role = bpamis_current_role();
    if ($role === '') {
        if (bpamis_wants_json() || ($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'GET') {
            bpamis_deny(401, 'Please log in to continue.');
        }
        header('Location: ' . bpamis_url('bpamis_website/login.php'));
        exit;
    }
    if ($rule !== 'login' && !in_array($role, $rule, true)) {
        bpamis_deny(403, 'You do not have permission to open this page.');
    }
}
bpamis_enforce_access();

/* ---------------------------------------------------------------------------
 * Demo mode
 * ------------------------------------------------------------------------ */
require_once __DIR__ . '/upload_guard.php';
require_once __DIR__ . '/demo.php';
