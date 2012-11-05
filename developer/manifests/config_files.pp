class developer::config_files($ensure) {

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
        
  include developer::params
  
  file { $params::xdebug_php_inifile:
    source => 'puppet:///modules/developer/xdebug.ini',
  }
}
