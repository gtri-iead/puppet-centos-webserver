define apache::proxypass(
  $ensure,
  $r_vhost = undef,
  $proxySource,
  $proxyDest
) {

  include apache::params

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
 
  if !defined(File[$params::proxy_ajp_conffile]) {
    file { $params::proxy_ajp_conffile:
      source => "puppet:///modules/apache/proxy_ajp.conf",
    }
  }

  $conftype = 'proxypass'
  
  #START PATTERN apache_conffile
  if $r_vhost {
    $vhost_confpath = $r_vhost[confpath]
    $conffile = "$vhost_confpath/$name.$conftype.conf"
    File[$vhost_confpath] -> File[$conffile]
  } else {
    $conffile = "$apache::params::conf_d_path/$name.$conftype.conf"
  }

  file { $conffile:
   content => template("apache/$conftype.conf.erb"),
  }
  if $ensure != absent {
    Class['apache::config_files'] -> File[$conffile] ~> Class['apache::init_service']
  } else {
    #TODO: puppet bug below see vhost.pp
    #Class['apache::config_files'] <- File[$conffile]
    File[$conffile] ~> Class['apache::init_service']
  }
  #END PATTERN
           
  File[$params::proxy_ajp_conffile] -> File[$conffile]
                
}
