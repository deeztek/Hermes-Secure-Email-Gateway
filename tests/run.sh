#!/usr/bin/env bash
# Hermes SEG release tests. For TEST machines only: some checks change state
# (a test ban, a real notification email), so this refuses to run unless
# HERMES_TEST_HOST=1 is set.
#
#   sudo HERMES_TEST_HOST=1 bash tests/run.sh            # every version (regression)
#   sudo HERMES_TEST_HOST=1 bash tests/run.sh v261008    # one release's checks
#
# Layout: tests/v<DATE>/<check>.sh, one file per check, each sourcing
# ../lib.sh and exiting 0 = pass, 1 = fail, 2 = skip (not applicable here).
# Exit code is the number of failed checks.

if [[ "${HERMES_TEST_HOST:-}" != "1" ]]; then
    echo "Refusing to run: these tests change state and are for test machines only."
    echo "Set HERMES_TEST_HOST=1 to confirm this is a test machine."
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="${1:-}"
pass=0; fail=0; skip=0; failed=()

if [[ -n "$VERSION" ]]; then
    [[ -d "$DIR/$VERSION" ]] || { echo "No tests for $VERSION"; exit 1; }
    dirs=("$DIR/$VERSION")
else
    mapfile -t dirs < <(find "$DIR" -mindepth 1 -maxdepth 1 -type d -name 'v[0-9]*' | sort)
fi

for d in "${dirs[@]}"; do
    for c in "$d"/*.sh; do
        [[ -f "$c" ]] || continue
        name="$(basename "$d")/$(basename "$c" .sh)"
        echo "== $name"
        bash "$c"
        case $? in
            0) pass=$((pass + 1)) ;;
            2) skip=$((skip + 1)) ;;
            *) fail=$((fail + 1)); failed+=("$name") ;;
        esac
    done
done

echo
echo "Passed: $pass  Failed: $fail  Skipped: $skip"
for f in "${failed[@]}"; do echo "  failed: $f"; done
exit "$fail"
