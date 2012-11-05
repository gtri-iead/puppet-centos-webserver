define apache::vhost(
  $modinf = undef,
  $r_vhost
  /*
    name => 'NAME',
    ensure => installed, # installed|latest|present|absent
    port => '80',
    baseURL => 'http://SERVERNAME',
    serverName => 'www.example.org',
    adminEmail => 'admin@example.org',
    aliases => undef, # May be an undef, string or array. Other forms of server name ex: server.org, www.server.org, etc
    conffile => "$apache::params::vhost_d_path/NAME.conf", # Where to store the conf file
    confpath => "$apache::params::vhost_d_path/NAME.d", # Where to store conf files specific to this vhost
    logpath => "$apache::params::logpath/NAME", # Set to undef to use the main apache logs
    basepath => "$apache::params::wwwpath/NAME", # Base path for docroot and cgi-bin
    docroot => {
      path => "$apache::params::wwwpath/NAME/html", # Where the html for this vhost is stored
      options => '-Indexes FollowSymLinks',
      allowOverride => 'none',
      order => 'allow,deny',
      allowFrom => 'all',
    },
    cgibinpath => "$apache::params::wwwpath/NAME/cgi-bin" # Set to undef to disable cgi-bin for this vhost
  */ 
) {

  include apache::params

  $_modinf = $modinf ? { default => $modinf, undef => $apache::params::modinf }

  $ensure = $r_vhost[ensure]

  # START PATTERN file_defaults
  $dirEnsure = $ensure ? { default => directory, absent => absent }
  $fileEnsure = $ensure ? { default => present, absent => absent }

  File {
    force => true,
    ensure => $fileEnsure,
    owner => root,
    group => root,
    mode => 644,
  }
  #END PATTERN

  $vhostname = $r_vhost[name]
  $port = $r_vhost[port]
  $serverName = $r_vhost[serverName]
  $adminEmail = $r_vhost[adminEmail]
  $aliases = $r_vhost[aliases]
  $conffile = $r_vhost[conffile]
  $confpath = $r_vhost[confpath]
  $logpath = $r_vhost[logpath]  
  $basepath = $r_vhost[basepath]
  $docrootpath = $r_vhost[docroot][path]
  $cgibinpath = $r_vhost[cgibinpath]

  $useCgiBin = $cgibinpath ? { undef => false, default => true }
  $useDefaultLogs = $logpath ? { undef => true, default => false }
  
  $serverAliases = $aliases ? {
    default => inline_template('<% if aliases.respond_to?(\'each\') %><% aliases.each do |a| %><%= "\tServerAlias " %><%= a %><%= "\n" %><% end %><% else %><%= "\tServerAlias " %><%= aliases %><%= "\n" %><% end %>'),
   'unset' => '',
  }

  apache::directory { $name:
    r_directory => $r_vhost[docroot],
   r_vhost => $r_vhost
  }
 
  if !defined(File[$basepath]) {
    file { $basepath: ensure => $dirEnsure, mode => 755, }

    if $ensure != absent { Class['apache::config_files'] -> File[$basepath] } else { Class['apache::config_files'] <- File[$basepath] }
  }

  if !defined(File[$docrootpath]) {
    file { $docrootpath: ensure => $dirEnsure, mode => 755, }

    if $ensure != absent { File[$basepath] -> File[$docrootpath] } else { File[$basepath] <- File[$docrootpath] }
  }

  if $cgibinpath and !defined(File[$cgibinpath]) {
    file { $cgibinpath: ensure => $dirEnsure, mode => 755, }

    if $ensure != absent { File[$basepath] -> File[$cgibinpath] } else { File[$basepath] <- File[$cgibinpath] }   
  }

  if $logpath and !defined(File[$logpath]) {
    file { $logpath: ensure => $dirEnsure, mode => 700, }

    if $ensure != absent { File[$basepath] -> File[$logpath] } else { File[$basepath] <- File[$logpath] }
  }

  file { $confpath: ensure => $dirEnsure, mode => 755, }
  
  file { $conffile: content => template("apache/vhost.conf.erb"), }
  
  if $ensure != absent {   
    apache::test { $name :
      modinf => $_modinf,
      r_vhost => $r_vhost,
    }

    Class['apache::config_files'] -> File[$conffile] ~> Class['apache::init_service']
    Class['apache::config_files'] -> File[$confpath] -> Apache::Directory[$name]
    
  } else {

    File[$conffile] ~> Class['apache::init_service']

# TODO: puppet bug below causes cyclical dep. Puppet automaticaly creates relationship File[$params::vhost_d_path] -> File[$conffile]
#    Class['apache::config_files'] <- File[$conffile]  
  }
}
