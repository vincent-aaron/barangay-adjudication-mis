<?php require_once __DIR__ . '/bootstrap.php';

// Serve JS with a permissive Service-Worker-Allowed header so scope can be the app root.
// If deployed under /... => allow scope '/'. If deployed at domain root => allow scope '/'.
$appRoot = BPAMIS_BASE === '' ? '/' : BPAMIS_BASE;

// Set proper headers for service worker
header('Content-Type: application/javascript; charset=utf-8');
header('Service-Worker-Allowed: ' . rtrim($appRoot, '/') . '/');
header('Cache-Control: no-cache, must-revalidate, max-age=0');
header('X-Content-Type-Options: nosniff');

// Read and output the actual service worker file
$swPath = __DIR__ . '/../sw.js';
if (file_exists($swPath)) {
    readfile($swPath);
} else {
    // Fallback minimal service worker if file not found
    echo "self.addEventListener('install', e => self.skipWaiting());\n";
    echo "self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));\n";
}
?>
