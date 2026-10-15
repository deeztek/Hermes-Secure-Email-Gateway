#!/usr/bin/env bash
#
# restore_runtime_config.sh -- keep admin-owned config across an upgrade (#361)
#
# Sourced by scripts/system_update_docker.sh; not run directly.
#
# Several files that admin pages (or services) write are also tracked in git,
# so the upgrade's `git checkout -f` put them back to the repo defaults: DNS
# overrides, DMARC settings, banners, the IPS whitelist, antispam and
# antivirus settings and more, until each page was saved again. The updater's
# preflight already saves everything the checkout discards as a patch
# (`git diff HEAD`). This re-applies the admin-owned part of that patch on top
# of the release, file by file:
#
#   release left the file alone   -> the install's version is restored as is
#   release changed other lines   -> both kept (3-way merge)
#   release changed the same line -> release version kept, reported, so the
#                                    admin re-saves that page
#
# Code, templates and anything not on the list below stay release-owned.
#
# restore_runtime_config <repo root> <drift patch> <log fn> <warn fn>
# Prints nothing itself; reports through the two functions given.

# Paths an admin page or a running service owns, relative to the repo root.
# `case` patterns: * also matches "/".
runtime_owned_path() {
    case "$1" in
        config/unbound/conf.d/*.conf)                                   return 0 ;;
        config/opendmarc/etc/opendmarc/opendmarc.conf)                  return 0 ;;
        config/opendmarc/etc/opendmarc/whitelist.domains)               return 0 ;;
        config/body_milter/etc/hermes/body_milter/*)                    return 0 ;;
        config/fail2ban/config/fail2ban/jail.local)                     return 0 ;;
        config/mail_filter/etc/spamassassin/local.cf)                   return 0 ;;
        config/mail_filter/etc/amavis/white.lst)                        return 0 ;;
        config/mail_filter/etc/amavis/black.lst)                        return 0 ;;
        config/mail_filter/etc/amavis/mynetworks)                       return 0 ;;
        config/mail_filter/etc/clamav/clamd.conf)                       return 0 ;;
        config/mail_filter/etc/fangfrisch/fangfrisch.conf)              return 0 ;;
        config/mail_filter/usr/local/bin/setup-clamav-sigs)             return 0 ;;
        config/openarc/etc/openarc/openarc.conf)                        return 0 ;;
        config/hermes/opt/hermes/arc/PeerList)                          return 0 ;;
        config/hermes/opt/hermes/arc/TrustedHosts)                      return 0 ;;
        config/postfix-dkim/etc/opendkim.conf)                          return 0 ;;
        config/postfix-dkim/etc/postfix-policyd-spf-python/policyd-spf.conf) return 0 ;;
        config/dovecot/conf/dovecot.conf)                               return 0 ;;
        config/ofelia/config.ini)                                       return 0 ;;
        config/hermes/opt/hermes/config/security.conf)                  return 0 ;;
        config/ldap/etc/ldap/slapd.d/*)                                 return 0 ;;
    esac
    return 1
}

# Which page rewrites a file, for the "re-save" message.
runtime_owner_page() {
    case "$1" in
        config/unbound/*)            echo "System > DNS Resolver" ;;
        config/opendmarc/*)          echo "Content Checks > DMARC Settings" ;;
        config/body_milter/*)        echo "the External Banner / Disclaimers / Signatures pages" ;;
        config/fail2ban/*)           echo "System > IPS" ;;
        config/mail_filter/etc/spamassassin/*|config/mail_filter/etc/amavis/*) echo "Antispam Settings" ;;
        config/mail_filter/etc/clamav/*) echo "Antivirus Settings" ;;
        config/mail_filter/*)        echo "the malware feeds page" ;;
        config/openarc/*|config/hermes/opt/hermes/arc/*) echo "ARC Settings" ;;
        config/postfix-dkim/etc/opendkim.conf) echo "Content Checks > DKIM Settings" ;;
        config/postfix-dkim/*)       echo "Content Checks > SPF Settings" ;;
        config/dovecot/*)            echo "Email Server Settings" ;;
        config/ofelia/*)             echo "the scheduled tasks regeneration (schedule/regen_ofelia_config.cfm)" ;;
        config/hermes/opt/hermes/config/security.conf) echo "a manual edit of security.conf" ;;
        config/ldap/*)               echo "no page: the LDAP container rewrites it on start" ;;
        *)                           echo "its settings page" ;;
    esac
}

restore_runtime_config() {
    local root="$1" patch="$2" log_fn="$3" warn_fn="$4"
    local tmp path chunk a_blob base_obj restored=0 merged=0 kept=0
    local -a kept_list=()

    [[ -s "$patch" ]] || { "$log_fn" "No tracked drift was discarded; nothing to restore."; return 0; }

    tmp="$(mktemp -d)" || return 0
    # Split the patch into one file per path ("diff --git a/X b/X" headers).
    awk -v dir="$tmp" '
        /^diff --git a\// { n++; f = dir "/chunk." n; split($0, p, " b/"); print p[2] > (dir "/path." n) }
        n { print > f }' "$patch"

    for pf in "$tmp"/path.*; do
        [[ -e "$pf" ]] || continue
        path="$(cat "$pf")"
        chunk="${pf/path./chunk.}"
        runtime_owned_path "$path" || continue
        # Only plain content edits: skip new, deleted, renamed and binary entries.
        if grep -qE '^(new file mode|deleted file mode|rename from|Binary files)' "$chunk"; then
            continue
        fi
        [[ -f "$root/$path" ]] || continue

        a_blob="$(awk '/^index / { split($2, h, "\\.\\."); print h[1]; exit }' "$chunk")"
        base_obj="$(git -C "$root" rev-parse --verify --quiet "${a_blob}^{blob}" 2>/dev/null)" || base_obj=""
        if [[ -z "$base_obj" ]]; then
            kept=$((kept + 1)); kept_list+=("$path")
            continue
        fi

        # base = the file before the upgrade as git had it; theirs = the
        # install's version (base + the discarded edit); ours = the release.
        mkdir -p "$tmp/w/$(dirname "$path")"
        git -C "$root" cat-file -p "$base_obj" > "$tmp/w/$path"
        cp "$tmp/w/$path" "$tmp/base"
        if ! (cd "$tmp/w" && git apply --whitespace=nowarn "$chunk") 2>/dev/null; then
            kept=$((kept + 1)); kept_list+=("$path")
            continue
        fi
        cp "$tmp/w/$path" "$tmp/theirs"
        cp "$root/$path" "$tmp/ours"

        if cmp -s "$tmp/ours" "$tmp/theirs"; then
            # Already the install's version (a re-run of the same upgrade).
            restored=$((restored + 1))
        elif cmp -s "$tmp/ours" "$tmp/base"; then
            # Release did not touch it: put the install's version back. Written
            # in place (not moved) so single-file bind mounts keep their inode.
            cat "$tmp/theirs" > "$root/$path"
            restored=$((restored + 1))
        elif git merge-file -q -p "$tmp/ours" "$tmp/base" "$tmp/theirs" > "$tmp/merged" 2>/dev/null; then
            cat "$tmp/merged" > "$root/$path"
            merged=$((merged + 1))
        elif cp "$tmp/ours" "$tmp/w/$path" \
             && (cd "$tmp/w" && git apply -C0 --whitespace=nowarn "$chunk") 2>/dev/null; then
            # merge-file calls changes on ADJACENT lines a conflict, which in
            # key/value config files (one setting per line) is the normal case:
            # the admin flips RejectFailures, the release edits the line above.
            # Applying the install's edit without requiring surrounding context
            # still only succeeds where the exact lines the admin changed are
            # present in the release, so a release that rewrote those same
            # lines falls through to "kept" below.
            cat "$tmp/w/$path" > "$root/$path"
            merged=$((merged + 1))
        elif cp "$tmp/ours" "$tmp/w/$path" \
             && (cd "$tmp/w" && git apply -C0 --reverse --check "$chunk") 2>/dev/null; then
            # The install's edit is already in the file (a re-run).
            merged=$((merged + 1))
        else
            kept=$((kept + 1)); kept_list+=("$path")
        fi
    done
    rm -rf "$tmp"

    "$log_fn" "Admin-owned config kept across the upgrade: ${restored} restored, ${merged} merged with release changes."
    if (( kept > 0 )); then
        "$warn_fn" "${kept} admin-owned file(s) could not be carried over and are at the release default:"
        local p
        for p in "${kept_list[@]}"; do
            "$warn_fn" "  ${p}  -> re-apply via $(runtime_owner_page "$p")"
        done
    fi
    return 0
}
