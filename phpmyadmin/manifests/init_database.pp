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
