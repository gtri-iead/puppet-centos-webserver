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

class php::install_packages($modinf) {

  $ensure = $modinf[ensure]
  $versions = $modinf[versions]
  $virtual = $ensure ? {
    absent => false, # If uninstalling no virtual packages so that everything can be uninstalled
    default => true,
  }
            
  ppext::package { 'php':
    packageName => $params::pkgs[php],
    version => $versions[php],    
    ensure => $ensure,
  }    

  # See require/before below
  ppext::package { 'php-common':
    packageName => $params::pkgs[common],
    version => $versions[php],
    ensure => $ensure,
  }

  # Modules below are not php::package since all php::package require php-common
  ppext::package { 'php-cli':
    packageName => $params::pkgs[cli],
    version => $versions[php],
    ensure => $ensure,
  }

  ppext::package { 'php-pdo':
    packageName => $params::pkgs[pdo],
    version => $versions[php],
    ensure => $ensure,
  }

  ppext::package { 'php-odbc':
    packageName => $params::pkgs[odbc],
    version => $versions[php],
    ensure => $ensure,
  }

  ppext::package { 'php-mysql':
    packageName => $params::pkgs[mysql],
    version => $versions[mysql],
    ensure => $ensure,
    virtual => $virtual,
  }

  ppext::package { 'php-pgsql':
    packageName => $params::pkgs[pgsql],
    version => $versions[pgsql],
    ensure => $ensure,
    virtual => $virtual,
  }

  ppext::package { 'php-pear':
    packageName => $params::pkgs[pear],
    version => $versions[pear],
    ensure => $ensure,
    virtual => $virtual,
  }
      
  php::package { [
    'bcmath',
    'devel',
    'embedded',
    'enchant',
    'gd',
    'imap',
    'intl',
    'ldap',
    'mbstring',
    'process',
    'pspell',
    'recode',
    'snmp',
    'soap',
    'tidy',
    'xml',
    'xmlrpc',
    'zts',
    'mcrypt',
    ]:
    versions => $versions,
    ensure => $ensure,
    virtual => false,
  }

  php::package { [
    'dba',
#    'mysql',
#    'pear',
    'pecl-apc',
    'pecl-memcache',
#    'pgsql'
    ]:
    versions => $versions,
    ensure => $ensure,
    virtual => $ensure ? {
      absent => false, # If uninstalling no virtual packages so that everything can be uninstalled
      default => true,
    }
  }


  if $ensure != absent {
    # Install
    Php::Package { require => Ppext::Package['php-common'] }
    Ppext::Package['php'] -> Ppext::Package['php-common'] -> Ppext::Package['php-cli']
    Ppext::Package['php-cli'] -> Ppext::Package['php-pear']
    Ppext::Package['php-cli'] -> Ppext::Package['php-pdo']
    Ppext::Package['php-pdo'] -> Ppext::Package['php-odbc']
    Ppext::Package['php-pdo'] -> Ppext::Package['php-mysql']
    Ppext::Package['php-pdo'] -> Ppext::Package['php-pgsql']
    
  } else {
    # Uninstall
    # Puppet bug below averted by putting Ppext::Package into an array
#    Php::Package { before => [ Ppext::Package['php-common'] ] }
    Php::Package { before => [ Ppext::Package['php'] ] }
    #RPM bug -- incorrect rpm dependencies between php-common, php-cli and php prevents normal uninstall order")
    # Ppext::Package['php'] <- Ppext::Package['php-common'] <- Ppext::Package['php-cli']
    Ppext::Package['php-common'] <- Ppext::Package['php-cli'] <- Ppext::Package['php']
    Ppext::Package['php-cli'] <- Ppext::Package['php-pear']
    Ppext::Package['php-cli'] <- Ppext::Package['php-pdo']
    Ppext::Package['php-pdo'] <- Ppext::Package['php-odbc']
    Ppext::Package['php-pdo'] <- Ppext::Package['php-mysql']
    Ppext::Package['php-pdo'] <- Ppext::Package['php-pgsql']
  
  }
  

}
