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

define backup::restore_or_initialize_dbcontent_bashfile(
  $resinf,
  $init_dbcontent_sqlfile,
  $r_connect
) {

  include backup::params, ppext::params

  $modinf = $resinf[modinf]
  $module = $modinf[name]
  $binpath = $modinf[binpath]
  if !has_key($modinf, backuppath) { fail("modinf[${modinf[name]}] is missing backuppath") }
  $backuppath = $modinf[backuppath]

  $r_init = {
    name => "${module}::initialize_dbcontent",
    resname => "initialize_dbcontent",
    modinf => $modinf,
  }

  $r_restore = {
    name => "${module}::restore_dbcontent",
    resname => "restore_dbcontent",
    modinf => $modinf,
  }
 
  ppdb::initialize_dbcontent_bashfile { $r_init[name] :
    resinf => $r_init,
    r_connect => $r_connect,
    init_dbcontent_sqlfile => $init_dbcontent_sqlfile,
  }
  ->
  backup::restore_dbcontent_bashfile { $r_restore[name] :
    resinf => $r_restore,
    r_connect => $r_connect,
  }
  ->
  ppext::bashfile { $resinf[name]:
    resinf => $resinf,
    command => [
      "if [ -e $backuppath/dbcontent ]; then",
        "$binpath/restore_dbcontent",
      "else",
        "$binpath/initialize_dbcontent",
      "fi",
    ],
    echo => false,
  }
}
