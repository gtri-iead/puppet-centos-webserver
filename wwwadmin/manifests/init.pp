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

define wwwadmin(
  $ensure,
  $versions,
  $destpath, # => '/var/www/html/admin',
  $basedir, # => 'admin',
  $apache_confpath, # => '/etc/httpd/conf.d',
  $destURL # => 'http://localhost/admin',
) {

  include wwwadmin::params, ppext::params, apache::params

  $module = "wwwadmin-$name"
  $modinf = {
    name => $module,
    ensure => $ensure,
    version => $version,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }

  $paths = {
    destpath => $destpath,
    basedir => $basedir,
    index_htmlfile => "$destpath/index.html",
    apache_conffile => "$apache_confpath/wwwadmin-$name.conf",
    phpinfo_phpfile => "$destpath/phpinfo.php",
  }
        
  if $ensure != absent {

    ppext::module { $module : modinf => $modinf }
    ->
    wwwadmin::prereqs { $name : modinf => $modinf }
    ->
    wwwadmin::config_files { $name:
      modinf => $modinf,
      paths => $paths,
    }
    
    if $versions[phpmyadmin] != absent {
      phpmyadmin { $name :
        version => $versions[phpmyadmin],
        ensure => $ensure,
        destpath => "$destpath/phpmyadmin",
        testURL => "$destURL/phpmyadmin/",
        require => Wwwadmin::Config_files[$name],
      }
    }
    
    if $versions[phppgadmin] != absent {
      phppgadmin { $name :
        version => $versions[phppgadmin],
        ensure => $ensure,
        destpath => "$destpath/phppgadmin",
        testURL => "$destURL/phppgadmin/",
       require => Wwwadmin::Config_files[$name],
      }
    }
    
  } else {

    ppext::module { $module : modinf => $modinf }
    <-
    wwwadmin::prereqs { $name : modinf => $modinf }
    <-
    wwwadmin::config_files { $name:
      modinf => $modinf,
      paths => $paths,
    }
    # <- same here
    phpmyadmin { $name :
      version => $versions[phpmyadmin],
      ensure => $ensure,
      destpath => "$destpath/phpmyadmin",
      testURL => "$destURL/phpmyadmin/",
    }
    # <- TODO: this causes a cyclical dependency
    phppgadmin { $name :
      version => $versions[phppgadmin],
      ensure => $ensure,
      destpath => "$destpath/phppgadmin",
      testURL => "$destURL/phppgadmin/"
    }
                                
  }
}
