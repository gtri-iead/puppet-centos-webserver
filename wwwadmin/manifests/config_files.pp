define wwwadmin::config_files($modinf, $paths) {

  $basedir = $paths[basedir]
  $destpath = $paths[destpath]
  $apache_conffile = $paths[apache_conffile]
  $index_htmlfile = $paths[index_htmlfile]
  $phpinfo_phpfile = $paths[phpinfo_phpfile]
  
  $ensure = $modinf[ensure]
  
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
  
  # Apache configuration
  file { $destpath:
    ensure => $dirEnsure,
    mode => 755,
  }
  
  file { $index_htmlfile:
    content => template("wwwadmin/index.html.erb"),
  }
  
  file { $apache_conffile:
    content => template("wwwadmin/apache.conf.erb"),
  }
  
  # PHP info page file
  file { $phpinfo_phpfile:
    content => '<?php phpinfo();',
  }

  if $ensure != absent {
    File[$destpath] -> File[ $index_htmlfile ]
    File[$destpath] -> File[ $phpinfo_phpfile ]
  } else {
    File[$destpath] <- File[ $index_htmlfile ]
    File[$destpath] <- File[ $phpinfo_phpfile ]
  }
}
