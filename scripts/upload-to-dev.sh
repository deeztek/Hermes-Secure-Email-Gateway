#!/bin/bash
# =============================================================================
# upload-to-dev.sh — Upload changed web files to DEV server via scp
#
# Uploads only git-changed files under config/hermes/var/www/html/ to the
# DEV server. Non-web changes (SQL, Docker, scripts) are shown as reminders.
#
# Usage:
#   ./scripts/upload-to-dev.sh              # Changed since last upload
#   ./scripts/upload-to-dev.sh --commits 3  # Changed in last 3 commits
#   ./scripts/upload-to-dev.sh --since abc  # Changed since commit abc
#   ./scripts/upload-to-dev.sh --dry-run    # Show what would be uploaded
#   ./scripts/upload-to-dev.sh --all        # Upload ALL web files (full sync)
#
# First-time setup:
#   1. Edit the configuration variables below
#   2. Run: ssh-copy-id -i ~/.ssh/id_rsa.pub USER@HOST
#   3. Test: ssh USER@HOST "echo ok"
# =============================================================================

# ======================== CONFIGURATION ========================
# Edit these variables for your DEV server, or set as environment variables
DEV_HOST="192.168.50.145"                     # DEV server hostname or IP (e.g., 10.0.0.5)
DEV_USER="dedwards"                 # SSH username
DEV_KEY="$HOME/.ssh/id_rsa"       # SSH private key path
REMOTE_BASE="/opt/hermes-seg-container-gl/config/hermes/var/www/html"               # Prefix prepended to remote paths (usually empty)
                                             # e.g., if files go to /var/www/html/ on DEV,
                                             # leave empty since the local path already maps
# ===============================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Local prefix to strip — everything after this becomes relative to REMOTE_BASE
# e.g., config/hermes/var/www/html/admin/2/foo.cfm → admin/2/foo.cfm
LOCAL_WEB_PREFIX="config/hermes/var/www/html"
WEB_PATH_FILTER="config/hermes/var/www/html/"
UPLOAD_TAG="dev-uploaded"

# Counters
uploaded=0
skipped=0
failed=0
errors=""

# Parse arguments
DRY_RUN=false
UPLOAD_ALL=false
BASE_COMMIT=""
COMMITS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --all)
            UPLOAD_ALL=true
            shift
            ;;
        --commits)
            COMMITS="$2"
            shift 2
            ;;
        --since)
            BASE_COMMIT="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run       Show what would be uploaded without uploading"
            echo "  --all           Upload ALL web files (full sync)"
            echo "  --commits N     Upload files changed in last N commits"
            echo "  --since HASH    Upload files changed since commit HASH"
            echo "  -h, --help      Show this help"
            echo ""
            echo "Default: uploads files changed since last upload (tag: $UPLOAD_TAG)"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Ensure we're in the repo root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$REPO_ROOT" ]]; then
    echo -e "${RED}Error: Not inside a git repository${NC}"
    exit 1
fi
cd "$REPO_ROOT"

# Check configuration
if [[ -z "$DEV_HOST" ]]; then
    echo -e "${RED}Error: DEV_HOST is not configured${NC}"
    echo ""
    echo "Edit the configuration section at the top of this script:"
    echo "  $0"
    echo ""
    echo "Set at minimum:"
    echo "  DEV_HOST=\"your-dev-server-ip\""
    echo "  DEV_USER=\"root\""
    exit 1
fi

# Test SSH connectivity
echo -e "${BLUE}Testing SSH connection to ${DEV_USER}@${DEV_HOST}...${NC}"
if ! ssh -i "$DEV_KEY" -o ConnectTimeout=5 -o BatchMode=yes "$DEV_USER@$DEV_HOST" "echo ok" &>/dev/null; then
    echo -e "${RED}Error: Cannot connect to ${DEV_USER}@${DEV_HOST}${NC}"
    echo ""
    echo "Setup SSH key authentication:"
    echo "  ssh-copy-id -i ${DEV_KEY}.pub ${DEV_USER}@${DEV_HOST}"
    echo ""
    echo "Or manually:"
    echo "  cat ${DEV_KEY}.pub | ssh ${DEV_USER}@${DEV_HOST} \"mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys\""
    echo ""
    echo "Then test: ssh -i ${DEV_KEY} ${DEV_USER}@${DEV_HOST} \"echo ok\""
    exit 1
fi
echo -e "${GREEN}SSH connection OK${NC}"
echo ""

# Determine which files to upload
declare -a web_files=()
declare -a deleted_files=()
declare -a non_web_files=()
declare -a non_web_deleted=()

if [[ "$UPLOAD_ALL" == true ]]; then
    echo -e "${BOLD}Mode: Full sync (all web files)${NC}"
    while IFS= read -r f; do
        web_files+=("$f")
    done < <(find "$WEB_PATH_FILTER" -type f 2>/dev/null | sort)
else
    # Determine base commit
    if [[ -n "$BASE_COMMIT" ]]; then
        echo -e "${BOLD}Mode: Changes since commit ${BASE_COMMIT}${NC}"
    elif [[ -n "$COMMITS" ]]; then
        BASE_COMMIT="HEAD~${COMMITS}"
        echo -e "${BOLD}Mode: Changes in last ${COMMITS} commit(s)${NC}"
    elif git rev-parse "$UPLOAD_TAG" &>/dev/null; then
        BASE_COMMIT="$UPLOAD_TAG"
        tag_date=$(git log -1 --format="%ci" "$UPLOAD_TAG" 2>/dev/null | cut -d' ' -f1,2)
        echo -e "${BOLD}Mode: Changes since last upload (${tag_date})${NC}"
    else
        BASE_COMMIT="HEAD~1"
        echo -e "${BOLD}Mode: Changes in last commit (no previous upload tag found)${NC}"
    fi

    # Get modified/added/renamed files (committed)
    while IFS= read -r f; do
        [[ -z "$f" ]] && continue
        if [[ "$f" == ${WEB_PATH_FILTER}* ]]; then
            web_files+=("$f")
        else
            non_web_files+=("$f")
        fi
    done < <(git diff --name-only --diff-filter=ACMR "$BASE_COMMIT"..HEAD 2>/dev/null)

    # Get deleted files (committed)
    while IFS= read -r f; do
        [[ -z "$f" ]] && continue
        if [[ "$f" == ${WEB_PATH_FILTER}* ]]; then
            deleted_files+=("$f")
        else
            non_web_deleted+=("$f")
        fi
    done < <(git diff --name-only --diff-filter=D "$BASE_COMMIT"..HEAD 2>/dev/null)

    # Get uncommitted modified files in the web path
    while IFS= read -r f; do
        [[ -z "$f" ]] && continue
        if [[ "$f" == ${WEB_PATH_FILTER}* ]]; then
            # Avoid duplicates
            local_dup=false
            for existing in "${web_files[@]+"${web_files[@]}"}"; do
                if [[ "$existing" == "$f" ]]; then
                    local_dup=true
                    break
                fi
            done
            if [[ "$local_dup" == false ]]; then
                web_files+=("$f")
            fi
        fi
    done < <(git diff --name-only -- "$WEB_PATH_FILTER" 2>/dev/null)

    # Get untracked files in the web path
    while IFS= read -r f; do
        [[ -z "$f" ]] && continue
        if [[ "$f" == ${WEB_PATH_FILTER}* ]]; then
            web_files+=("$f")
        fi
    done < <(git ls-files --others --exclude-standard -- "$WEB_PATH_FILTER" 2>/dev/null)
fi

# Check if there's anything to do
if [[ ${#web_files[@]} -eq 0 && ${#deleted_files[@]} -eq 0 && ${#non_web_files[@]} -eq 0 && ${#non_web_deleted[@]} -eq 0 ]]; then
    echo -e "${GREEN}Nothing to upload — no changes found.${NC}"
    exit 0
fi

# Show web files to upload
if [[ ${#web_files[@]} -gt 0 ]]; then
    echo ""
    echo -e "${BOLD}Web files to upload (${#web_files[@]}):${NC}"
    for f in "${web_files[@]}"; do
        remote_path="${REMOTE_BASE}/${f#${LOCAL_WEB_PREFIX}/}"
        # Flag static assets
        if [[ "$f" == *"/plugins/"* || "$f" == *"/dist/"* ]]; then
            echo -e "  ${CYAN}$f${NC} → ${remote_path} ${YELLOW}(static asset)${NC}"
        else
            echo -e "  ${CYAN}$f${NC} → ${remote_path}"
        fi
    done
fi

# Show deleted files
if [[ ${#deleted_files[@]} -gt 0 ]]; then
    echo ""
    echo -e "${BOLD}${RED}Deleted files (manual removal needed on DEV):${NC}"
    for f in "${deleted_files[@]}"; do
        remote_path="${REMOTE_BASE}/${f#${LOCAL_WEB_PREFIX}/}"
        echo -e "  ${RED}DELETE${NC} ${remote_path}"
    done
fi

# Dry run — stop here
if [[ "$DRY_RUN" == true ]]; then
    echo ""
    echo -e "${YELLOW}DRY RUN — no files were uploaded${NC}"
    # Still show non-web reminders
    show_non_web_reminders=true
else
    show_non_web_reminders=true

    # Upload files
    if [[ ${#web_files[@]} -gt 0 ]]; then
        echo ""
        echo -e "${BOLD}Uploading...${NC}"

        for f in "${web_files[@]}"; do
            # Skip binary files
            if [[ "$f" == *.deb || "$f" == *.jar || "$f" == *.war || "$f" == *.zip || "$f" == *.tar.gz ]]; then
                echo -e "  ${YELLOW}SKIP${NC} $f (binary file)"
                skipped=$((skipped + 1))
                continue
            fi

            # Check file exists locally
            if [[ ! -f "$f" ]]; then
                echo -e "  ${YELLOW}SKIP${NC} $f (file not found locally)"
                skipped=$((skipped + 1))
                continue
            fi

            remote_path="${REMOTE_BASE}/${f#${LOCAL_WEB_PREFIX}/}"
            remote_dir=$(dirname "$remote_path")

            # Ensure remote directory exists and upload
            if ssh -i "$DEV_KEY" -o BatchMode=yes "$DEV_USER@$DEV_HOST" "mkdir -p '$remote_dir'" 2>/dev/null && \
               scp -i "$DEV_KEY" -q "$f" "$DEV_USER@$DEV_HOST:$remote_path" 2>/dev/null; then
                echo -e "  ${GREEN}OK${NC} $remote_path"
                uploaded=$((uploaded + 1))
            else
                echo -e "  ${RED}FAIL${NC} $remote_path"
                failed=$((failed + 1))
                errors+="  $f\n"
            fi
        done
    fi

    # Update tracking tag (only if uploads succeeded and no failures)
    if [[ $uploaded -gt 0 && $failed -eq 0 && "$UPLOAD_ALL" != true ]]; then
        git tag -f "$UPLOAD_TAG" HEAD &>/dev/null
    fi
fi

# Show non-web file reminders
if [[ "$show_non_web_reminders" == true && (${#non_web_files[@]} -gt 0 || ${#non_web_deleted[@]} -gt 0) ]]; then
    echo ""
    echo -e "${BOLD}${YELLOW}=== Manual Actions Required ===${NC}"

    # Categorize non-web files
    declare -a sql_files=()
    declare -a docker_files=()
    declare -a script_files=()
    declare -a template_files=()
    declare -a config_files=()
    declare -a other_files=()

    for f in "${non_web_files[@]}"; do
        case "$f" in
            updates/*/sql/*|*.sql)
                sql_files+=("$f")
                ;;
            Docker/*|docker-compose.yml|dockerfiles/*)
                docker_files+=("$f")
                ;;
            config/hermes/opt/hermes/scripts/*)
                script_files+=("$f")
                ;;
            config/hermes/opt/hermes/templates/*)
                template_files+=("$f")
                ;;
            config/*)
                config_files+=("$f")
                ;;
            *)
                other_files+=("$f")
                ;;
        esac
    done

    if [[ ${#sql_files[@]} -gt 0 ]]; then
        echo ""
        echo -e "${CYAN}SQL (run on hermes_db_server):${NC}"
        for f in "${sql_files[@]}"; do
            echo "  $f"
        done
    fi

    if [[ ${#docker_files[@]} -gt 0 ]]; then
        echo ""
        echo -e "${CYAN}Docker (rebuild images / restart containers):${NC}"
        for f in "${docker_files[@]}"; do
            echo "  $f"
        done
    fi

    if [[ ${#script_files[@]} -gt 0 ]]; then
        echo ""
        echo -e "${CYAN}Scripts (upload to /opt/hermes/scripts/ on DEV):${NC}"
        for f in "${script_files[@]}"; do
            echo "  $f"
        done
    fi

    if [[ ${#template_files[@]} -gt 0 ]]; then
        echo ""
        echo -e "${CYAN}Templates (upload to /opt/hermes/templates/ on DEV):${NC}"
        for f in "${template_files[@]}"; do
            echo "  $f"
        done
    fi

    if [[ ${#config_files[@]} -gt 0 ]]; then
        echo ""
        echo -e "${CYAN}Config files (upload to matching paths on DEV):${NC}"
        for f in "${config_files[@]}"; do
            remote_path="/${f#config/hermes/}"
            echo "  $f → $remote_path"
        done
    fi

    if [[ ${#other_files[@]} -gt 0 ]]; then
        echo ""
        echo -e "${CYAN}Other changed files:${NC}"
        for f in "${other_files[@]}"; do
            echo "  $f"
        done
    fi

    if [[ ${#non_web_deleted[@]} -gt 0 ]]; then
        echo ""
        echo -e "${RED}Deleted non-web files (remove from DEV):${NC}"
        for f in "${non_web_deleted[@]}"; do
            echo "  $f"
        done
    fi
fi

# Summary
echo ""
echo -e "${BOLD}=== Summary ===${NC}"
if [[ "$DRY_RUN" == true ]]; then
    echo -e "  Would upload: ${#web_files[@]} file(s)"
    [[ ${#deleted_files[@]} -gt 0 ]] && echo -e "  ${RED}Deleted: ${#deleted_files[@]} file(s) need manual removal${NC}"
    [[ ${#non_web_files[@]} -gt 0 ]] && echo -e "  ${YELLOW}Non-web changes: ${#non_web_files[@]} file(s) need manual action${NC}"
else
    [[ $uploaded -gt 0 ]] && echo -e "  ${GREEN}Uploaded: $uploaded file(s)${NC}"
    [[ $skipped -gt 0 ]] && echo -e "  ${YELLOW}Skipped: $skipped file(s)${NC}"
    [[ $failed -gt 0 ]] && echo -e "  ${RED}Failed: $failed file(s)${NC}"
    [[ ${#deleted_files[@]} -gt 0 ]] && echo -e "  ${RED}Deleted: ${#deleted_files[@]} file(s) need manual removal${NC}"
    [[ ${#non_web_files[@]} -gt 0 ]] && echo -e "  ${YELLOW}Non-web changes: ${#non_web_files[@]} file(s) need manual action${NC}"

    if [[ $failed -gt 0 ]]; then
        echo ""
        echo -e "${RED}Failed uploads:${NC}"
        echo -e "$errors"
        exit 1
    fi

    if [[ $uploaded -gt 0 ]]; then
        echo ""
        echo -e "${GREEN}Upload complete. Tag '${UPLOAD_TAG}' updated to HEAD.${NC}"
    fi
fi
