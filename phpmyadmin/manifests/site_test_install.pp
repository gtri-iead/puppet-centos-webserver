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

  include bash,ppext,ppdb

  $password = file("/etc/puppet/passwords/$hostname.pwd")
  
  class { 'apache' :
    version => '2.2*',
    ensure => latest,
  }

  class { 'php' :
    versions => {
      php => '5.3*',
      mcrypt => '5.3*',
      dba => '5.3*',
      mysql => '5.3*',
      pgsql => '5.3*',
      pear => '1.9*',
      pecl_apc => '3.1*',
      pecl_memcache => '3.0*',
    },
    ensure => latest,
  } 

  class { 'mysql' :
    
    version => '5.1*',
    ensure => latest,
    rootUserPassword => $password,
  }

  ppdb::connect_root { 'mysql' : ensure => installed }
  
  file { '/var/www/html/admin':
    ensure => directory
  }
  ->
  phpmyadmin { 'webserver' :
    version => '3.4.8',
    ensure => installed,
    destpath => '/var/www/html/admin/phpmyadmin',
    testURL => 'http://localhost/admin/phpmyadmin/',
  }

}
