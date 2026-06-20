@echo off
REM Hermes SEG - Git Hooks Setup Script (Windows)
REM Run this script to install pre-commit and pre-push hooks

echo Setting up Git hooks for Hermes SEG...
echo.

REM Check if gitleaks is installed
where gitleaks >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: gitleaks is not installed.
    echo.
    echo Please install gitleaks:
    echo   scoop install gitleaks
    echo   OR
    echo   choco install gitleaks
    echo   OR
    echo   Download from: https://github.com/gitleaks/gitleaks/releases
    echo.
)

REM Get the repository root
for /f "delims=" %%i in ('git rev-parse --show-toplevel 2^>nul') do set REPO_ROOT=%%i

if "%REPO_ROOT%"=="" (
    echo ERROR: Not in a git repository
    exit /b 1
)

set HOOKS_DIR=%REPO_ROOT%\.git\hooks
set SCRIPT_DIR=%~dp0

REM Create hooks directory if it doesn't exist
if not exist "%HOOKS_DIR%" mkdir "%HOOKS_DIR%"

REM Copy pre-commit hook
copy /Y "%SCRIPT_DIR%pre-commit" "%HOOKS_DIR%\pre-commit" >nul
echo Installed: pre-commit hook

REM Copy pre-push hook
copy /Y "%SCRIPT_DIR%pre-push" "%HOOKS_DIR%\pre-push" >nul
echo Installed: pre-push hook

echo.
echo Git hooks installed successfully!
echo.
echo Hooks will:
echo   - pre-commit: Scan staged files for secrets before each commit
echo   - pre-push: Scan entire repo for secrets before each push
echo.
echo To test gitleaks manually:
echo   gitleaks detect --source . --config .gitleaks.toml
echo.
