<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' => 
  array (
    'host' => 'hermes_nextcloud_redis',
    'password' => 'NEXTCLOUD_REDIS_PASSWORD',
    'port' => 6379,
  ),
  // overwriteprotocol, overwritewebroot, and overwrite.cli.url are
  // intentionally NOT defined here. They are owned by the official
  // Nextcloud Docker image's reverse-proxy.config.php which reads them
  // from the OVERWRITEPROTOCOL, OVERWRITEWEBROOT, and OVERWRITECLIURL
  // environment variables in docker-compose.yml on every request. Defining
  // them here would create two writers fighting over the same keys and
  // caused a URL doubling bug in the OIDC auto-redirect flow.
  'trusted_proxies' =>
  array (
    0 => '172.16.0.0/12',
    1 => '127.0.0.1',
  ),
  'allow_local_remote_servers' => true,
  'mail_smtpmode' => 'smtp',
  'mail_smtphost' => 'hermes_postfix_dkim',
  'mail_smtpport' => '10026',
  'mail_smtpsecure' => '',
  'mail_smtpauth' => false,
  'mail_smtpauthtype' => 'LOGIN',
  'mail_smtpname' => '',
  'mail_from_address' => 'postmaster',
  'mail_domain' => 'NEXTCLOUD_MAIL_DOMAIN',
  'mail_smtppassword' => '',
  'upgrade.disable-web' => true,
  'passwordsalt' => 'NEXTCLOUD_PASSWORD_SALT',
  'secret' => 'NEXTCLOUD_SECRET',
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'NEXTCLOUD_TRUSTED_DOMAIN_HOST',
    2 => 'NEXTCLOUD_TRUSTED_DOMAIN_IP',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'mysql',
  'version' => 'NEXTCLOUD_VERSION',
  'dbname' => 'nextcloud',
  'dbhost' => 'hermes_db_server:3306',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'NEXTCLOUD_DB_USER',
  'dbpassword' => 'NEXTCLOUD_DB_PASSWORD',
  'installed' => true,
  'instanceid' => 'NEXTCLOUD_INSTANCE_ID',
  'defaultapp' => 'mail',
  'lost_password_link' => 'disabled',
  'oidc_login_provider_url' => 'OIDC_LOGIN_PROVIDER_URL',
  'oidc_login_client_id' => 'Hermes_SEG_Webmail',
  'oidc_login_client_secret' => 'OIDC_LOGIN_CLIENT_SECRET',
  'oidc_login_auto_redirect' => OIDC_LOGIN_AUTO_REDIRECT,
  'oidc_login_logout_url' => '/users/logout.cfm',
  'oidc_login_end_session_redirect' => false,
  'oidc_login_button_text' => 'Click to Login to Webmail',
  'oidc_login_hide_password_form' => false,
  'oidc_login_use_id_token' => true,
  'oidc_login_attributes' => 
  array (
    'id' => 'preferred_username',
    'name' => 'name',
    'mail' => 'email',
    'groups' => 'groups',
  ),
  'oidc_login_allowed_groups' =>
  array (
    0 => 'nextcloud',
  ),
  'oidc_login_default_group' => '',
  'oidc_login_use_external_storage' => false,
  'oidc_login_scope' => 'openid profile email groups',
  'oidc_login_proxy_ldap' => false,
  'oidc_login_disable_registration' => false,
  'oidc_login_redir_fallback' => false,
  'oidc_login_tls_verify' => true,
  'oidc_login_code_challenge_method' => 'S256',
  'oidc_create_groups' => false,
  'oidc_login_webdav_enabled' => true,
  'oidc_login_password_authentication' => true,
  'oidc_login_public_key_caching_time' => 86400,
  'oidc_login_min_time_between_jwks_requests' => 10,
  'oidc_login_well_known_caching_time' => 86400,
  'oidc_login_update_avatar' => false,
  'loglevel' => 2,
  'maintenance' => false,
);
