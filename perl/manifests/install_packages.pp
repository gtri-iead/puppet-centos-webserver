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

class perl::install_packages($modinf) {

  $version = $modinf[versions]
  $ensure = $modinf[ensure]
  
  ppext::package { 'perl' :
    packageName => $params::pkg_perl,
    version => $versions[perl],
    ensure => $ensure,
  }
  
  ppext::package { 'mod_perl' :
    packageName => $params::pkg_mod_perl,
    version => $versions[mod_perl],
    ensure => $ensure,
    virtual => $ensure ? { default => true, absent => false } # Virtual resource normally, always present for uninstall
  }

  if $ensure != absent {
    # Install
    Ppext::Package['perl'] -> Ppext::Package['mod_perl']
  } else {
    # Uninstall
    Ppext::Package['perl'] <- Ppext::Package['mod_perl']
  }
}
