define phppgadmin::config_files($modinf, $paths) {

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
        
  file { $paths[config_inc_phpfile]:
    source => "puppet:///modules/phppgadmin/config.inc.php",
  }
}
