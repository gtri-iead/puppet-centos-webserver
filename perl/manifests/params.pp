class perl::params {

  include paths, ppext
/*  
  $module = 'perl'
  $modinf = {
    name => $module,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }
*/        
  $PERL = "$paths::usr_bin/perl"

  $pkg_perl = 'perl'
  $pkg_mod_perl = 'mod_perl'
}
