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

define ppdb::initialize_database_bashfile(
  $resinf,

  $r_connect,

  $newDbName,

  $userinf
) {

  include ppext::params

  $modinf = $resinf[modinf]
  $module = $modinf[name]

  $filespath = $modinf[filespath]

  $create_dbsqlfile = "$filespath/CREATE_DATABASE_${newDbName}.sql"

  $type = $r_connect[type]

  $CREATE_DATABASE_sql = template("ppdb/$type/CREATE_DATABASE.sql.erb")

  $newUserName = has_key($userinf, username) ? { true => $userinf[username], false => $newDbName }
  $newUserPassword = $userinf[password]
  $newUserHost = has_key($r_connect[serverinf], host) ? { true => $r_connect[serverinf][host], false => 'localhost' }

  $CREATE_USER_sql = template("ppdb/$type/CREATE_USER.sql.erb")
  
  $privilege = 'ALL PRIVILEGES'
  $target = $newDbName
  $targetType = 'DATABASE'
  $grantTo = $newUserName
  $GRANT_sql = template("ppdb/$type/GRANT.sql.erb")

  $connectfile = "${r_connect[modinf][binpath]}/${r_connect[resname]}"

  file { $create_dbsqlfile:
    content => "${CREATE_DATABASE_sql}\n${CREATE_USER_sql}\n${GRANT_sql}\n",
    owner => root,
    group => root,
    mode => 600,
  }
  ->
  ppext::bashfile { $resinf[name] :
    resinf => $resinf,
    command => [
      "$connectfile --echo=0 < $create_dbsqlfile",
    ],
  }
}
