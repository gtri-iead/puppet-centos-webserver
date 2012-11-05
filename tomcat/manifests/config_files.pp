class tomcat::config_files($modinf, $paths, $rootUserPassword) {

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
  $linkEnsure = $ensure ? { default => link, absent => absent }      


  file { $paths[liblink]:
    ensure => $linkEnsure,
    target => $paths[libpath],
  }

  file { $paths[loglink]:
    ensure => $linkEnsure,
    target => $paths[logpath],
  }

  file { $paths[sharelink]:
    ensure => $linkEnsure,
    target => $paths[sharepath],
  }
   
  file { $paths[tomcat_users_xmlfile]:
    content => template("tomcat/tomcat-users.xml.erb"),
  }

  file { $paths[tomcat_manager_root_pwdfile]:
    content => $rootUserPassword,
    mode => 600,
  }
  
}
