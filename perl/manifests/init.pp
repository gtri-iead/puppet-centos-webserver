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

class perl(
  $ensure,
  $versions
  /* Hash:
    perl,
    mod_perl,
  */
) {
  include perl::params

  $module = 'perl'
  $modinf = {
    name => $module,
    ensure => $ensure,
    versions => $versions,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }
      
  if $ensure != absent  {

    ppext::module { $module : modinf => $modinf }
    ->
    class { 'perl::prereqs' : modinf => $modinf  }
    ->
    class { 'perl::install_packages' : modinf => $modinf }
    ->
    class { 'perl::test' : modinf => $modinf }
    
  } else {

    ppext::module { $module : modinf => $modinf }
#    <- Commented out since uninstall packages will fail - still want to remove other stuff
    class { 'perl::prereqs' : modinf => $modinf  }
#    <-
    class { 'perl::install_packages' : modinf => $modinf }
               
  }
}
  
