<?php require_once __DIR__ . '/../includes/bootstrap.php';
/**
 * Streams a resident's valid ID image to barangay officials.
 * The uploads_id folder is not reachable by URL, so this is the only way to view these files.
 */
require_once __DIR__ . '/../server/server.php';

$id = (int)($_GET['id'] ?? 0);
$stmt = $conn->prepare('SELECT valid_id_path FROM resident_info WHERE Resident_ID = ? LIMIT 1');
if (!$stmt || $id <= 0) {
    bpamis_deny(404, 'File not found.');
}
$stmt->bind_param('i', $id);
$stmt->execute();
$stmt->bind_result($storedPath);
$found = $stmt->fetch();
$stmt->close();
if (!$found || !$storedPath) {
    bpamis_deny(404, 'File not found.');
}

// Only files inside these two locations can be returned.
$allowedRoots = array_filter([realpath(BPAMIS_ROOT . '/uploads_id'), realpath(BPAMIS_ROOT . '/Assets/Img')]);
$file = realpath(BPAMIS_ROOT . '/' . ltrim(str_replace('\\', '/', (string)$storedPath), '/'));
$inside = false;
foreach ($allowedRoots as $root) {
    if ($file && strncmp($file, $root . DIRECTORY_SEPARATOR, strlen($root) + 1) === 0) {
        $inside = true;
    }
}
$types = ['jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'png' => 'image/png'];
$ext = strtolower((string)pathinfo((string)$file, PATHINFO_EXTENSION));
if (!$inside || !is_file((string)$file) || !isset($types[$ext])) {
    bpamis_deny(404, 'File not found.');
}

while (ob_get_level() > 0) {
    ob_end_clean();
}
header('Content-Type: ' . $types[$ext]);
header('Content-Length: ' . filesize($file));
header('Cache-Control: private, no-store');
readfile($file);
exit;
