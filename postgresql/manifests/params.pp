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

class postgresql::params {
  include paths, ppext::params

  $module = 'postgresql'
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
        
  $pgpath = "$paths::var_lib/pgsql"
  $pg_hbafile = "$pgpath/data/pg_hba.conf"

#  $initsqlfile = "${modinf[filespath]}/initialize.sql"
 
  $rootpgpassfile = '/root/.pgpass'

  $SERVICE = $paths::SERVICE
  $SLEEP = $paths::SLEEP
  $PSQL = "$paths::usr_bin/psql"
  $PG_DUMP = "$paths::usr_bin/pg_dump"

  $pkg_pg = 'postgresql'
  $pkg_pg_server = 'postgresql-server'

  $svc_pg = 'postgresql'
}
