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

define backup::restore_dbcontent_bashfile(
  $resinf,
  $r_connect
) {
  include backup::params, ppext::params

  $modinf = $resinf[modinf]
  $module = $modinf[name]
  $binpath = $modinf[binpath]
  if !has_key($modinf, backuppath) { fail("modinf[${modinf[name]}] is missing backuppath") }
  $backuppath = $modinf[backuppath]

  $connectfile = "${r_connect[modinf][binpath]}/${r_connect[resname]}"

  $ECHO = $params::ECHO
  $GZIP = $params::GZIP
  
  ppext::bashfile { $resinf[name]:
    resinf => $resinf,
    command => [
      "$ECHO 'Restoring $backuppath/dbcontent/$dbName.sql.gz to database $dbName'",
      "$GZIP -c -d $backuppath/dbcontent/$dbName.sql.gz | $connectfile --echo=0",
    ],
    echo => false,
  }
}
