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

define ppext::module(
  $modinf
) {

  include ppext::params

  $module = $modinf[name]
  if $module != $modinf[name] { err("modinf($modinf) does not match name($name)")fail() }
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
 
  # Ensure ppext defined
  if !defined(File[$params::etcpath]) {
    fail("File[$params::etcpath] is not defined, ensure Class[ppext] is defined")
  }

  # Ennsure module's log path exists  
  if $modinf[logpath] != $params::logpath and !defined(File[$modinf[logpath]]) {
    file { $modinf[logpath]:
      ensure => $dirEnsure,
      mode => 755,
      require => File[$params::logpath],
    }
  }

  # Create the module's log
  file { $modinf[logfile]:
    ensure => $fileEnsure,
    mode => 600,
    require => File[$modinf[logpath]],
  }
      
  # Ensure module's password path exists
  if $modinf[pwdpath] != $params::pwdpath and !defined(File[$modinf[pwdpath]]) {
    file { $modinf[pwdpath]:
      ensure => $dirEnsure,
#      mode => 755,
      mode => 700, # Passwords dir only readable by root
      require => File[$params::etcpath],
    }
  }

  # Ensure module's bin path exists
  if $modinf[binpath] != $params::binpath and !defined(File[$modinf[binpath]]) {
    file { $modinf[binpath]:
      ensure => $dirEnsure,
      mode => 755,
      require => File[$params::binpath],
    }
  }

  # Ensure module's out path exists
  if $modinf[outpath] != $params::outpath and !defined(File[$modinf[outpath]]) {
    file { $modinf[outpath]:
      ensure => $dirEnsure,
      mode => 755,
      require => File[$params::outpath],
    }
  }

  # Ensure module's flag path exists
  if $modinf[flagpath] != $params::flagpath and !defined(File[$modinf[flagpath]]) {
    file { $modinf[flagpath]:
      ensure => $dirEnsure,
      mode => 755,
      require => File[$params::flagpath],
    }
  }

  # Ensure module's file path exists
  if $modinf[filespath] != $params::filespath and !defined(File[$modinf[filespath]]) {
    file { $modinf[filespath]:
      ensure => $dirEnsure,
      mode => 755,
      require => File[$params::filespath],
    }
  }
  
}
