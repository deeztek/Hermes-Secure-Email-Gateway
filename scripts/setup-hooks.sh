#!/bin/bash
# Hermes SEG - Git Hooks Setup Script
# Run this script to install pre-commit and pre-push hooks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "Setting up Git hooks for Hermes SEG..."
echo ""

# Check if gitleaks is installed
if ! command -v gitleaks &> /dev/null; then
    echo "WARNING: gitleaks is not installed."
    echo ""
    echo "Please install gitleaks:"
    echo "  Windows (scoop): scoop install gitleaks"
    echo "  Windows (choco): choco install gitleaks"
    echo "  macOS: brew install gitleaks"
    echo "  Linux: https://github.com/gitleaks/gitleaks/releases"
    echo ""
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Copy pre-commit hook
cp "$SCRIPT_DIR/pre-commit" "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"
echo "Installed: pre-commit hook"

# Copy pre-push hook
cp "$SCRIPT_DIR/pre-push" "$HOOKS_DIR/pre-push"
chmod +x "$HOOKS_DIR/pre-push"
echo "Installed: pre-push hook"

echo ""
echo "Git hooks installed successfully!"
echo ""
echo "Hooks will:"
echo "  - pre-commit: Scan staged files for secrets before each commit"
echo "  - pre-push: Scan entire repo for secrets before each push"
echo ""
echo "To test gitleaks manually:"
echo "  gitleaks detect --source . --config .gitleaks.toml"
echo ""
