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

define ppdb::dumpsql(
  $modinf,
  
  $r_dump,

  $database = undef,
  $outfile,
  $options = undef,
  $compress = false,
  
  $owner = undef,
  $group = undef,
  $mode = 600,

  $refeshonly = false
  ) {

  include ppext::params
    
  if $options {
    $c_options = " --options=$options"  
  } else {
    $c_options = ''
  }

  if $database {
    $c_database = " --database=$database"
  } else {
    $c_database = ''
  }
  
  if $compress {
    $c_compress = " | gzip > $outfile"
  } else {
    $c_compress = " > $outfile"
  }
  
  # TODO: this probably shouldn't be in here, let caller be responsible for defining the file
  file { $outfile :
    ensure => present,
    owner => $owner,
    group => $group,
    mode => $mode,
  }
  ->      
  ppext::exec { $name :
    modinf => $modinf,
    command => "${r_dump[modinf][binpath]}/${r_dump[resname]}${c_options}${c_database}${c_compress}",
    refreshonly => $refreshonly,
  }
}
