<?php require_once __DIR__ . '/../includes/bootstrap.php';
/**
 * Marks one notification as read for the secretary's notification list.
 */
require_once __DIR__ . '/../server/server.php';

header('Content-Type: application/json; charset=utf-8');

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Invalid method']);
    exit;
}

$payload = json_decode((string)file_get_contents('php://input'), true);
$id = (int)($payload['id'] ?? ($_POST['id'] ?? 0));
if ($id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid notification']);
    exit;
}

$stmt = $conn->prepare('UPDATE notifications SET is_read = 1, is_read_secretary = 1 WHERE notification_id = ?');
if (!$stmt) {
    echo json_encode(['success' => false, 'message' => 'Unable to update notification']);
    exit;
}
$stmt->bind_param('i', $id);
$stmt->execute();
$stmt->close();

echo json_encode(['success' => true]);
