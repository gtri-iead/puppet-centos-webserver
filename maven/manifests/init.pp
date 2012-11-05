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
