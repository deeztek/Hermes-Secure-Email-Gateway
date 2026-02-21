<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hermes SEG | Password Reset Requests</title>

    <cfinclude template="./inc/html_head.cfm" />

    <!--- Sort Table Script --->
    <script>
        $(document).ready(function() {
            $('#sortTable').DataTable({
                dom: 'Blfrtip',
                buttons: [
                    'copy', 'csv', 'excel', 'pdf', 'print'
                ],
                stateSave: true,
                lengthMenu: [
                    [25, 50, 100, -1],
                    ['25 rows', '50 rows', '100 rows', 'Show all']
                ],
                "order": [[4, "desc"]]
            });
        });
    </script>

    <script>
        $(document).ready(function() {
            $("#resetpwd").click(function() {
                var selectedRequest = [];
                var userType = '';
                $.each($("input[name='id']:checked"), function() {
                    selectedRequest.push($(this).val());
                    userType = $(this).data('usertype');
                });
                if (selectedRequest.length !== 1) {
                    alert('Please select exactly one request to reset.');
                    return false;
                }
                $('#resetpwd_modal').modal('show').on('shown.bs.modal', function() {
                    $("#resetpwdid").html('<input type="hidden" name="request_id" value=' + selectedRequest[0] + '>');

                    // Show notify option only for relay users (they have external email)
                    // Hide for mailbox/admin users (their email IS their mailbox)
                    if (userType === 'relay') {
                        $('#notify_user_group').show();
                        $('#notify_user').prop('checked', true);
                    } else {
                        $('#notify_user_group').hide();
                        $('#notify_user').prop('checked', false);
                    }
                });
            });
        });
    </script>

    <script>
        $(document).ready(function() {
            $("#cancel").click(function() {
                var selectedRequest = [];
                $.each($("input[name='id']:checked"), function() {
                    selectedRequest.push($(this).val());
                });
                $('#cancel_modal').modal('show').on('shown.bs.modal', function() {
                    $("#cancelid").html('<input type="hidden" name="request_ids" value="' + selectedRequest.join(',') + '">');
                });
            });
        });
    </script>

    <!--- HIBP Password Check Script --->
    <script>
        $(document).ready(function() {
            $('#resetpwd_modal form').on('submit', function(e) {
                var checkHibp = $('#check_hibp').is(':checked');
                var password = $('#new_password').val();
                var confirmPassword = $('#confirm_password').val();
                var hibpResult = $('#hibp_result');
                var submitBtn = $('#resetpwd_submit');

                // Clear previous results
                hibpResult.hide().removeClass('alert alert-danger alert-warning alert-success').html('');

                // Basic validation
                if (password !== confirmPassword) {
                    e.preventDefault();
                    hibpResult.addClass('alert alert-danger').html('<i class="fas fa-exclamation-circle"></i> Passwords do not match.').show();
                    return false;
                }

                if (password.length < 8) {
                    e.preventDefault();
                    hibpResult.addClass('alert alert-danger').html('<i class="fas fa-exclamation-circle"></i> Password must be at least 8 characters.').show();
                    return false;
                }

                // If HIBP check is enabled
                if (checkHibp) {
                    e.preventDefault();
                    submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Checking...');

                    $.ajax({
                        url: 'inc/check_hibp.cfm?type=api&password=' + encodeURIComponent(password),
                        type: 'GET',
                        success: function(response) {
                            response = response.trim();
                            if (response === 'Hash Found') {
                                hibpResult.addClass('alert alert-danger').html('<i class="fas fa-exclamation-triangle"></i> <strong>Warning:</strong> This password has appeared in a data breach. Please choose a different password. <a href="https://haveibeenpwned.com/Passwords" target="_blank">Learn more</a>').show();
                                submitBtn.prop('disabled', false).html('Reset Password');
                            } else if (response === 'Hash Not Found') {
                                // Password is safe, submit the form
                                $('#resetpwd_modal form').off('submit').submit();
                            } else if (response === 'Hibp Unreachable') {
                                hibpResult.addClass('alert alert-warning').html('<i class="fas fa-exclamation-triangle"></i> Could not reach haveibeenpwned.com to verify password. Uncheck the HIBP option to proceed without checking.').show();
                                submitBtn.prop('disabled', false).html('Reset Password');
                            }
                        },
                        error: function() {
                            hibpResult.addClass('alert alert-warning').html('<i class="fas fa-exclamation-triangle"></i> Error checking password. Uncheck the HIBP option to proceed without checking.').show();
                            submitBtn.prop('disabled', false).html('Reset Password');
                        }
                    });
                    return false;
                }
            });
        });
    </script>

    <!--- Password Generator and Toggle Script --->
    <script>
        $(document).ready(function() {
            // Generate random password (10 chars, upper/lower/numbers, no special chars)
            function generatePassword() {
                var uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                var lowercase = 'abcdefghijklmnopqrstuvwxyz';
                var numbers = '0123456789';
                var allChars = uppercase + lowercase + numbers;
                var password = '';

                // Ensure at least one of each type
                password += uppercase.charAt(Math.floor(Math.random() * uppercase.length));
                password += lowercase.charAt(Math.floor(Math.random() * lowercase.length));
                password += numbers.charAt(Math.floor(Math.random() * numbers.length));

                // Fill remaining 7 characters randomly
                for (var i = 0; i < 7; i++) {
                    password += allChars.charAt(Math.floor(Math.random() * allChars.length));
                }

                // Shuffle the password to randomize position of guaranteed chars
                return password.split('').sort(function() { return 0.5 - Math.random(); }).join('');
            }

            // Generate password button click
            $('#generate_password').click(function() {
                var newPassword = generatePassword();
                $('#new_password').val(newPassword).attr('type', 'text');
                $('#confirm_password').val(newPassword);
                $('#generated_password_text').text(newPassword);
                $('#generated_password_display').show();
                $('#toggle_password i').removeClass('fa-eye').addClass('fa-eye-slash');
            });

            // Toggle password visibility
            $('#toggle_password').click(function() {
                var pwdField = $('#new_password');
                var icon = $(this).find('i');
                if (pwdField.attr('type') === 'password') {
                    pwdField.attr('type', 'text');
                    icon.removeClass('fa-eye').addClass('fa-eye-slash');
                } else {
                    pwdField.attr('type', 'password');
                    icon.removeClass('fa-eye-slash').addClass('fa-eye');
                }
            });

            // Copy password to clipboard
            $('#copy_password').click(function() {
                var password = $('#generated_password_text').text();
                navigator.clipboard.writeText(password).then(function() {
                    $('#copy_password').html('<i class="fas fa-check"></i>');
                    setTimeout(function() {
                        $('#copy_password').html('<i class="fas fa-copy"></i>');
                    }, 2000);
                });
            });

            // Clear generated password display when modal is hidden
            $('#resetpwd_modal').on('hidden.bs.modal', function() {
                $('#generated_password_display').hide();
                $('#new_password').val('').attr('type', 'password');
                $('#confirm_password').val('');
                $('#toggle_password i').removeClass('fa-eye-slash').addClass('fa-eye');
                $('#hibp_result').hide().html('');
            });
        });
    </script>
</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

    <cfinclude template="./inc/top_navbar.cfm" />
    <cfinclude template="./inc/main_sidebar.cfm" />

    <!-- Content Wrapper. Contains page content -->
    <main class="app-main">

        <!--- PROCESS FORM ACTIONS --->
        <cfparam name="form.action" default="">

        <cfif form.action EQ "reset_password">
            <cfinclude template="./inc/process_admin_password_reset.cfm">
        </cfif>

        <cfif form.action EQ "cancel_requests">
            <cfinclude template="./inc/cancel_password_reset_requests.cfm">
        </cfif>

        <!--- AUTO-CLEANUP: Delete expired requests (never used, no audit value) --->
        <cfquery name="deleteExpired" datasource="hermes">
            DELETE FROM password_reset_requests
            WHERE status = 'pending'
            AND expires_at < NOW()
        </cfquery>

        <!--- AUTO-CLEANUP: Delete old completed requests (older than 30 days) --->
        <cfquery name="deleteOldCompleted" datasource="hermes">
            DELETE FROM password_reset_requests
            WHERE status = 'completed'
            AND completed_at < DATE_SUB(NOW(), INTERVAL 30 DAY)
        </cfquery>

        <!--- GET PASSWORD RESET REQUESTS (last 30 days) --->
        <cfquery name="getRequests" datasource="hermes">
            SELECT id, email, ldap_username, user_type, notification_method, status,
                   requested_at, expires_at, completed_at, completed_by
            FROM password_reset_requests
            ORDER BY requested_at DESC
        </cfquery>

        <!-- Content Header (Page header) -->
        <div class="app-content-header">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-6">
                        <h3 class="mb-0">Password Reset Requests</h3>
                    </div>
                    <div class="col-sm-6">
                        <ol class="breadcrumb float-sm-end">
                            <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Password Reset Requests</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main content -->
        <div class="app-content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12">

                        <!--- STATUS MESSAGES --->
                        <cfif StructKeyExists(session, "message") AND session.message NEQ "">
                            <div class="alert alert-<cfoutput>#session.messageType#</cfoutput> alert-dismissible">
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
                                <cfoutput>#session.message#</cfoutput>
                            </div>
                            <cfset session.message = "">
                            <cfset session.messageType = "">
                        </cfif>

                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Manage Password Reset Requests</h3>
                            </div>
                            <div class="card-body">

                                <!--- ACTION BUTTONS --->
                                <div class="mb-3">
                                    <button type="button" id="resetpwd" name="resetpwd" class="btn btn-success">
                                        <i class="fas fa-key"></i> Reset Password
                                    </button>
                                    <button type="button" id="cancel" name="cancel" class="btn btn-danger">
                                        <i class="fas fa-times"></i> Cancel Request(s)
                                    </button>
                                </div>

                                <!--- REQUESTS TABLE --->
                                <table id="sortTable" class="table table-bordered table-striped">
                                    <thead>
                                        <tr>
                                            <th style="width: 30px;"></th>
                                            <th>Email</th>
                                            <th>User Type</th>
                                            <th>Method</th>
                                            <th>Requested</th>
                                            <th>Expires</th>
                                            <th>Status</th>
                                            <th>Completed By</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="getRequests">
                                            <tr>
                                                <td>
                                                    <cfif status EQ "pending">
                                                        <input type="checkbox" name="id" value="#id#" data-usertype="#user_type#">
                                                    </cfif>
                                                </td>
                                                <td>#email#</td>
                                                <td>
                                                    <cfswitch expression="#user_type#">
                                                        <cfcase value="relay">
                                                            <span class="badge text-bg-info">Relay</span>
                                                        </cfcase>
                                                        <cfcase value="mailbox">
                                                            <span class="badge text-bg-primary">Mailbox</span>
                                                        </cfcase>
                                                        <cfcase value="admin">
                                                            <span class="badge text-bg-warning">Admin</span>
                                                        </cfcase>
                                                    </cfswitch>
                                                </td>
                                                <td>
                                                    <cfswitch expression="#notification_method#">
                                                        <cfcase value="email">
                                                            <i class="fas fa-envelope"></i> Email
                                                        </cfcase>
                                                        <cfcase value="pushover">
                                                            <i class="fas fa-bell"></i> Pushover
                                                        </cfcase>
                                                        <cfcase value="admin">
                                                            <i class="fas fa-user-shield"></i> Admin
                                                        </cfcase>
                                                    </cfswitch>
                                                </td>
                                                <td>#DateFormat(requested_at, "yyyy-mm-dd")# #TimeFormat(requested_at, "HH:mm")#</td>
                                                <td>
                                                    <cfif expires_at NEQ "">
                                                        #DateFormat(expires_at, "yyyy-mm-dd")# #TimeFormat(expires_at, "HH:mm")#
                                                        <cfif expires_at LT Now() AND status EQ "pending">
                                                            <span class="badge text-bg-danger">Expired</span>
                                                        </cfif>
                                                    <cfelse>
                                                        N/A
                                                    </cfif>
                                                </td>
                                                <td>
                                                    <cfswitch expression="#status#">
                                                        <cfcase value="pending">
                                                            <span class="badge text-bg-warning">Pending</span>
                                                        </cfcase>
                                                        <cfcase value="completed">
                                                            <span class="badge text-bg-success">Completed</span>
                                                        </cfcase>
                                                        <cfcase value="expired">
                                                            <span class="badge text-bg-secondary">Expired</span>
                                                        </cfcase>
                                                        <cfcase value="cancelled">
                                                            <span class="badge text-bg-danger">Cancelled</span>
                                                        </cfcase>
                                                    </cfswitch>
                                                </td>
                                                <td>
                                                    <cfif completed_by NEQ "">
                                                        #completed_by#<br>
                                                        <small class="text-muted">#DateFormat(completed_at, "yyyy-mm-dd")# #TimeFormat(completed_at, "HH:mm")#</small>
                                                    <cfelse>
                                                        -
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                </table>

                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <!--- RESET PASSWORD MODAL --->
        <div class="modal fade" id="resetpwd_modal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Reset User Password</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="" method="post">
                        <input type="hidden" name="action" value="reset_password">
                        <div class="modal-body">
                            <div id="resetpwdid"></div>
                            <div class="form-group">
                                <label for="new_password">New Password</label>
                                <div class="input-group">
                                    <input type="password" class="form-control" name="new_password" id="new_password" minlength="8" maxlength="64" required>
                                    <button type="button" class="btn btn-outline-secondary" id="toggle_password" title="Show/Hide Password">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-primary" id="generate_password" title="Generate Password">
                                        <i class="fas fa-random"></i> Generate
                                    </button>
                                </div>
                                <small class="form-text text-muted">Minimum 8 characters</small>
                            </div>
                            <div class="form-group">
                                <label for="confirm_password">Confirm Password</label>
                                <input type="password" class="form-control" name="confirm_password" id="confirm_password" minlength="8" maxlength="64" required>
                            </div>
                            <div id="generated_password_display" class="alert alert-info mt-2" style="display:none;">
                                <strong>Generated Password:</strong> <span id="generated_password_text"></span>
                                <button type="button" class="btn btn-sm btn-outline-secondary ms-2" id="copy_password" title="Copy to clipboard">
                                    <i class="fas fa-copy"></i>
                                </button>
                            </div>
                            <div class="form-check mb-2">
                                <input type="checkbox" class="form-check-input" name="check_hibp" id="check_hibp" value="1" checked>
                                <label class="form-check-label" for="check_hibp">Check password against <a href="https://haveibeenpwned.com/Passwords" target="_blank">haveibeenpwned.com</a></label>
                            </div>
                            <div id="notify_user_group" class="form-check">
                                <input type="checkbox" class="form-check-input" name="notify_user" id="notify_user" value="1" checked>
                                <label class="form-check-label" for="notify_user">Notify user via email</label>
                            </div>
                            <div id="hibp_result" class="mt-2" style="display:none;"></div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-success" id="resetpwd_submit">Reset Password</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!--- CANCEL REQUEST MODAL --->
        <div class="modal fade" id="cancel_modal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Cancel Password Reset Request(s)</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="" method="post">
                        <input type="hidden" name="action" value="cancel_requests">
                        <div class="modal-body">
                            <div id="cancelid"></div>
                            <p>Are you sure you want to cancel the selected password reset request(s)?</p>
                            <p class="text-muted">The user(s) will need to submit a new request if they still need a password reset.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No, Keep</button>
                            <button type="submit" class="btn btn-danger">Yes, Cancel Request(s)</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </main>

    <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>
</html>
