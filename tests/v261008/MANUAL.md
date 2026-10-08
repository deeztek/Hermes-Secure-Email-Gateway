# v261008 manual checks

Checks that need a browser. Run on both test machines after `tests/run.sh`.

| Check | Pass |
| --- | --- |
| User portal: release a quarantined message | green message lists the subject; message delivered |
| User portal: download a message | `.eml` saved, no stuck spinner |
| User portal: allow and block a sender | sender listed under the green message; entry appears in Sender Filters |
