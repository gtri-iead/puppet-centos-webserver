class bash::install_files($ensure=undef) {

  include bash::params

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
        

  
  file { $params::match_regexfile_to_outfile_bashfile:
    content => template("bash/match_regexfile_to_outfile.sh.erb"),
    mode => 755,
  }
}
