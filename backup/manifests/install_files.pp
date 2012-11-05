class backup::install_files($ensure = undef) {

  $path = $params::path

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
  
  file { $path :
    ensure => $dirEnsure,
    mode => 755,
  }
  ->
  file { "$path/current" :
    ensure => $dirEnsure,
    mode => 755,
  }
  ->
  # TODO: shift_backup uses a copy of named args, should be auto-generated 
  file { "$path/shift_backup.sh" :
    source => 'puppet:///modules/backup/shift_backup.sh',
    mode => 755,
  }
                 
}
