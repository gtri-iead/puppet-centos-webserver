define phppgadmin($version, $ensure, $destpath, $testURL) {

  include ppext::params, phppgadmin::params
  
  $module = "phppgadmin-${name}"
  $modinf = {
    name => $module,
    version => $version,
    ensure => $ensure,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }

  $tmp = split($version, '\.')

  $majorVersion = $tmp[0]
  $minorVersion = $tmp[1]
  
  $paths = {
    config_inc_phpfile => "$destpath/conf/config.inc.php",
  }
  $unpackDir = "phpPgAdmin-$version"
  $downloadURL = "http://sourceforge.net/projects/phppgadmin/files/phpPgAdmin%20%5Bstable%5D/phpPgAdmin-${majorVersion}.${minorVersion}/phpPgAdmin-${version}.tar.gz/download"

  phppgadmin::validate_params { $name: modinf => $modinf }

  if $ensure != absent {

    ppext::module { $module : modinf => $modinf }
    ->
    phppgadmin::prereqs { $name : modinf => $modinf }
    ->
    phppgadmin::install_files { $name :
      modinf => $modinf,
      destpath => $destpath,
      downloadURL => $downloadURL,
      unpackDir => $unpackDir,
    }
    ->
    phppgadmin::config_files { $name :
      modinf => $modinf,
      paths => $paths,
    }
    ->
    phppgadmin::test { $name:
      modinf => $modinf,
      testURL => $testURL,
    }
    
  } else {

    ppext::module { $module : modinf => $modinf }
    <-
    phppgadmin::prereqs { $name : modinf => $modinf }
    <-
    phppgadmin::install_files { $name :
      modinf => $modinf,
      destpath => $destpath,
      downloadURL => $downloadURL,
      unpackDir => $unpackDir,
    }
    <-
    phppgadmin::config_files { $name :
      modinf => $modinf,
      paths => $paths,
    }
                      
  }
}
