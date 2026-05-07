<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

License Tampered Warning Page
Displayed when template integrity check fails
--->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Integrity Violation - Hermes SEG</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="/admin/2/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="/admin/2/dist/css/adminlte.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #dc3545 0%, #721c24 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .violation-card {
            max-width: 600px;
            margin: 20px;
        }
        .shield-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

<div class="card violation-card shadow-lg">
    <div class="card-body text-center p-5">
        <i class="fas fa-shield-alt shield-icon"></i>
        <h2 class="text-danger mb-3">Template Integrity Violation</h2>
        <p class="lead">The system has detected that Pro Edition template files have been modified.</p>
        <p class="text-muted">This may indicate tampering or file corruption.</p>

        <hr class="my-4">

        <div class="text-start">
            <p><strong>To resolve this issue:</strong></p>
            <ol class="mb-4">
                <li class="mb-2">Reinstall Hermes SEG Pro Edition from the official source</li>
                <li class="mb-2">Restore from a known-good backup</li>
                <li class="mb-2">Contact <a href="mailto:support@hermesseg.io">support@hermesseg.io</a> for assistance</li>
            </ol>
        </div>

        <cfif StructKeyExists(session, "tamperMessage") AND Len(session.tamperMessage) GT 0>
            <div class="alert alert-secondary mt-3">
                <strong>Details:</strong> <cfoutput>#HTMLEditFormat(session.tamperMessage)#</cfoutput>
            </div>
        </cfif>

        <div class="mt-4">
            <a href="https://docs.deeztek.com/books/hermes-seg-general-documentation" class="btn btn-outline-secondary" target="_blank">
                <i class="fas fa-book me-1"></i> Documentation
            </a>
            <a href="mailto:support@hermesseg.io" class="btn btn-outline-primary">
                <i class="fas fa-envelope me-1"></i> Contact Support
            </a>
        </div>
    </div>
</div>

<script src="/admin/2/plugins/jquery/jquery.min.js"></script>
<script src="/admin/2/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
