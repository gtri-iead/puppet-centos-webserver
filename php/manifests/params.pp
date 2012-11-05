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

class php::params {
  include paths, ppext::params


  $module = 'php'
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
  
  $php_d_path = "$paths::etc/php.d"
  
  $php_inifile = '/etc/php.ini'
  $PHP = "$paths::usr_bin/php"

  $pkgs = {
    php => 'php',
    bcmath => 'php-bcmath',
    cli => 'php-cli',
    common => 'php-common',
    devel => 'php-devel',
    embedded => 'php-embedded',
    enchant => 'php-enchant',
    gd => 'php-gd',
    imap => 'php-imap',
    intl => 'php-intl',
    ldap => 'php-ldap',
    mbstring => 'php-mbstring',
    odbc => 'php-odbc',
    pdo => 'php-pdo',
    process => 'php-process',
    pspell => 'php-pspell',
    recode => 'php-recode',
    snmp => 'php-snmp',
    soap => 'php-soap',
    tidy => 'php-tidy',
    xml => 'php-xml',
    xmlrpc => 'php-xmlrpc',
    zts => 'php-zts',
    mcrypt => 'php-mcrypt',
    dba => 'php-dba',
    mysql => 'php-mysql',
    pear => 'php-pear',
    pecl-apc => 'php-pecl-apc',
    pecl-memcache => 'php-pecl-memcache',
    pgsql => 'php-pgsql'
    
  }
}
