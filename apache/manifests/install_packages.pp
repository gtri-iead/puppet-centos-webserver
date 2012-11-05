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

class apache::install_packages($modinf) {

  $version = $modinf[version]
  $ensure = $modinf[ensure]
  
  ppext::package { 'apache':
    packageName => $params::pkg_apache,
    version => $version,
    ensure => $ensure,
  }

  ppext::package { 'mod_ssl':
    packageName => $params::pkg_mod_ssl,
    version => $version,
    ensure => $ensure,
  }
                      
  if $ensure != absent {
    Ppext::Package['apache'] -> Ppext::Package['mod_ssl']
  } else {
    Ppext::Package['mod_ssl'] -> Ppext::Package['apache']
  }
}
