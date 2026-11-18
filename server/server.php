<?php
/**
 * Shared database connection. Credentials come from config/config.local.php.
 */
require_once __DIR__ . '/../includes/bootstrap.php';

if (!isset($conn) || !($conn instanceof mysqli)) {
    $conn = @new mysqli(
        (string)bpamis_config('db.host', 'localhost'),
        (string)bpamis_config('db.user', ''),
        (string)bpamis_config('db.pass', ''),
        (string)bpamis_config('db.name', ''),
        (int)bpamis_config('db.port', 3306)
    );

    if ($conn->connect_errno) {
        error_log('server.php: DB connection failed (' . $conn->connect_errno . ')');
        bpamis_deny(503, 'The service is temporarily unavailable. Please try again later.');
    }

    // Prefer utf8mb4 when possible
    @$conn->set_charset('utf8mb4');

    // Consistent behaviour on any host, whatever its default SQL mode.
    @$conn->query("SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION'");
    @$conn->query("SET time_zone = '+08:00'");
}

// DB compatibility helpers (mysqlnd-less hosts, case-sensitive table names)
require_once __DIR__ . '/../includes/db_compat.php';
