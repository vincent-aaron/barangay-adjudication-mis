<?php
/**
 * Central mail sending. Every outgoing email in BPAMIS goes through bpamis_mailer().
 *
 * In demo mode, or when mail is not configured, nothing leaves the server:
 * send() reports success so each workflow can finish, and no recipient is contacted.
 */
require_once __DIR__ . '/bootstrap.php';

/** True only when real SMTP delivery is switched on and configured. */
function bpamis_mail_is_live(): bool
{
    return !bpamis_demo_mode()
        && (bool)bpamis_config('mail.enabled', false)
        && (string)bpamis_config('mail.host', '') !== ''
        && is_file(BPAMIS_ROOT . '/phpmailer/PHPMailer.php');
}

/** Checks that an email domain exists. Always true in demo mode or where DNS functions are disabled. */
function bpamis_domain_resolves(string $domain): bool
{
    if (bpamis_demo_mode() || !function_exists('checkdnsrr')) {
        return true;
    }
    return checkdnsrr($domain, 'A') || checkdnsrr($domain, 'AAAA');
}

class BpamisMail
{
    public string $Subject = '';
    public string $Body = '';
    public string $AltBody = '';
    public string $ErrorInfo = '';
    public bool $simulated = false;

    /** @var array<int, array{0:string,1:string}> */
    private array $to = [];
    private bool $html = true;

    public function addAddress(string $email, string $name = ''): bool
    {
        $this->to[] = [$email, $name];
        return true;
    }

    public function isHTML(bool $isHtml = true): void
    {
        $this->html = $isHtml;
    }

    /** @throws \Exception when live delivery fails */
    public function send(): bool
    {
        if (!bpamis_mail_is_live()) {
            $this->simulated = true;
            return true;
        }

        require_once BPAMIS_ROOT . '/phpmailer/Exception.php';
        require_once BPAMIS_ROOT . '/phpmailer/PHPMailer.php';
        require_once BPAMIS_ROOT . '/phpmailer/SMTP.php';

        $mailer = new \PHPMailer\PHPMailer\PHPMailer(true);
        try {
            $mailer->isSMTP();
            $mailer->Host = (string)bpamis_config('mail.host');
            $mailer->Port = (int)bpamis_config('mail.port', 587);
            $mailer->SMTPAuth = (string)bpamis_config('mail.username', '') !== '';
            $mailer->Username = (string)bpamis_config('mail.username', '');
            $mailer->Password = (string)bpamis_config('mail.password', '');
            $mailer->SMTPSecure = (string)bpamis_config('mail.encryption', 'tls');
            $mailer->CharSet = 'UTF-8';
            $mailer->setFrom((string)bpamis_config('mail.from_email'), (string)bpamis_config('mail.from_name', 'BPAMIS'));
            foreach ($this->to as [$email, $name]) {
                $mailer->addAddress($email, $name);
            }
            $mailer->isHTML($this->html);
            $mailer->Subject = $this->Subject;
            $mailer->Body = $this->Body;
            $mailer->AltBody = $this->AltBody;
            return $mailer->send();
        } catch (\Throwable $e) {
            error_log('Mail delivery failed: ' . $mailer->ErrorInfo);
            $this->ErrorInfo = 'Email could not be sent.';
            throw new \Exception('Email could not be sent.');
        }
    }
}

function bpamis_mailer(): BpamisMail
{
    return new BpamisMail();
}
