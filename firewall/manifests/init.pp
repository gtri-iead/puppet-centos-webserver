class firewall($version, $ensure) {

  include firewall::params, ppext::params

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
    
    ppext::module { $module : modinf => $modinf }
    ->
    class { 'firewall::install_packages' : modinf => $modinf }
    ->
    class { 'firewall::config_files' : modinf => $modinf  }
    ->
    class { 'firewall::init_service' : modinf => $modinf }
    ->
    class { 'firewall::test' : modinf => $modinf }

    File[$params::iptablesfile] ~> Service['firewall']
    
  } else {

    ppext::module { $module : modinf => $modinf }
    
    class { 'firewall::install_packages' : modinf => $modinf }
    <-
    class { 'firewall::config_files' : modinf => $modinf  }
    <-
    class { 'firewall::init_service' : modinf => $modinf }
  
  }
}
