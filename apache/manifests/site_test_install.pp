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
  include bash,ppext,apache::params

  $ensure = installed
  
  class { 'apache' :
    version => '2.2*',
    ensure => $ensure,
#    r_defaultvhost => $r_defaultvhost,
    multiHost => true,
  }

  apache::proxypass { 'contesaNIEM' :
    ensure => $ensure,
#    r_vhost => $r_defaultvhost,
    proxySource => '/contesaNIEM',
    proxyDest => 'ajp://localhost:8009/contesaNIEM',
  }

  $r_vhost = {
    name => 'test',
    ensure => $ensure,
    port => '80',
    serverName => 'countzero',
    baseURL => 'http://countzero',
    adminEmail => 'admin@countzero',
    aliases => undef, #'127.0.0.1', # May be an undef, string or array. Other forms of server name ex: server.org, www.server.org, etc
    conffile => "$apache::params::vhost_d_path/countzero.conf", # Where to store the conf file
    confpath => "$apache::params::vhost_d_path/countzero.d", # Where to store conf files specific to this vhost
    logpath => "$apache::params::logpath/countzero", # Set to undef to use the main apache logs
    basepath => "$apache::params::wwwpath/countzero", # Base path for docroot and cgi-bin
    docroot => {
      ensure => $ensure,
      path => "$apache::params::wwwpath/countzero/html", # Where the html for this vhost is stored
      options => '+Indexes FollowSymLinks',
      allowOverride => 'none',
      order => 'allow,deny',
      allowFrom => 'all',
    },
    cgibinpath => undef, #"$apache::params::wwwpath/default/cgi-bin" # Set to undef to disable cgi-bin for this vhost
  }

  apache::vhost { 'test':
    modinf => $apache::params::modinf,
    r_vhost => $r_vhost,
  }
}
