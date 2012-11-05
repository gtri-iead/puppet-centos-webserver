class apache::default_vhost(
  $ensure,
  $serverName,
  $adminEmail,
  $aliases = undef,
  $dirOptions = '-Indexes FollowSymLinks',
  $dirAllowFrom = 'all'
) {

  apache::vhost { 'default' :
    ensure => $ensure,
    port => 80,
    adminEmail => $adminEmail,
    path => '/var/www',
    serverName => $serverName,
    aliases => $aliases,
    useDefaultLogs => true,
  }

  apache::directory { 'default':
    ensure => $ensure,
    vhost => 'default',
    htmlpath => '/var/www/html',
    dirOptions => $dirOptions,
    dirAllowFrom => $dirAllowFrom,
  }
            
}
