<?php
/**
 * Small database-backed rate limiter for login, password reset and the chatbot.
 */
require_once __DIR__ . '/bootstrap.php';

function bpamis_rate_key(string $bucket, string $identity): string
{
    return hash('sha256', $bucket . '|' . strtolower($identity));
}

function bpamis_rate_table(mysqli $conn): void
{
    static $ready = false;
    if (!$ready) {
        @$conn->query('CREATE TABLE IF NOT EXISTS `rate_limits` (
            `rate_key` CHAR(64) NOT NULL PRIMARY KEY,
            `hits` INT NOT NULL DEFAULT 0,
            `window_start` INT NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
        $ready = true;
    }
}

/** True when the identity has used up its attempts in the current window. */
function bpamis_rate_exceeded(mysqli $conn, string $bucket, string $identity, int $maxHits, int $windowSeconds): bool
{
    bpamis_rate_table($conn);
    $key = bpamis_rate_key($bucket, $identity);
    $stmt = $conn->prepare('SELECT hits, window_start FROM `rate_limits` WHERE rate_key = ?');
    if (!$stmt) {
        return false;
    }
    $stmt->bind_param('s', $key);
    $stmt->execute();
    $stmt->bind_result($hits, $start);
    $found = $stmt->fetch();
    $stmt->close();
    return $found && (time() - (int)$start) < $windowSeconds && (int)$hits >= $maxHits;
}

/** Records one attempt. */
function bpamis_rate_hit(mysqli $conn, string $bucket, string $identity, int $windowSeconds): void
{
    bpamis_rate_table($conn);
    $key = bpamis_rate_key($bucket, $identity);
    $now = time();
    $cutoff = $now - $windowSeconds;
    $stmt = $conn->prepare('INSERT INTO `rate_limits` (rate_key, hits, window_start) VALUES (?, 1, ?)
        ON DUPLICATE KEY UPDATE hits = IF(window_start < ?, 1, hits + 1), window_start = IF(window_start < ?, VALUES(window_start), window_start)');
    if ($stmt) {
        $stmt->bind_param('siii', $key, $now, $cutoff, $cutoff);
        $stmt->execute();
        $stmt->close();
    }
}

/** Clears attempts after a success. */
function bpamis_rate_clear(mysqli $conn, string $bucket, string $identity): void
{
    bpamis_rate_table($conn);
    $key = bpamis_rate_key($bucket, $identity);
    $stmt = $conn->prepare('DELETE FROM `rate_limits` WHERE rate_key = ?');
    if ($stmt) {
        $stmt->bind_param('s', $key);
        $stmt->execute();
        $stmt->close();
    }
}

function bpamis_client_ip(): string
{
    return (string)($_SERVER['REMOTE_ADDR'] ?? 'unknown');
}
