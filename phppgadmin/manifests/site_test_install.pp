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

node default {
  include bash, ppdb, ppext

  $password = file("/etc/puppet/passwords/$hostname.pwd")
  
  class { 'lampstack' :
    password => $password,
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
        pecl_apc => '3.1*',
        pecl_memcache => '3.0*',
      },
      perl => {
        perl => '5.10*',
        mod_perl => '*',
      },
    },
    ensure => latest,
  }                                          
  
  class { 'postgresql' :
    ensure => latest,
    version => '8.4*',
    rootUserPassword => $password,
  }

  ppdb::connect_root { 'postgresql': ensure => installed }

  file { '/var/www/html/admin':
    ensure => directory,
  }
  ->
  phppgadmin { 'webserver' :
    version => '5.0.3',
    ensure => installed,
    destpath => '/var/www/html/admin/phppgadmin',
    testURL => 'http://localhost/admin/phppgadmin/',
  }
  
}
