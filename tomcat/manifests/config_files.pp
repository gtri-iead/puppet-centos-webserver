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

class tomcat::config_files($modinf, $paths, $rootUserPassword) {

  $ensure = $modinf[ensure]

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
  $linkEnsure = $ensure ? { default => link, absent => absent }      


  file { $paths[liblink]:
    ensure => $linkEnsure,
    target => $paths[libpath],
  }

  file { $paths[loglink]:
    ensure => $linkEnsure,
    target => $paths[logpath],
  }

  file { $paths[sharelink]:
    ensure => $linkEnsure,
    target => $paths[sharepath],
  }
   
  file { $paths[tomcat_users_xmlfile]:
    content => template("tomcat/tomcat-users.xml.erb"),
  }

  file { $paths[tomcat_manager_root_pwdfile]:
    content => $rootUserPassword,
    mode => 600,
  }
  
}
