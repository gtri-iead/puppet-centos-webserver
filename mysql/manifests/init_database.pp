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
