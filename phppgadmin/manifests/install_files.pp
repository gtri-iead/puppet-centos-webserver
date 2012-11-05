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

define phppgadmin::install_files($modinf, $destpath, $unpackDir, $downloadURL) {

  $module = $modinf[name]
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

  file { $destpath :
    ensure => $dirEnsure,
    mode => 755,
  }

  $dfname = "${module}::download_files"
  ppext::download_files { $dfname :
    modinf => $modinf,
    downloadURL => $downloadURL,
    unpackDir => $unpackDir,
    destpath => $destpath,
    creates => "$destpath/index.php",
  }

  if $ensure != absent {
    File[$destpath] -> Ppext::Download_files[$dfname] 
  } else {
    File[$destpath] <- Ppext::Download_files[$dfname]
  }
}
