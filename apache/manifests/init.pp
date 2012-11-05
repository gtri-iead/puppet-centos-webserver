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

class apache(
  $version,
  $ensure,
  $r_defaultvhost = undef,
/*
  name => 'NAME',
  ensure => installed,
  port => '80',
  baseURL => 'http://SERVERNAME',
  serverName => 'www.example.org',
  adminEmail => 'admin@example.org',
  aliases => undef, # May be an undef, string or array. Other forms of server name ex: server.org, www.server.org, etc
  conffile => "$apache::params::vhost_d_path/NAME.conf", # Where to store the conf file
  confpath => "$apache::params::vhost_d_path/NAME.d", # Where to store conf files specific to this vhost
  logpath => "$apache::params::logpath/NAME", # Set to undef to use the main apache logs
  basepath => "$apache::params::wwwpath/NAME", # Base path for docroot and cgi-bin
  docroot => {
    ensure => installed
    path => "$apache::params::wwwpath/NAME/html", # Where the html for this vhost is stored
    options => '-Indexes FollowSymLinks',
    allowOverride => 'none',
    order => 'allow,deny',
    allowFrom => 'all',
  },
  cgibinpath => "$apache::params::wwwpath/NAME/cgi-bin" # Set to undef to disable cgi-bin for this vhost
*/
  $multiHost = false
) {

  include apache::params

  # PATTERN BEGIN init_modinf_from_params
  $module = $params::module
  $modinf = {
    name => $module,
    ensure => $ensure,
    version => $version,
    versions => $versions,
    logpath => $params::modinf[logpath],
    logfile => $params::modinf[logfile],
    pwdpath => $params::modinf[pwdpath],
    binpath => $params::modinf[binpath],
    outpath => $params::modinf[outpath],
    flagpath => $params::modinf[flagpath],
    filespath => $params::modinf[filespath],
  }
  #END PATTERN
  if $r_defaultvhost {
    $r_vhost = $r_defaultvhost
  } else {
    # If multi-host, use default vhost as a private admin area
    $hname = $multiHost ? { true => 'localhost', false => $hostname }
    $r_vhost = {
      name => 'default',
      ensure => $ensure,
      port => '80',
      serverName => $hname,
      baseURL => "http://$hname",
      adminEmail => "root@$hname",
      aliases => undef, # May be an undef, string or array. Other forms of server name ex: server.org, www.server.org, etc
      conffile => "$apache::params::vhost_d_path/default.conf", # Where to store the conf file
      confpath => "$apache::params::vhost_d_path/default.d", # Where to store conf files specific to this vhost
      logpath => undef, # Set to undef to use the main apache logs
      basepath => "$apache::params::wwwpath", # Base path for docroot and cgi-bin
      docroot => {
        ensure => $ensure,
        path => "$apache::params::wwwpath/html", # Where the html for this vhost is stored
        options => '+Indexes FollowSymLinks',
        allowOverride => 'none',
        order => 'allow,deny',
        # If multi-host use default vhost as a private admin area (only accessible by ssh tunnel)
        allowFrom => $multiHost ? { true => '127.0.0.1, localhost', false => 'all' }
      },
      cgibinpath => "$apache::params::wwwpath/cgi-bin" # Set to undef to disable cgi-bin for this vhost
    }
                  
  }
  
  if $ensure != absent {
    
    ppext::module { $module : modinf => $modinf }
    ->
    class { 'apache::install_packages' : modinf => $modinf }
    ->
    class { 'apache::config_files' : modinf => $modinf }
    ->
    class { 'apache::init_service' : modinf => $modinf }

    # Since this is public accessible resource, it threads correctly
    # Also it creates the test for the defaultvhost
    apache::vhost { $r_vhost[name] : modinf => $modinf, r_vhost => $r_vhost, }

    # Trigger on changes to the file
    File[$params::httpd_conffile] ~> Service['apache']
    
  } else {

    ppext::module { $module : modinf => $modinf }
    # <- Commented out since if package uninstall fails we still need to remove other things (and dependencies aren't important)
    # Remove packages
    class { 'apache::install_packages' : modinf => $modinf }
    <-
    # Stop service
    class { 'apache::init_service' : modinf => $modinf }
    <-
    # Remove config files
    class { 'apache::config_files' : modinf => $modinf }

    # Threads itself
    apache::vhost { $r_vhost[name]: modinf => $modinf, r_vhost => $r_vhost, } 
  
  }
}
