<?php require_once __DIR__ . '/../includes/bootstrap.php';
require_once __DIR__ . '/../includes/mailer.php';

if (session_status() === PHP_SESSION_NONE) { session_start(); }
require_once __DIR__ . '/../server/server.php';
require_once __DIR__ . '/../includes/rate_limit.php';

// Replace send_email with same debug-aware implementation (identical to above)
function send_email($toEmail, $toName, $subject, $bodyHtml){
    $mail = bpamis_mailer();
    try {

        $mail->addAddress($toEmail, $toName);
        $mail->isHTML(true);
        $mail->Subject = $subject;
        $mail->Body    = $bodyHtml;

        $mail->send();
        return ['success'=>true];
    } catch (Exception $e){
        return ['success'=>false];
    }
}

header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success'=>false,'message'=>'Invalid method']);
    exit;
}

$email = trim($_POST['email'] ?? '');
$otp = trim($_POST['otp'] ?? '');
$new_pass = $_POST['new_password'] ?? '';

if (!filter_var($email, FILTER_VALIDATE_EMAIL) || $otp === '' || strlen($otp) !== 6) {
    echo json_encode(['success'=>false,'message'=>'Invalid input']);
    exit;
}
if (strlen($new_pass) < 6) {
    echo json_encode(['success'=>false,'message'=>'Password must be at least 6 characters']);
    exit;
}

// Demo mode: the code is checked but shared demo passwords are never changed.
if (bpamis_demo_mode()) {
    if (hash_equals((string)bpamis_config('demo.otp', '123456'), $otp)) {
        echo json_encode(['success'=>true,'message'=>'Demo mode: code accepted. The password was not changed.']);
    } else {
        echo json_encode(['success'=>false,'message'=>'Invalid code']);
    }
    exit;
}

// A six-digit code can be guessed, so wrong attempts are limited: 5 per 15 minutes.
if (bpamis_rate_exceeded($conn, 'otp', $email, 5, 900)) {
    echo json_encode(['success'=>false,'message'=>'Too many attempts. Please request a new code later.']);
    exit;
}

// Fetch latest unused, non-expired reset for this email
$now = date('Y-m-d H:i:s');
$stmt = $conn->prepare("SELECT id, otp_hash, expires_at, used FROM password_resets WHERE email = ? AND used = 0 ORDER BY created_at DESC LIMIT 1");
$stmt->bind_param('s', $email);
$stmt->execute();
$res = bpamis_stmt_get_result($stmt);
$token = $res ? $res->fetch_assoc() : null;
$stmt->close();

if (!$token) {
    echo json_encode(['success'=>false,'message'=>'Invalid or expired code']);
    exit;
}
if ($token['expires_at'] < $now) {
    echo json_encode(['success'=>false,'message'=>'Code expired']);
    exit;
}
if (!password_verify($otp, $token['otp_hash'])) {
    bpamis_rate_hit($conn, 'otp', $email, 900);
    echo json_encode(['success'=>false,'message'=>'Invalid code']);
    exit;
}

// Update password in the correct table: resident_info, barangay_officials, external_complainant
bpamis_rate_clear($conn, 'otp', $email);
$hash = password_hash($new_pass, PASSWORD_DEFAULT);
$updated = false;

// try resident_info
$up = $conn->prepare("UPDATE resident_info SET password = ? WHERE email = ? LIMIT 1");
$up->bind_param('ss', $hash, $email);
$up->execute();
if ($up->affected_rows > 0) $updated = true;
$up->close();

if (!$updated) {
    // try officials
    $up = $conn->prepare("UPDATE barangay_officials SET password = ? WHERE email = ? LIMIT 1");
    $up->bind_param('ss', $hash, $email);
    $up->execute();
    if ($up->affected_rows > 0) $updated = true;
    $up->close();
}

if (!$updated) {
    // try external complainant
    $up = $conn->prepare("UPDATE external_complainant SET password = ? WHERE email = ? LIMIT 1");
    $up->bind_param('ss', $hash, $email);
    $up->execute();
    if ($up->affected_rows > 0) $updated = true;
    $up->close();
}

if (!$updated) {
    echo json_encode(['success'=>false,'message'=>'Account not found to update password']);
    exit;
}

// Mark token used
$u2 = $conn->prepare("UPDATE password_resets SET used = 1 WHERE id = ?");
$u2->bind_param('i', $token['id']);
$u2->execute();
$u2->close();

// Send confirmation email
$subject = 'Your BPAMIS password has been changed';
$body = "<p>Dear user,</p>
<p>Your password was successfully changed. If you did not perform this change, please contact the barangay immediately for assistance.</p>
<p>Regards,<br/>BPAMIS</p>";
$mailRes = send_email($email, $email, $subject, $body);

echo json_encode([
    'success' => true,
    'message' => 'Password updated.',
    'email_sent' => (bool)($mailRes['success'] ?? false)
]);
exit;