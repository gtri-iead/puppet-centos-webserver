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

define phppgadmin::prereqs($modinf) {

  if $modinf[ensure] != absent {
    
    Class['ppdb'] -> Phppgadmin::Prereqs[$name]
    Class['apache'] -> Phppgadmin::Prereqs[$name]
    Class['php'] -> Phppgadmin::Prereqs[$name]
    Class['postgresql'] -> Phppgadmin::Prereqs[$name]
    realize Package['php-pgsql']
    Package['php-pgsql'] -> Phppgadmin::Prereqs[$name]

    Service['apache'] -> Phppgadmin::Test[$name]
    
  } else {
    Class['ppdb'] <- Phppgadmin::Prereqs[$name]
#    Class['apache'] <- Phppgadmin::Prereqs[$name]
    Service['apache'] <- Phppgadmin::Prereqs[$name]
    Class['php'] <- Phppgadmin::Prereqs[$name]
#    Class['postgresql'] <- Phppgadmin::Prereqs[$name]
    Service['postgresql'] <- Phppgadmin::Prereqs[$name]
    realize Package['php-pgsql']
    Package['php-pgsql'] <- Phppgadmin::Prereqs[$name]
  }
}
