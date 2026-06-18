<?php
// Simple migration helper: adds Attendance and Reason_Incompliance columns to meeting_logs if they don't exist.
// Run this once from the CLI: php controllers/add_meeting_logs_columns.php
// Or place it temporarily on the server (then remove it) and open in browser if necessary.

include_once __DIR__ . '/../server/server.php';

$cols = function($name) use ($conn) {
    $res = $conn->query("SHOW COLUMNS FROM meeting_logs LIKE '" . $conn->real_escape_string($name) . "'");
    if (!$res) return false;
    $has = $res->num_rows > 0;
    $res->close();
    return $has;
};

$haveAttendance = $cols('Attendance');
$haveReason = $cols('Reason_Incompliance');

if ($haveAttendance && $haveReason) {
    echo "meeting_logs already has Attendance and Reason_Incompliance columns.\n";
    exit(0);
}

$parts = [];
if (!$haveAttendance) $parts[] = "ADD COLUMN Attendance TEXT NULL";
if (!$haveReason) $parts[] = "ADD COLUMN Reason_Incompliance TEXT NULL";

$sql = "ALTER TABLE meeting_logs " . implode(', ', $parts);

if ($conn->query($sql) === TRUE) {
    echo "Successfully updated meeting_logs: added columns.\n";
} else {
    echo "Failed to alter meeting_logs: " . $conn->error . "\n";
}

$conn->close();

?>
