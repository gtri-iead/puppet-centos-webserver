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

define wordpress::install_files($modinf,$paths, $downloadURL, $unpackDir) {

  $version = $modinf[version]
  $module = $modinf[name]

  File { owner => root, group => root, mode => 644 }

  file { $paths[destpath]:
    ensure => directory,
    mode => 755,
  }
  ->
  backup::restore_or_download_files { "${module}::restore_or_download_files":
    modinf => $modinf,

    downloadURL => $downloadURL ,
    unpackDir => $unpackDir,
    destpath => $paths[destpath],

    creates => $paths[install_flag_path],
  }
  
}
