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

class postgresql::config_files($modinf, $paths, $rootUserPassword) {

  $ensure = $modinf[ensure]
  $version = $modinf[version]
  
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
        
  file { $paths[rootpwdfile]:
    content => "*:*:*:root:$rootUserPassword\n",
    mode => 600,
  }

  # This file has to be installed *after* initdb executes, otherwise initdb will fail
  file { $params::pg_hbafile:
    owner => 'postgres',
    group => 'postgres',
    source => "puppet:///modules/postgresql/pg_hba.conf",
  }

  file { $params::rootpgpassfile :
    content => "*:*:*:root:$rootUserPassword\n",
    mode => 600,
  }
/*
  file { $params::initsqlfile:
    content => "CREATE USER root WITH CREATEUSER CREATEDB ENCRYPTED PASSWORD '$rootUserPassword';\n",
    owner => postgres, # postgres user must be able to read the file 
    mode => 460,
  }
*/      
}
