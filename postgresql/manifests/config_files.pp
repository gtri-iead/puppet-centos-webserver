class postgresql::config_files($modinf, $paths, $rootUserPassword) {

  $ensure = $modinf[ensure]
  $version = $modinf[version]
  
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
        
  file { $paths[rootpwdfile]:
    content => "*:*:*:root:$rootUserPassword\n",
    mode => 600,
  }

  # This file has to be installed *after* initdb executes, otherwise initdb will fail
  file { $params::pg_hbafile:
    owner => 'postgres',
    group => 'postgres',
    source => "puppet:///modules/postgresql/pg_hba.conf",
  }

  file { $params::rootpgpassfile :
    content => "*:*:*:root:$rootUserPassword\n",
    mode => 600,
  }
/*
  file { $params::initsqlfile:
    content => "CREATE USER root WITH CREATEUSER CREATEDB ENCRYPTED PASSWORD '$rootUserPassword';\n",
    owner => postgres, # postgres user must be able to read the file 
    mode => 460,
  }
*/      
}
