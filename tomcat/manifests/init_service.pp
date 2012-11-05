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

class tomcat::init_service($modinf, $packageName) {

  $ensure = $modinf[ensure]
  $binpath = $modinf[binpath]
  
  #START PATTERN init_service
  $service_enable = $ensure ? { default => true, absent => false }
  $service_ensure = $ensure ? { default => running, absent => stopped }
  #END PATTERN
  
  $SLEEP = $params::SLEEP
  $GREP = $params::GREP
  $CURL = $params::CURL
  
  service { 'tomcat':
    name => $packageName,
    enable => $service_enable,
    ensure => $service_ensure,
    hasstatus => true,
#    hasrestart => true,
    hasrestart => false,
 }

 if $ensure != absent {

   $r_test_connect = {
     name => 'tomcat::test_connect',
     resname => 'test_connect',
     modinf => $modinf
   }
   
   ppext::bashfile { $r_test_connect[name]:
     resinf => $r_test_connect,
     command => [
       "$CURL --silent --show-error --connect-timeout 1 -I http://localhost:8080 2>&1 | $GREP 'Coyote'",
       "exit $?",
     ],
   }
   ->
   # After starting tomcat service, it doesn't come up immediately even though it returns and reports okydoky 
   ppext::exec { "${module}::wait_for_tomcat_to_really_start" :
     modinf => $modinf,
     command => [
        # From http://stackoverflow.com/questions/376279/wait-until-tomcat-finishes-starting-up
        "until $binpath/test_connect",
        "do",
        "$SLEEP 10",
        "done",
      ],
      subscribe => Service['tomcat'],
      refreshonly => true,
    }
    
  }
}
        
