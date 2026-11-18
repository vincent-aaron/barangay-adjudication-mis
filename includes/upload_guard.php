<?php
/**
 * Validates uploaded files by content, not by the name or type the browser claims.
 */
if (!function_exists('bpamis_upload_check')) {
    /**
     * @param string   $tmpPath      Temporary path from $_FILES
     * @param string   $originalName Client file name
     * @param int      $size         Size in bytes
     * @param string[] $allowedExt   Lower-case extensions that are permitted
     * @param int      $maxBytes     Size limit
     * @return array{ok:bool,ext:string,error:string}
     */
    function bpamis_upload_check(string $tmpPath, string $originalName, int $size, array $allowedExt = ['jpg', 'jpeg', 'png', 'pdf'], int $maxBytes = 5242880): array
    {
        $mimeByExt = [
            'jpg'  => ['image/jpeg'],
            'jpeg' => ['image/jpeg'],
            'png'  => ['image/png'],
            'gif'  => ['image/gif'],
            'webp' => ['image/webp'],
            'pdf'  => ['application/pdf'],
            'doc'  => ['application/msword', 'application/CDFV2', 'application/x-ole-storage'],
            'docx' => ['application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/zip', 'application/octet-stream'],
        ];
        $ext = strtolower((string)pathinfo($originalName, PATHINFO_EXTENSION));

        if (!is_uploaded_file($tmpPath)) {
            return ['ok' => false, 'ext' => $ext, 'error' => 'Invalid upload.'];
        }
        if ($size <= 0 || $size > $maxBytes) {
            return ['ok' => false, 'ext' => $ext, 'error' => 'File is empty or too large.'];
        }
        if (!in_array($ext, $allowedExt, true) || !isset($mimeByExt[$ext])) {
            return ['ok' => false, 'ext' => $ext, 'error' => 'This file type is not allowed.'];
        }
        // Rejects names such as photo.php.jpg, which some servers execute.
        if (preg_match('/\.(php\d?|phtml|phar|pht|shtml|cgi|pl|py|asp|aspx|jsp|htaccess)(\.|$)/i', $originalName)) {
            return ['ok' => false, 'ext' => $ext, 'error' => 'This file type is not allowed.'];
        }
        if (function_exists('finfo_open')) {
            $finfo = finfo_open(FILEINFO_MIME_TYPE);
            $mime = $finfo ? (string)finfo_file($finfo, $tmpPath) : '';
            if ($finfo) {
                finfo_close($finfo);
            }
            if ($mime === '' || !in_array($mime, $mimeByExt[$ext], true)) {
                return ['ok' => false, 'ext' => $ext, 'error' => 'File content does not match its type.'];
            }
        }
        if (in_array($ext, ['jpg', 'jpeg', 'png', 'gif', 'webp'], true) && @getimagesize($tmpPath) === false) {
            return ['ok' => false, 'ext' => $ext, 'error' => 'File is not a valid image.'];
        }
        return ['ok' => true, 'ext' => $ext, 'error' => ''];
    }

    /**
     * Validates an upload against the extension of its destination, then moves it.
     * Used in place of move_uploaded_file() everywhere in the application.
     */
    function bpamis_safe_move(string $tmpPath, string $destination, array $allowedExt = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf', 'doc', 'docx'], int $maxBytes = 5242880): bool
    {
        $size = is_file($tmpPath) ? (int)filesize($tmpPath) : 0;
        $check = bpamis_upload_check($tmpPath, basename($destination), $size, $allowedExt, $maxBytes);
        if (!$check['ok']) {
            error_log('Upload rejected: ' . $check['error']);
            return false;
        }
        return move_uploaded_file($tmpPath, $destination);
    }

    /** Generates an unguessable stored file name with a validated extension. */
    function bpamis_upload_name(string $ext): string
    {
        return bin2hex(random_bytes(16)) . '.' . $ext;
    }
}
