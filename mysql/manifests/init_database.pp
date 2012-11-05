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

class mysql::init_database($modinf, $rootUserPassword) {

  $MYSQL = $params::MYSQL
/*
  $initsqlfile = "${modinf[filespath]}/initialize.sql"
  
  file { $initsqlfile :
    content => template('mysql/initialize.sql.erb'),
    mode => 600,
  }
  ->*/

  $drop_remote_root_user_sql = $hostname ? {
    default => "DROP USER 'root'@'$hostname';",
    'localhost' => '', # Don't drop root@localhost !
  }
  
  $initsql = "USE mysql;${drop_remote_root_user_sql}UPDATE user SET password = password('$rootUserPassword') WHERE user='root';DELETE FROM user WHERE user = '';DROP DATABASE test;FLUSH PRIVILEGES;"

  ppext::execonce { 'mysql::init_database' :
    modinf => $modinf,
    input => $initsql,
    command => "$MYSQL -uroot",
    expected_outregex => template("mysql/initialize.expected.regex.erb"),
   }

  
  /* Password helper file in roots home directory
     Cant do this during config since the runsql above
     depends on root initially having no password */

  /* This works well, however mysql overrides all other settings (except command line)
     with the settings in a users home directory. This makes it impossible for root user
     to login as other users (without resorting to passing the password on the command line
  */
/*
  file { '/root/.my.cnf' :
    content => "[client]\npassword=$rootUserPassword\n",
    mode => 600,
    owner => root,
    require => Db::Runsql['mysql::init_database'],
  }
*/    
}
