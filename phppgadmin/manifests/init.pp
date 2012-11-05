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
