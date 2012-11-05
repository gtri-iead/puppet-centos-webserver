class ppext($ensure=undef) {

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

  include ppext::params

  $etcpath = $params::etcpath
  $logpath = $params::logpath
  $pwdpath = $params::pwdpath
  $binpath = $params::binpath
  $outpath = $params::outpath
  $flagpath = $params::flagpath
  $filespath  = $params::filespath
  
#  if !defined(File[$etcpath]) {
  # This is currently /etc/puppet - don't want to uninstall it
    file { $etcpath:
      ensure => directory,
      owner => root,
      group => root,
      mode => 755,
    }
#  }

  # define used since this could be the same as etcpath
  if !defined(File[$logpath]) {
    file { $logpath:
      ensure => directory,
      owner => root,
      group => root,
      mode => 755,
    }
  }

  # Should never auto-delete passwords here
  if !defined(File[$pwdpath]) {
    file { $pwdpath:
      ensure => directory,
      owner => root,
      group => root,
      mode => 755,
    }
  }
  if !defined(File[$binpath]) {
    file { $binpath:
      ensure => directory,
      owner => root,
      group => root,
      mode => 755,
    }
  }
  if !defined(File[$outpath]) {
    file { $outpath:
      ensure => directory,
      owner => root,
      group => root,
      mode => 755,
    }
  }
  if !defined(File[$flagpath]) {
    file { $flagpath:
      ensure => directory,
      owner => root,
      group => root,
      mode => 755,
    }
  }
  if !defined(File[$filespath]) {
    file { $filespath:
      ensure => directory,
      owner => root,
      group => root,
      mode => 755,
    }
  }
                
}
