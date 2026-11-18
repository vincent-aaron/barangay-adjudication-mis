<?php require_once __DIR__ . '/../includes/bootstrap.php';
// Ends the session, clears its cookie and returns to the public homepage.

$_SESSION = [];
if (session_status() === PHP_SESSION_ACTIVE) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', [
        'expires'  => time() - 42000,
        'path'     => $params['path'],
        'secure'   => $params['secure'],
        'httponly' => $params['httponly'],
        'samesite' => 'Lax',
    ]);
    session_destroy();
}

header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header('Expires: 0');

$target = bpamis_url('bpamis_website/bpamis.php?logged_out=1');

$isAjax = strtolower((string)($_SERVER['HTTP_X_REQUESTED_WITH'] ?? '')) === 'xmlhttprequest'
    || isset($_POST['ajax'])
    || strpos((string)($_SERVER['HTTP_ACCEPT'] ?? ''), 'application/json') !== false;
if ($isAjax) {
    header('Content-Type: application/json');
    echo json_encode(['success' => true, 'redirect' => $target]);
    exit;
}

// Tell other open tabs that the user has logged out, then redirect.
$jsTarget = json_encode($target);
echo "<!doctype html><html><head><meta charset='utf-8'><title>Logging out...</title></head><body>
<script>
(function(){
  try { localStorage.removeItem('bpamis_auth'); } catch(e) {}
  try { localStorage.setItem('bpamis-logout', Date.now().toString()); } catch(e) {}
  try { new BroadcastChannel('bpamis-auth').postMessage({type:'logged-out'}); } catch(e) {}
  try { new BroadcastChannel('bpamis-channel').postMessage('logout'); } catch(e) {}
  window.location.replace({$jsTarget});
})();
</script>
</body></html>";
exit;
