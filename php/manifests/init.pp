class php(
  $versions,
  /* Hash values:
    php,
    dba,
    mysql,
    pgsql,
    pear,
    pecl_apc,
    pecl_memcache,
    mcrypt
  */
  $ensure
) {

  include php::params

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
    class { 'php::prereqs' : modinf => $modinf }
    ->
    class { 'php::install_packages' : modinf => $modinf }
    ->
    class { 'php::config_files' : modinf => $modinf }
    ->
    class { 'php::test' : modinf => $modinf }

  } else {
  
    ppext::module { $module : modinf => $modinf }
    <-
    class { 'php::prereqs' : modinf => $modinf }
    <-
    class { 'php::install_packages' : modinf => $modinf }
    <-
    class { 'php::config_files' : modinf => $modinf }
               
  }
}
