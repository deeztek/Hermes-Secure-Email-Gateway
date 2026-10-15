#!/usr/bin/env bash
# SpamAssassin's DMARC plugin is off and OpenDMARC can find organizational
# domains (#360). Read-only.
source "$(dirname "$0")/../lib.sh"

if docker exec hermes_mail_filter test -f /etc/spamassassin/v400.pre 2>/dev/null; then
    if docker exec hermes_mail_filter grep -rqE '^\s*loadplugin\s+Mail::SpamAssassin::Plugin::DMARC' /etc/spamassassin/ 2>/dev/null; then
        fail "SpamAssassin still loads its DMARC plugin; DMARC_REJECT scores legitimate mail (#360)"
    else
        pass "SpamAssassin DMARC plugin not loaded"
    fi
else
    fail "/etc/spamassassin/v400.pre missing in hermes_mail_filter (compose mount not applied?) (#360)"
fi

if docker exec hermes_mail_filter spamassassin --lint >/dev/null 2>&1; then
    pass "spamassassin --lint clean"
else
    fail "spamassassin --lint reports errors"
fi

psl="$(docker exec hermes_dmarc awk '$1 == "PublicSuffixList" { print $2 }' /etc/opendmarc/opendmarc.conf 2>/dev/null)"
if [[ -n "$psl" ]] && docker exec hermes_dmarc test -f "$psl" 2>/dev/null; then
    pass "OpenDMARC PublicSuffixList is a file ($psl)"
else
    fail "OpenDMARC PublicSuffixList '$psl' is not a file; subdomains do not inherit DMARC policy (#360)"
fi

done_check
