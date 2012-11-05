class mysql::params {

  include ppext::params, paths
  
  $module = 'mysql'
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
  
  $etcfile = "$paths::etc/my.cnf"
  $mysqlpath = "${paths::var_lib}/mysql"

  $MYSQL = "$paths::usr_bin/mysql"
  $MYSQLDUMP = "$paths::usr_bin/mysqldump"

  $pkg_mysql = 'mysql'
  $pkg_mysql_server = 'mysql-server'

  $svc_mysql = 'mysqld'
}
