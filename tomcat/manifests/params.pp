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

class tomcat::params {
  include paths,ppext, java::params

  $module = 'tomcat'
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

  $javashare_path = $java::params::javashare_path

  # Link is created to support these in config_files
  $webapps_path = "$paths::var_lib/tomcat/webapps"
  $logpath = "$paths::var_log/tomcat"
  $sharepath = "$paths::usr_share/tomcat"

  $tomcat_manager_root_pwdfile = "${modinf[pwdpath]}/tomcat-manager.root.pwd"
  
  $ECHO = $paths::ECHO
  $CURL = $paths::CURL
  $SLEEP = $paths::SLEEP
  $GREP = $paths::GREP
}
