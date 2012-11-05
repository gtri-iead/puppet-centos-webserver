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

define phpmyadmin::init_database($modinf) {
 
  $module = $modinf[name]

  $r_connect = $ppdb::params::r_mysql_root_connect


  ppext::notifyonce { "${module}::init_pma" : modinf => $modinf }
  ~>
  ppdb::runsql { "${module}::create_pma_user" :
    modinf => $modinf,
   
    r_connect => $r_connect,
    source => "puppet:///modules/phpmyadmin/create_pma_user.sql",

    refreshonly => true,
  }
  ~>
  ppdb::runsql { "${module}::create_pma_db" :
    modinf => $modinf,
    
    r_connect => $r_connect,
    source => "puppet:///modules/phpmyadmin/create_tables.sql",
   
    refreshonly => true,
  }  
 
}
