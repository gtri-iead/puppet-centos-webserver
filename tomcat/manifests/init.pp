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
