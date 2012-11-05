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

class mysql($ensure, $version, $rootUserPassword) {

  include mysql::params

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
    pwdfile => "${modinf[pwdpath]}/mysql.root.pwd"
  }
 
  if $ensure != absent {

    # Install
    ppext::module { $module: modinf => $modinf }
    ->
    class { 'mysql::install_packages' : modinf => $modinf }
    ->
    class { 'mysql::config_files' : modinf => $modinf, paths => $paths, rootUserPassword => $rootUserPassword }
    ->
    class { 'mysql::init_service' : modinf => $modinf } 
    ->  
    class { 'mysql::init_database' : modinf => $modinf, rootUserPassword => $rootUserPassword }
    ->
    class { 'mysql::test' : modinf => $modinf, paths => $paths }  

  } else {

    # Uninstall

    # Uninstalling mysql-server package doesn't get rid of the database
    file { $params::mysqlpath:
      ensure => absent,
      recurse => true,
      force => true,
    }
    <-
    ppext::module { $module: modinf => $modinf }
    <-
    class { 'mysql::install_packages' : modinf => $modinf }
    <-
    class { 'mysql::config_files' : modinf => $modinf, paths => $paths, rootUserPassword => $rootUserPassword }
    <-
    class { 'mysql::init_service' : modinf => $modinf }
  
  }
    
}
