class apache::config_files($modinf) {

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

  file { $params::vhost_d_path:
    ensure => $dirEnsure,
    mode => 755,
  }
  
  file { $params::httpd_conffile:
    source => "puppet:///modules/apache/httpd.conf",
  }

  file { $params::ssl_conffile:
    source => "puppet:///modules/apache/ssl.conf",
  }
}
