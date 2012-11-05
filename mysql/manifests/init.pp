class mysql($ensure, $version, $rootUserPassword) {

  include mysql::params

  # PATTERN BEGIN init_modinf_from_params
  $module = $params::module
  $modinf = {
    name => $module,
    ensure => $ensure,
    version => $version,
    versions => $versions,
    logpath => $params::modinf[logpath],
    logfile => $params::modinf[logfile],
    pwdpath => $params::modinf[pwdpath],
    binpath => $params::modinf[binpath],
    outpath => $params::modinf[outpath],
    flagpath => $params::modinf[flagpath],
    filespath => $params::modinf[filespath],
  }
  #END PATTERN

  $paths = {
    pwdfile => "${modinf[pwdpath]}/mysql.root.pwd"
  }
 
  if $ensure != absent {

    # Install
    ppext::module { $module: modinf => $modinf }
    ->
    class { 'mysql::install_packages' : modinf => $modinf }
    ->
    class { 'mysql::config_files' : modinf => $modinf, paths => $paths, rootUserPassword => $rootUserPassword }
    ->
    class { 'mysql::init_service' : modinf => $modinf } 
    ->  
    class { 'mysql::init_database' : modinf => $modinf, rootUserPassword => $rootUserPassword }
    ->
    class { 'mysql::test' : modinf => $modinf, paths => $paths }  

  } else {

    # Uninstall

    # Uninstalling mysql-server package doesn't get rid of the database
    file { $params::mysqlpath:
      ensure => absent,
      recurse => true,
      force => true,
    }
    <-
    ppext::module { $module: modinf => $modinf }
    <-
    class { 'mysql::install_packages' : modinf => $modinf }
    <-
    class { 'mysql::config_files' : modinf => $modinf, paths => $paths, rootUserPassword => $rootUserPassword }
    <-
    class { 'mysql::init_service' : modinf => $modinf }
  
  }
    
}
