class log4j($version,$ensure) {

  include log4j::params

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
        
  if $ensure != absent {
    
    # Install
    ppext::module { $module : modinf => $modinf }
    ->
    class { 'log4j::install_packages' : modinf => $modinf }
    
  } else {
  
    # Uninstall
    ppext::module { $module : modinf => $modinf }
    <- 
    class { 'log4j::install_packages' : modinf => $modinf }

  }

}