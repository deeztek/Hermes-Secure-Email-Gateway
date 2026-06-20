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
    3 => 'hermes_nextcloud',
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
  // user_oidc provider is configured via occ user_oidc:provider command
  // (client_id, client_secret, discovery_uri, attribute mappings).
  // The settings below control app behavior only.
  'user_oidc' => [
    'default_token_endpoint_auth_method' => 'client_secret_post',
    'auto_provision' => true,
    'soft_auto_provision' => true,
    'single_logout' => true,
    'use_pkce' => true,
  ],
  'allow_user_to_change_display_name' => false,
  'loglevel' => 2,
  'maintenance' => false,
);
