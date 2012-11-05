define phpmyadmin($version, $destpath, $testURL, $ensure) {

  include phpmyadmin::params
  
  $module = "phpmyadmin-$name"
  $modinf = {
    name => $module,
    ensure => $ensure,
    version => $version,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }
  $unpackDir = "phpMyAdmin-$version-all-languages"
  $downloadURL = "http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/${version}/phpMyAdmin-$version-all-languages.tar.gz"
  
  $paths = {
    config_inc_phpfile => "$destpath/config.inc.php",
  }

  phpmyadmin::validate_params { $name: modinf => $modinf }

  if $ensure != absent {

    # Install
    ppext::module { $module : modinf => $modinf }
    ->
    phpmyadmin::prereqs { $name : modinf => $modinf }
    ->
    phpmyadmin::install_files { $name :
      modinf => $modinf,
 
      destpath => $destpath,
      unpackDir => $unpackDir,
      downloadURL => $downloadURL,
    }
    ->
    phpmyadmin::config_files { $name :
      modinf => $modinf,
      paths => $paths,
    }
    ->
    phpmyadmin::init_database { $name :
      modinf => $modinf,
    }
    ->
    phpmyadmin::test { $name :
      modinf => $modinf,
      testURL => $testURL,
    }
    
  } else {

    # Uninstall 
    ppext::module { $module : modinf => $modinf }
    <-
    phpmyadmin::uninstall { $name:
      modinf => $modinf,
      destpath => $destpath,
    }
                                   
  }
  
}
