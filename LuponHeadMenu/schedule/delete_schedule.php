<?php require_once __DIR__ . '/../../includes/bootstrap.php';

require_once('db-connect.php');
if(!isset($_GET['id'])){
    echo "<script> alert('Undefined Schedule ID.'); window.location.href = '../view_hearing_calendar.php'; </script>";
    exit;
}

$stmt = $conn->prepare("DELETE FROM `schedule_list` WHERE hearingID = ?");
$stmt->bind_param("i", $_GET['id']);
if($stmt->execute()){
    echo "<script> alert('Event has been deleted successfully.'); window.location.href = '../view_hearing_calendar.php'; </script>";

} else {
    echo "<pre>";
    echo "An Error occurred.<br>";
    echo "Request failed" . "<br>";
    echo "</pre>";
}
$stmt->close();


?>