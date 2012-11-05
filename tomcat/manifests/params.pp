class tomcat::params {
  include paths,ppext, java::params

  $module = 'tomcat'
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

  $javashare_path = $java::params::javashare_path

  # Link is created to support these in config_files
  $webapps_path = "$paths::var_lib/tomcat/webapps"
  $logpath = "$paths::var_log/tomcat"
  $sharepath = "$paths::usr_share/tomcat"

  $tomcat_manager_root_pwdfile = "${modinf[pwdpath]}/tomcat-manager.root.pwd"
  
  $ECHO = $paths::ECHO
  $CURL = $paths::CURL
  $SLEEP = $paths::SLEEP
  $GREP = $paths::GREP
}
