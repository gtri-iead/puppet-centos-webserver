class maven($version, $ensure){

  include maven::params

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
      
  $mvnpath = "$params::destpath/apache-maven-$version"
  $downloadURL = "http://archive.apache.org/dist/maven/binaries/apache-maven-${version}-bin.tar.gz"
  $unpackDir = "apache-maven-$version"

  if $ensure != absent {
    
    class { 'maven::validate_params' : modinf => $modinf }
    ->
    ppext::module { $module : modinf => $modinf }
    ->
    class { 'maven::prereqs' : modinf => $modinf }
    ->
    class { 'maven::install_files' :
      modinf => $modinf,
      mvnpath => $mvnpath,
      downloadURL => $downloadURL,
      unpackDir => $unpackDir,
    }
    ->
    class { 'maven::config_files': modinf => $modinf }
    ->
    class { 'maven::test' : modinf => $modinf }
    
  } else {
 
    class { 'maven::validate_params' : modinf => $modinf }
    <-
    ppext::module { $module : modinf => $modinf }
    <-
    class { 'maven::prereqs' : modinf => $modinf }
    <-
    class { 'maven::install_files' :
      modinf => $modinf,
      mvnpath => $mvnpath,
      downloadURL => $downloadURL,
      unpackDir => $unpackDir,
    }
    <-
    class { 'maven::config_files': modinf => $modinf }
            
  }
}
