<?php
require_once __DIR__ . '/../../includes/bootstrap.php';
if (!bpamis_demo_mode()) {
    return;
}
$__demoPassword = (string)bpamis_config('demo.password', '');
?>
<div class="bpamis-demo-logins" style="margin-top:20px;padding:14px;border:1px solid #fed7aa;border-radius:12px;background:#fff7ed;color:#7c2d12;font:14px/1.45 system-ui,-apple-system,'Segoe UI',sans-serif;text-align:left">
    <strong style="display:block;margin-bottom:2px">Demo logins</strong>
    <span style="display:block;font-size:12px;margin-bottom:10px">All data is fictional. Password for every account: <code style="font-weight:700;overflow-wrap:anywhere"><?= htmlspecialchars($__demoPassword, ENT_QUOTES, 'UTF-8') ?></code></span>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(130px,1fr));gap:8px">
        <?php foreach (bpamis_demo_accounts() as $__demoAccount): ?>
            <button type="button"
                data-demo-email="<?= htmlspecialchars($__demoAccount['email'], ENT_QUOTES, 'UTF-8') ?>"
                data-demo-pass="<?= htmlspecialchars($__demoPassword, ENT_QUOTES, 'UTF-8') ?>"
                onclick="(function(b){var f=b.closest('.bpamis-demo-logins').parentElement.querySelector('form');if(!f){return;}[['login_user',b.dataset.demoEmail],['login_pass',b.dataset.demoPass]].forEach(function(p){var i=f.querySelector('[name='+p[0]+']');i.value=p[1];i.dispatchEvent(new Event('input',{bubbles:true}));i.dispatchEvent(new Event('change',{bubbles:true}));});})(this)"
                style="min-height:44px;padding:8px;border:1px solid #fdba74;border-radius:8px;background:#fff;color:#7c2d12;font:600 13px/1.2 system-ui,-apple-system,'Segoe UI',sans-serif;cursor:pointer">
                <?= htmlspecialchars($__demoAccount['role'], ENT_QUOTES, 'UTF-8') ?>
            </button>
        <?php endforeach; ?>
    </div>
</div>
