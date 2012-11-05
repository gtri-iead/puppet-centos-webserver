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

class apache::params {

  include paths,ppext::params

  $module = 'apache'
  $modinf = {
    name => $module,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }
        
  
  $svc_apache = 'httpd'
  
  # packages
  $pkg_apache = 'httpd'
  $pkg_mod_ssl = 'mod_ssl'
  
  # paths and files
  $etcpath = "$paths::etc/httpd"
  $conf_d_path = "$etcpath/conf.d"
  $directory_d_path = "$etcpath/conf.d"
  $vhost_d_path = "$etcpath/vhost.d"
  $conf_path = "$etcpath/conf"
  $tmppath = $paths::tmp
  $wwwpath = $paths::www
  $httpd_conffile = "$conf_path/httpd.conf"
  $ssl_conffile = "$conf_d_path/ssl.conf"
  $proxy_ajp_conffile = "$conf_d_path/proxy_ajp.conf"
  $logpath = "$paths::log/httpd"
  
  # script commands
  $CURL = $paths::CURL
  $ECHO = $paths::ECHO

}
