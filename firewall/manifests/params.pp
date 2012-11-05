class firewall::params {

  include paths #, ppext::params

  # ppext module info

  $module = 'firewall'
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
  
  # paths and files  
  $iptablesfile = "$paths::sysconfig/iptables"

  # Commands
  $SERVICE = $paths::SERVICE

  # packages
  $pkg_firewall = 'iptables'

  $svc_firewall = 'iptables'
}
