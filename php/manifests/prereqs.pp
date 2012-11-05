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

class php::prereqs($modinf) {

  if $modinf[ensure] != absent {
    # Install - thread to apache::config files to prevent cyclical dependencies
    Class['apache::config_files'] -> Class['php::prereqs']

    # Restart apache after php stuff
    Class['php::install_packages'] ~> Service['apache']
    File[$params::php_inifile] ~> Service['apache']
    Package['php-mysql'] ~> Service['apache']
    Package['php-pear'] ~> Service['apache']
    Package['php-pecl-apc'] ~> Service['apache']
    Package['php-pecl-memcache'] ~> Service['apache']
    Package['php-pgsql'] ~> Service['apache']
  } else {
    # Uninstall
    Class['php'] -> Class['apache']
  }
                              
}
