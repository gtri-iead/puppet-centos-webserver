class samba_devel::params {

  include paths, ppext::params
  
  $module = 'samba_devel'
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

  $pkg_samba = 'samba'
  
  $smb_conffile = '/etc/samba/smb.conf'

  
  $ECHO = $paths::ECHO
  $SMBPASSWD = "$paths::usr_bin/smbpasswd"
}
