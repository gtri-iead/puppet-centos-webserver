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

define apache::ssl_vhost(
  $ensure,
  $port = 443,
  $adminEmail,
  $serverName,
  $aliases = 'unset', # May be an array. Other forms of server name ex: server.org, www.server.org, etc 
  $path = 'unset', # defaults to /var/www/$name
  $htmlpath = 'unset', # defaults to $path/html
  $cgibin = false, # Set to true to enable execution of scripts in cgi-bin directory
  $cgibinpath = 'unset', # defaults to $path/cgi-bin
  $logpath = 'unset', # defaults to /var/logs/$name
  $sslcertfile = undef,"/etc/pki/tls/certs/$name.key", # Set to the location of the ssl cert file
  $sslcertkeyfile = undef, "/etc/pki/tls/certs/private/$name.key",
  $sslcertchainfile = undef, "/etc/pki/tls/certs/server-chain.crt",
  
) {

  include apache::params

  # START PATTERN file_defaults
  $dirEnsure = $ensure ? { default => directory, absent => absent }
  $fileEnsure = $ensure ? { default => present, absent => absent }

  File {
    force => true,
    ensure => $fileEnsure,
    owner => root,
    group => root,
    mode => 644,
  }
  #END PATTERN

  $serverAliases = $aliases ? {
    default => inline_template('<% if aliases.respond_to?(\'each\') %><% aliases.each do |a| %><%= "\tServerAlias " %><%= a %><%= "\n" %><% end %><% else %><%= "\tServerAlias " %><%= aliases %><%= "\n" %><% end %>'),
    'unset' => '',
  }

  $_path = $path ? { default => $path, 'unset' => "$params::wwwpath/$name" }
  $_htmlpath = $htmlpath  ? { default => $htmlpath, 'unset' => "$_path/html" }
  $_cgibinpath = $cgibinpath ? { default => $cginbinpath, 'unset' => "$_path/cgi-bin" }
  $_logpath = $logpath ? { default => $logpath, 'unset' => "$params::logpath/$name" }

  $vhost_path = "$params::vhost_d_path/$name.d"
  $vhost_conffile = "$params::vhost_d_path/$name.conf"
  file { $vhost_conffile:
    content => template("apache/vhost.conf.erb"),
    
    # Must specify these here vice init.pp since this is a public resource type
    notify => Service['apache'],
    require => Class['apache::config_files'],
  }

  file { $vhost_path:
    ensure => directory,
    require => Class['apache::config_files'],
  }
  
  if !defined(File[$_path]) {
    file { $_path:
      ensure => directory,
      mode => 755,
    }
  }

  if !defined(File[$_htmlpath]) {
    file { $_htmlpath:
      ensure => directory,
      mode => 755,
      require => File[$_path],
    }
  }

  if !defined(File[$_cgibinpath]) {
    file { $_cgibinpath:
      ensure => directory,
      mode => 755,
      require => File[$_path],
    }
  }

  if !defined(File[$_logpath]) {
    file { $_logpath:
      ensure => directory,
      mode => 700,
      require => File[$_path],
    }
  }
                  
  
                  
}
