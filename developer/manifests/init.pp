class developer($ensure) {

  include developer::params

  if $ensure != absent {

    # Install
    class { 'developer::prereqs' : ensure => $ensure }
    ->
    class { 'developer::install_packages' : ensure => $ensure }
    ->
    class { 'developer::config_files' : ensure => $ensure }
    
  } else {

    # Uninstall
    class { 'developer::prereqs' : ensure => $ensure }
    <-
    class { 'developer::install_packages' : ensure => $ensure }
    <-
    class { 'developer::config_files' : ensure => $ensure }
  
  }

}
