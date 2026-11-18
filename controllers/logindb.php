<?php require_once __DIR__ . '/../includes/bootstrap.php';
require_once __DIR__ . '/../server/server.php';
require_once __DIR__ . '/../includes/db_compat.php';
require_once __DIR__ . '/../includes/rate_limit.php';

$email = trim($_POST['login_user'] ?? '');
$password = $_POST['login_pass'] ?? '';
$isAjax = isset($_POST['ajax']);

$loginPage = '../bpamis_website/login.php';

/** Sends a login failure in the format the calling page expects. */
function bpamis_login_fail(string $message, bool $isAjax, string $target, array $extra = []): void
{
    if ($isAjax) {
        header('Content-Type: application/json');
        echo json_encode(array_merge(['success' => false, 'message' => $message], $extra));
        exit;
    }
    echo '<script>alert(' . json_encode($message) . '); window.location.href=' . json_encode($target) . ';</script>';
    exit;
}

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
    header('Location: ' . $loginPage);
    exit;
}

// basic empty check
if ($email === '' || $password === '') {
    bpamis_login_fail('Please enter both email and password.', $isAjax, $loginPage);
}

// Slow down password guessing: 10 failed attempts per email and address in 15 minutes.
$rateIdentity = $email . '|' . bpamis_client_ip();
if (bpamis_rate_exceeded($conn, 'login', $rateIdentity, 10, 900)) {
    bpamis_login_fail('Too many failed attempts. Please wait 15 minutes and try again.', $isAjax, $loginPage);
}

$TB_BARANGAY_OFFICIALS = bpamis_quote_table(bpamis_table($conn, 'barangay_officials'));
$TB_RESIDENT_INFO = bpamis_quote_table(bpamis_table($conn, 'resident_info'));
$TB_EXTERNAL_COMPLAINANT = bpamis_quote_table(bpamis_table($conn, 'external_complainant'));

// Officials, then residents, then external complainants.
$queries = [
    "SELECT Official_ID AS id, official_username AS username, email, isActive, password, `Name`, Position, 'official' AS user_role
     FROM {$TB_BARANGAY_OFFICIALS} WHERE email = ? LIMIT 1",
    "SELECT Resident_ID AS id, Resident_Username AS username, email, isVerify, isActive, Password AS password, 'resident' AS user_role
     FROM {$TB_RESIDENT_INFO} WHERE email = ? LIMIT 1",
    "SELECT External_Complaint_ID AS id, External_Username AS username, email, isActive, password, 'external' AS user_role
     FROM {$TB_EXTERNAL_COMPLAINANT} WHERE email = ? LIMIT 1",
];

$user = null;
foreach ($queries as $query) {
    $stmt = $conn->prepare($query);
    if (!$stmt) {
        error_log('logindb: prepare failed: ' . $conn->error);
        bpamis_login_fail('Login is temporarily unavailable. Please try again later.', $isAjax, $loginPage);
    }
    $stmt->bind_param('s', $email);
    $stmt->execute();
    $rows = bpamis_stmt_fetch_all_assoc($stmt);
    $stmt->close();
    if (count($rows) === 1) {
        $user = $rows[0];
        break;
    }
}

// The same message is used for an unknown email and a wrong password.
if (!$user || empty($user['password']) || !password_verify($password, $user['password'])) {
    bpamis_rate_hit($conn, 'login', $rateIdentity, 900);
    bpamis_login_fail('Invalid email or password.', $isAjax, $loginPage);
}
$user_type_found = $user['user_role'];

// Account status is only revealed to someone who knows the password.
$registerPage = '../bpamis_website/bpamis.php';
if ($user_type_found === 'resident' && (int)($user['isVerify'] ?? 0) === 0) {
    bpamis_login_fail('Your account is not verified yet. Please wait for the barangay to verify it.', $isAjax, $registerPage, ['redirect' => $registerPage]);
}
if ((int)($user['isActive'] ?? 0) === 0) {
    bpamis_login_fail('Your account is inactive. Please contact or go to the barangay for reactivation.', $isAjax, $registerPage, ['redirect' => $registerPage]);
}

bpamis_rate_clear($conn, 'login', $rateIdentity);

// Role landing pages
$redirect = $loginPage;
switch ($user_type_found) {
    case 'resident':
        $redirect = '../ResidentMenu/home-resident.php';
        break;
    case 'external':
        $redirect = '../ExternalMenu/home-external.php';
        break;
    case 'official':
        $roleText = strtolower($user['Position'] ?? '');
        if (strpos($roleText, 'lupon-hepe') !== false || strpos($roleText, 'lupon head') !== false) {
            $redirect = '../LuponHeadMenu/home-luponhead.php';
        } elseif (strpos($roleText, 'lupon tagapamayapa') !== false) {
            $redirect = '../OfficialMenu/home-lupon.php';
        } elseif (strpos($roleText, 'barangay captain') !== false) {
            $redirect = '../OfficialMenu/home-captain.php';
        } else {
            $redirect = '../SecMenu/home-secretary.php';
        }
        break;
}

// A new session id on login prevents session fixation.
session_regenerate_id(true);
$_SESSION = [];
$_SESSION['user'] = $user['email'];
$_SESSION['username'] = $user['username'] ?? '';
$_SESSION['user_id'] = $user['id'] ?? '';
$_SESSION['role'] = $user_type_found;
if ($user_type_found === 'official') {
    $_SESSION['official_id'] = $user['id'] ?? '';
    $_SESSION['official_name'] = $user['Name'] ?? '';
    $_SESSION['official_position'] = $user['Position'] ?? '';
}

if ($isAjax) {
    header('Content-Type: application/json');
    echo json_encode(['success' => true, 'redirect' => $redirect]);
    exit;
}
header('Location: ' . $redirect);
exit;
