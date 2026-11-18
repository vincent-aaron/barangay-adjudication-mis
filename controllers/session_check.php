<?php require_once __DIR__ . '/../includes/bootstrap.php';
// Returns JSON indicating whether a session is currently active.

header('Content-Type: application/json');
header('Cache-Control: no-cache, no-store, must-revalidate');
header('Pragma: no-cache');
header('Expires: 0');

function bpamis_role_redirect(string $role): string
{
    $pages = [
        'resident'   => '../ResidentMenu/home-resident.php',
        'external'   => '../ExternalMenu/home-external.php',
        'secretary'  => '../SecMenu/home-secretary.php',
        'lupon_head' => '../LuponHeadMenu/home-luponhead.php',
        'lupon'      => '../OfficialMenu/home-lupon.php',
        'captain'    => '../OfficialMenu/home-captain.php',
    ];
    return $pages[$role] ?? bpamis_url('bpamis_website/bpamis.php');
}

$role = bpamis_current_role();
$result = ['logged_in' => false];
if ($role !== '') {
    $result = [
        'logged_in' => true,
        'redirect'  => bpamis_role_redirect($role),
        'user'      => $_SESSION['username'] ?? $_SESSION['official_name'] ?? '',
    ];
}
echo json_encode($result);
exit;
