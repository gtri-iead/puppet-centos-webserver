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

define ppdb::connect_root(
  $type = $name,
  $ensure
) {

  # TODO: ppdb needs to be ensure aware, this should uninstall the connect_root bashfile but doesn't
  if $ensure != absent {
    case $type {
      'mysql': {
        $r_mysql_connect = $ppdb::params::r_mysql_root_connect
        ppdb::connect { $r_mysql_connect[name] :
          resinf => $r_mysql_connect
        }
      }
      'postgresql': {
        $r_pg_connect = $ppdb::params::r_postgresql_root_connect
        ppdb::connect { $r_pg_connect[name] :
          resinf => $r_pg_connect
        }
      }
      default: { fail("Unsupported database type: $type") }
    }
  }
}
