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

class postgresql($ensure, $version, $rootUserPassword) {

  include postgresql::params, ppext::params

  # PATTERN BEGIN init_modinf_from_params
  $module = $params::module
  $modinf = {
    name => $module,
    ensure => $ensure,
    version => $version,
    versions => $verisons,
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
    rootpwdfile => "${modinf[pwdpath]}/postgresql.root.pwd"
  }

  if $ensure != absent {

    ppext::module { 'postgresql' : modinf => $modinf }
    ->
    class { 'postgresql::install_packages' : modinf => $modinf }
    ->
    class { 'postgresql::init_db': modinf => $modinf }
    ->
    # Config files have to be installed *after* initdb executes, otherwise initdb will fail (with no explanation!!)
    class { 'postgresql::config_files' :
      modinf => $modinf,
      paths => $paths,
      rootUserPassword => $rootUserPassword,
    }    
    ->
    class {'postgresql::init_service' : modinf => $modinf }
    ->
    class { 'postgresql::init_root_user' :
      modinf => $modinf,
      rootUserPassword => $rootUserPassword, }
    ->
    class { 'postgresql::test': modinf => $modinf, paths => $paths }
    
  } else {

    # This removes the database files
    file { $params::pgpath:
      ensure => absent,
      force => true,
      recurse => true,
    }
    <-
    ppext::module { 'postgresql' : modinf => $modinf }
    <-
    class { 'postgresql::install_packages': modinf => $modinf }
    <-
    class { 'postgresql::config_files':
      modinf => $modinf,
      paths => $paths,
      rootUserPassword => $rootUserPassword,
    }
    <-
    class {'postgresql::init_service' : modinf => $modinf }
    
  }
}
