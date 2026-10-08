# v261009 manual checks

Needs outbound Internet access to the breached-password service.

| Check | Pass |
| --- | --- |
| Request a password reset, open the emailed link, set `Password123!` | rejected with "Compromised Password" |
| Same link, set a strong password | accepted; the user can log in with it |
