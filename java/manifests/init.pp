class java($version, $ensure) {

  include java::params, ppext::params

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
        
  
  $packageName = "java-$version-openjdk"

  $paths = {
    java_home => "${params::jvm}/jre-$version-openjdk",
  }

  if $ensure != absent {
    
    class { 'java::validate_params': modinf => $modinf }
    ->
    ppext::module { $params::module : modinf => $modinf }
    ->
    class { 'java::install_packages' : 
      packageName => $packageName,
      modinf => $modinf,
    }
    ->
    class { 'java::config_files' :
      modinf => $modinf,
      paths => $paths,
    }
    ->
    class { 'java::test' : modinf => $modinf }
    
  } else {

    class { 'java::config_files' :
      modinf => $modinf,
      paths => $paths,
    }
    ->
    class { 'java::install_packages' :
      modinf => $modinf,
      packageName => $packageName,
    }
    ->          
    ppext::module { $module : modinf => $modinf  }
    
  }
}
