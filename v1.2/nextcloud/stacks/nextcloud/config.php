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
    'host' => 'redis',
    'password' => '',
    'port' => 6379,
  ),
  'upgrade.disable-web' => true,
  'instanceid' => 'ocevnpbh32ga',
  'passwordsalt' => 'x6dSM0leW5yaLyRVMMvHIVgtu8m90k',
  'secret' => 'acY/XQGdg8VVJaMXnvOgaKjG7ERqbl1LthvJcDVNNmWJBh4a',
  'trusted_domains' => 
  array (
    0 => 'nextcloud.kallpa.xyz',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'mysql',
  'version' => '29.0.6.1',
  'overwrite.cli.url' => 'http://nextcloud.kallpa.xyz',
  'dbname' => 'nextcloud',
  'dbhost' => 'db',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextcloud',
  'dbpassword' => 'nextcloud',
  'installed' => true,
);
