/*
    Copyright 2012 Georgia Tech Research Institute

    Author: Lance Gatlin [lance.gatlin@gtri.gatech.edu]
	
    This file is part of puppet-centos-webserver.

    puppet-centos-webserver is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    puppet-centos-webserver is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with puppet-centos-webserver. If not, see <http://www.gnu.org/licenses/>.

*/

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
