class mysql::config_files($modinf, $paths, $rootUserPassword) {

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
        
  file { $params::etcfile :
    content => template('mysql/my.cnf.erb'),
    mode => 600,
  }

  file { $paths[pwdfile] :
    content => "[client]\nuser=root\npassword=$rootUserPassword\n",
    mode => 600,
  }
    
}
