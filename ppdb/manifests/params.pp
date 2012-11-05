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

class ppdb::params {
  include paths,ppext::params,mysql::params,postgresql::params
  
  $module = 'ppdb'
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

  $r_mysql_root_connect = {
    name => "mysql::connect_root",
    resname => 'connect_root',
    modinf => $mysql::params::modinf,

    type => 'mysql',
    serverinf => {
      host => 'localhost',
      # port
    },
    userinf => {
      username => 'root',
      # password
    },
    # database
  }

  $r_postgresql_root_connect = {
    name => "postgresql::connect_root",
    resname => 'connect_root',
    modinf => $postgresql::params::modinf,

    type => 'mysql',
    serverinf => {
      host => 'localhost',
      # port
    },
    userinf => {
      username => 'root',
      # password
    },
    # database                    
  }
         
  $MYSQL = $mysql::params::MYSQL
  $PSQL = $postgresql::params::PSQL
  $MYSQLDUMP = $mysql::params::MYSQLDUMP
  $PG_DUMP = $postgresql::params::PG_DUMP
  $CHMOD = $paths::CHMOD
  $ECHO = $paths::ECHO
  $GREP = $paths::GREP
  
}
