class tomcat($version, $rootUserPassword, $ensure) {
  
  include tomcat::params, paths

  $tmp = split($version,'\.')
  $packageName = "tomcat${tmp[0]}"
 
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
    
  $paths = {
    etcpath => "$paths::etc/$packageName",
    sharepath => "$paths::usr_share/$packageName",
    sharelink => "$paths::usr_share/tomcat",
    libpath => "$paths::var_lib/$packageName",
    liblink => "$paths::var_lib/tomcat",
    logpath => "$paths::var_log/$packageName",
    loglink => "$paths::var_log/tomcat",
    tomcat_users_xmlfile => "$paths::etc/$packageName/tomcat-users.xml",
    tomcat_manager_root_pwdfile => $params::tomcat_manager_root_pwdfile,
  }

  if $ensure != absent {
    
    ppext::module { $params::module : modinf => $modinf }
    ->
    class { 'tomcat::prereqs' : modinf => $modinf, paths => $paths }
    ->
    class { 'tomcat::install_packages' : modinf => $modinf, packageName => $packageName }
    ->
    class { 'tomcat::config_files' :
      modinf => $modinf,
      paths => $paths,
      rootUserPassword => $rootUserPassword,
    }
    ->
    class { 'tomcat::config_logging' : modinf => $modinf, paths => $paths }
    ->
    class { 'tomcat::init_service' : modinf => $modinf, packageName => $packageName }
    ->
    class { 'tomcat::test' : modinf => $modinf }
    
  } else {

    ppext::module { $params::module : modinf => $modinf }
    <-
    class { 'tomcat::prereqs' : modinf => $modinf, paths => $paths }
    <-
    class { 'tomcat::install_packages' : modinf => $modinf, packageName => $packageName }
    <-
    class { 'tomcat::config_files' :
      modinf => $modinf,
      paths => $paths,
      rootUserPassword => $rootUserPassword,
    }
    <-
    class { 'tomcat::config_logging' : modinf => $modinf, paths => $paths }  
    <-
    class { 'tomcat::init_service' : modinf => $modinf, packageName => $packageName }
  
  }
  
}
