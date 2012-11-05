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
