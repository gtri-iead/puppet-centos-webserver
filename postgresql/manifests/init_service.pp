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

class postgresql::init_service($modinf) { 

  $SLEEP = $params::SLEEP

  $ensure = $modinf[ensure]

  #START PATTERN init_service
  $service_enable = $ensure ? { default => true, absent => false }
  $service_ensure = $ensure ? { default => running, absent => stopped }
  #END PATTERN
  
  service { 'postgresql':
    name => $params::svc_pg,
    ensure => $service_ensure,
    enable => $service_enable,
    hasstatus => true,
    hasrestart => true,
  }
  ~>
  /* After starting postgres, it doesnt come up immediately even though it returns and reports okydoky */
  exec { 'hurry_up_postgresql' :
    command => "$SLEEP 30",
    refreshonly => true,
  }

}
