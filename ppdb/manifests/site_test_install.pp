node default {
  include bash, ppext, ppext::params

  $module = 'test_ppdb'
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
  ppext::module { $module : modinf => $modinf }

  $mysqlServerInf = {
    host => 'localhost',
    port => '3306',
  }

  $mysqlRootUserInf = {
    username => 'root',
    password => 'r503N8FWw502I3L',
  }

  $mysqlTestUserInf = {
    username => 'mysql_test_user',
    password => 'password',
  }

  $r_testMysqlRootConnect = {
    name => "${module}::testMysqlRootConnect",
    resname => 'testMysqlRootConnect',
    modinf => $modinf,

    type => 'mysql',
    serverinf => $mysqlServerInf,
    userinf => $mysqlRootUserInf,
#    database => 'mysql',
  }

  $r_testMysqlRootDump = {
    name => "${module}::dump_testMysqlRoot",
    resname => 'dump_testMysqlRoot',
    modinf => $modinf,

    type => 'mysql',
    serverinf => $mysqlServerInf,
    userinf => $mysqlRootUserInf,
#    database => 'mysql',
  }
 
  ppdb::connect { $r_testMysqlRootConnect[name] :
    resinf => $r_testMysqlRootConnect,
  }
  ->
  ppdb::dump { $r_testMysqlRootDump[name] :
    resinf => $r_testMysqlRootDump,
  }
  ->
  ppdb::dumpsql { "test_ppdb::test_mysql_dump" :
    modinf => $modinf,

    r_dump => $r_testMysqlRootDump,

    compress => false,
    outfile => "${modinf[filespath]}/test_mysql_dump.sql",
    database => 'mysql',
  }            
  ~>
  ppdb::runsql { "test_ppdb::test_mysql_runsql" :
    modinf => $modinf,
    
    r_connect => $r_testMysqlRootConnect,
    
    content => 'CREATE DATABASE test_mysql_runsql;',
    refreshonly => true,
  }
  ~>
  ppdb::database { "test_ppdb::test_mysql_db" :
    modinf => $modinf,
    
    r_connect => $r_testMysqlRootConnect,

    createUserWithDbName => true,
    newUserPassword => 'password',
    
    refreshonly => true,
  }

  # Postgres testing
  $pgServerInf = {
    host => 'localhost',
    port => '5432',
  }

  $pgRootUserInf = {
    username => 'root',
    password => 'r503N8FWw502I3L',
  }
  
  $pgTestUserInf = {
    username => 'test_postgresql_db',
    password => 'password',
  }
  
  $r_testPgRootConnect = {
    name => "${module}::connect_testPgRoot",
    resname => 'connect_testPgRoot',
    modinf => $modinf,

    type => 'postgresql',
    serverinf => $pgServerInf,
    userinf => $pgRootUserInf,
#    database => 'postgres',
  }

  $r_testPgRootDump = {
    name => "${module}::dump_testPgRoot",
    resname => 'dump_testPgRoot',
    modinf => $modinf,

    type => 'postgresql',
    serverinf => $pgServerInf,
    userinf => $pgRootUserInf,
#    database => 'postgres',
  }
              
  ppdb::connect { $r_testPgRootConnect[name] :
    resinf => $r_testPgRootConnect,
  }
  ->
  ppdb::dump { $r_testPgRootDump[name] :
    resinf => $r_testPgRootDump,
  }
  ->
  ppdb::dumpsql { "test_ppdb::test_postgresql_dump" :
    modinf => $modinf,

    r_dump => $r_testPgRootDump,

    outfile => "${modinf[filespath]}/test_postgresql_dump.sql.gz",
    compress => true,
    database => 'postgres',
  }
  ~>
  ppdb::database { "test_ppdb::test_postgresql_db" :
    modinf => $modinf,
    
    r_connect => $r_testPgRootConnect,

    createUserWithDbName => true,
    newUserPassword => 'password',
    
    refreshonly => true,
  }
/*
  ~>
  #TODO: this is inconsistent should be a full "resource" instead of "inf" to allow passing
  ppdb::user { "${module}::${pgTestUserInf[username]}":
    modinf => $modinf,
    
    userinf => $userinf,

    r_connect => $r_testPgRootConnect,

    refreshonly => true,
  }
*/
  
  $r_testPgTestUserConnect = {
    name => "${module}::connect_testPgTestUser",
    resname => 'connect_testPgTestUser',
    modinf => $modinf,

    type => 'postgresql',
    serverinf => $pgServerInf,
    userinf => $pgTestUserInf,
    database => 'test_postgresql_db',
  }

  ppdb::connect { $r_testPgTestUserConnect[name] :
    resinf => $r_testPgTestUserConnect,
  }
  ->
  ppdb::runsql { "test_ppdb::test_create_table" :
    modinf => $modinf,

    r_connect => $r_testPgTestUserConnect,
    
    content => "CREATE TABLE test2 (id INT, data VARCHAR(100) );",

    require => Ppdb::Database["test_ppdb::test_postgresql_db"],
  }
  ->
  ppdb::grant { "test_ppdb::test_grant_table" :
    modinf => $modinf,
    r_connect => $r_testPgRootConnect,

    privilege => 'ALL PRIVILEGES',
    grantTo => "${pgTestUserInf[username]}",
    target => 'test_postgresql_db.*',
    targetType => 'DATABASE',
    
    refreshonly => true,
  }
}
