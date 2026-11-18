<?php
/**
 * Record-level access checks for residents and external complainants.
 * Officials are already limited by role in includes/bootstrap.php.
 */
require_once __DIR__ . '/bootstrap.php';

/** True when the logged-in resident or external complainant is a party to the case. */
function bpamis_user_can_view_case(mysqli $conn, int $caseId): bool
{
    $role = bpamis_current_role();
    $userId = (int)($_SESSION['user_id'] ?? 0);
    if ($caseId <= 0 || $userId <= 0) {
        return false;
    }

    if ($role === 'resident') {
        $stmt = $conn->prepare(
            'SELECT 1 FROM case_info cs
             JOIN complaint_info ci ON cs.Complaint_ID = ci.Complaint_ID
             LEFT JOIN complaint_respondents cr ON cr.complaint_id = ci.Complaint_ID AND cr.respondent_id = ?
             LEFT JOIN case_participants cp ON cp.Case_ID = cs.Case_ID AND cp.Resident_ID = ?
             WHERE cs.Case_ID = ?
               AND (ci.Resident_ID = ? OR ci.Respondent_ID = ? OR cr.id IS NOT NULL OR cp.Participant_ID IS NOT NULL)
             LIMIT 1'
        );
        if (!$stmt) {
            return false;
        }
        $stmt->bind_param('iiiii', $userId, $userId, $caseId, $userId, $userId);
    } elseif ($role === 'external') {
        $stmt = $conn->prepare(
            'SELECT 1 FROM case_info cs
             JOIN complaint_info ci ON cs.Complaint_ID = ci.Complaint_ID
             WHERE cs.Case_ID = ? AND ci.external_complainant_id = ?
             LIMIT 1'
        );
        if (!$stmt) {
            return false;
        }
        $stmt->bind_param('ii', $caseId, $userId);
    } else {
        return $role !== '';
    }

    $stmt->execute();
    $stmt->store_result();
    $allowed = $stmt->num_rows > 0;
    $stmt->close();
    return $allowed;
}
