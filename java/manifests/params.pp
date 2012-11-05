class java::params {

  include ppext::params, paths
  
  $module = 'java'
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
        
  $java_shfile = "$paths::profile_d/java.sh"
  
  $jvm = $paths::jvm
  $javashare_path = "$paths::usr_share/java"
  
  $JAVA = "$paths::usr_bin/java"
}
  
