class perl(
  $ensure,
  $versions
  /* Hash:
    perl,
    mod_perl,
  */
) {
  include perl::params

  $module = 'perl'
  $modinf = {
    name => $module,
    ensure => $ensure,
    versions => $versions,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }
      
  if $ensure != absent  {

    ppext::module { $module : modinf => $modinf }
    ->
    class { 'perl::prereqs' : modinf => $modinf  }
    ->
    class { 'perl::install_packages' : modinf => $modinf }
    ->
    class { 'perl::test' : modinf => $modinf }
    
  } else {

    ppext::module { $module : modinf => $modinf }
#    <- Commented out since uninstall packages will fail - still want to remove other stuff
    class { 'perl::prereqs' : modinf => $modinf  }
#    <-
    class { 'perl::install_packages' : modinf => $modinf }
               
  }
}
  
