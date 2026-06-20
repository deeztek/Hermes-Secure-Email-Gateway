<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

NC OIDC LOGIN PRELOADER
Initializes the Nextcloud session cookie before redirecting to the OIDC
login endpoint. This prevents a known NC bug where OVERWRITEWEBROOT
generates broken redirect URLs when the session cookie is created and
the OIDC redirect happen in the same request chain (#209).

Flow:
  1. fetch('/nc/login') initializes the NC session cookie
  2. Once settled, redirect to /nc/apps/user_oidc/login/1
  3. NC sees an initialized session and generates correct Location headers
--->
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Connecting to Webmail...</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: #f4f6f9;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: #333;
        }
        .loading {
            text-align: center;
        }
        .spinner {
            border: 3px solid #e0e0e0;
            border-top: 3px solid #007bff;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            animation: spin 0.8s linear infinite;
            margin: 0 auto 16px;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="loading">
        <div class="spinner"></div>
        <p>Connecting to Webmail...</p>
    </div>
    <script>
        fetch('/nc/login', { credentials: 'include' })
            .then(function() {
                window.location.href = '/nc/apps/user_oidc/login/1';
            })
            .catch(function() {
                window.location.href = '/nc/apps/user_oidc/login/1';
            });
    </script>
</body>
</html>
