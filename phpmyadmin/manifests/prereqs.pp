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

define phpmyadmin::prereqs($modinf) {

  if $modinf[ensure] != absent {
    
    Class['ppdb'] -> Phpmyadmin::Prereqs[$name]

    # Thread for apache restart
    Class['apache::config_files'] -> Phpmyadmin::Prereqs[$name]
    # TODO: Shouldn't need to restart apache for no apparent reason; test fails otherwise with odd php error
    Phpmyadmin::Init_database[$name] ~> Service['apache']

    Class['php'] -> Phpmyadmin::Prereqs[$name]   
    Class['mysql'] -> Phpmyadmin::Prereqs[$name]
    realize Package['php-mysql']
    Package['php-mysql'] -> Phpmyadmin::Prereqs[$name]

    
    Service['apache'] -> Phpmyadmin::Test[$name]
    
  } else {
  
    Class['ppdb'] <- Phpmyadmin::Prereqs[$name]
#    Class['apache'] <- Phpmyadmin::Prereqs[$name]
    Service['apache'] <- Phpymadmin::Prereqs[$name]
    Class['php'] <- Phpmyadmin::Prereqs[$name]
#    Class['mysql'] <- Phpmyadmin::Prereqs[$name]
    Service['mysql'] <- Phpmyadmin::Prereqs[$name]
  
    realize Package['php-mysql'] # Not needed but shouldnt hurt
    Package['php-mysql'] <- Phpmyadmin::Prereqs[$name]
  }
}
