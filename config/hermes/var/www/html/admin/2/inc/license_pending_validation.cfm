<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

License Pending Validation Page
Displayed when server is unreachable and no baseline fingerprint has been established
--->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Validation Required - Hermes SEG</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="/admin/2/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="/admin/2/dist/css/adminlte.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #ffc107 0%, #856404 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .validation-card {
            max-width: 600px;
            margin: 20px;
        }
        .cloud-icon {
            font-size: 5rem;
            color: #ffc107;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

<div class="card validation-card shadow-lg">
    <div class="card-body text-center p-5">
        <i class="fas fa-cloud-upload-alt cloud-icon"></i>
        <h2 class="text-warning mb-3">Online Validation Required</h2>
        <p class="lead">The license server could not be reached and no baseline fingerprint has been established.</p>
        <p class="text-muted">Pro Edition features require at least one successful online validation to establish a security baseline.</p>

        <hr class="my-4">

        <div class="text-start">
            <p><strong>To enable Pro Edition features:</strong></p>
            <ol class="mb-4">
                <li class="mb-2">Ensure this server has internet access to <code>validate.hermesseg.io</code></li>
                <li class="mb-2">Check firewall rules allow outbound HTTPS (port 443)</li>
                <li class="mb-2">Log out and log back in to retry validation</li>
            </ol>
        </div>

        <div class="alert alert-info mt-3">
            <i class="fas fa-info-circle me-2"></i>
            <strong>Why is this required?</strong> The first successful validation establishes a secure fingerprint baseline that allows offline verification of template integrity.
        </div>

        <div class="mt-4">
            <a href="/admin/2/logout.cfm" class="btn btn-primary">
                <i class="fas fa-redo me-1"></i> Log Out and Retry
            </a>
            <a href="mailto:support@deeztek.com" class="btn btn-outline-secondary">
                <i class="fas fa-envelope me-1"></i> Contact Support
            </a>
        </div>
    </div>
</div>

<script src="/admin/2/plugins/jquery/jquery.min.js"></script>
<script src="/admin/2/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
