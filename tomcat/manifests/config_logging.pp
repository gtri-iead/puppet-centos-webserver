class tomcat::config_logging($modinf, $paths) {

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
  
  $javashare_path = $params::javashare_path
  $sharepath = $paths[sharepath]
  
  file { "$sharepath/lib/commons-logging.jar":
    ensure => $linkEnsure,
    target => "$javashare_path/commons-logging.jar",
  }
  file { "$sharepath/lib/log4j.jar":
    ensure => $linkEnsure,
    target => "$javashare_path/log4j.jar",
  }
  file { "$sharepath/lib/log4j.properties":
    source => "puppet:///modules/tomcat/log4j.rolling.properties",
  }
}
