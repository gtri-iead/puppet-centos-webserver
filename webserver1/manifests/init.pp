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

class webserver1(
  $ensure,
  $password,
  $r_defaultvhost = undef,
  $multiHost = false
) {

  class { bash:
    ensure => $ensure
  }
  
  class { ppdb:
    ensure => $ensure
  }
  
  class { ppext:
    ensure => $ensure
  }

  class { backup :
    monthlyBackupCount => 1,
    weeklyBackupCount => 2,
    dailyBackupCount => 3,
    ensure => $ensure,
  }
    
  class { basics :
    ensure => $ensure,
  }
  
  class { firewall :
    version => '*',
    ensure => $ensure,
  }
  
  class { jptstack :
    versions => {
      java => '1.6.0',
      postgresql => '8.4*',
      log4j => '*',
      tomcat => '6.0*'
    },
    ensure => $ensure,
    password => $password,
  }
  
  class { lampstack :
    versions => {
      apache => '2.2.15*',
      mysql => '5.1*',
      php => {
        php => '5.3.3*',
        mcrypt => '5.3.3*',
        #The following modules are virtual resources that can be "realized" later.
        # If they are never realized they are never installed.
        dba => '5.3.3*',
        mysql => '5.3.3*',
        pgsql => '5.3.3*',
        pear => '1.9*',
        pecl-apc => '3.1*',
        pecl-memcache => '3.0*',
      },
      perl => {
        perl => '5.10*',
        mod_perl => '*',
      },
    },
    ensure => $ensure,
    password => $password,
    r_defaultvhost =>  $r_defaultvhost,
    multiHost => $multiHost,
  }
  
  wwwadmin { 'webserver':
    versions => {
      phpmyadmin => '3.4.9',
      phppgadmin => '5.0.3',
    },
    # Install to /var/www/html/admin regardless of multihost status
    # wwwadmin ensures the admin directory is only accessible by ssh tunnel to localhost
    destpath => '/var/www/html/admin',
    basedir => 'admin',
    apache_confpath => '/etc/httpd/vhost.d/default.d',
    destURL => 'http://localhost/admin',
    ensure => $ensure,
  }

}
