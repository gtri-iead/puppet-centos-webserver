class maven::params {

  include ppext::params, paths

  $module = 'maven'
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

  
  # For adding mvn to PATH
  $apache_maven_sh = "$paths::profile_d/apache-maven.sh"

  $destpath = "$paths::usr_share"
  $mvn_linkfile = "$paths::usr_bin/mvn"
 
  $MVN = $mvn_linkfile
 
}
