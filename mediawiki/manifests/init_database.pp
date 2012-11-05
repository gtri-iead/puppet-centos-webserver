define mediawiki::init_database($modinf, $paths, $r_privconnect, $r_connect, $dbinf) { 

  $module = $modinf[name]
  
  file { $paths[init_dbcontent_sqlfile]:
    source => "puppet:///modules/mediawiki/$version/init_tables.sql",
    owner => root,
    group => root,
    mode => 600,
  }
  ->
  ppdb::connect { $r_privconnect[name]:
    resinf => $r_privconnect,
  }
  ->
  ppdb::connect { $r_connect[name]:
    resinf => $r_connect,
  }
  ->
  ppext::notifyonce { "${module}::initialize" : modinf => $modinf, }
  ~>
  ppdb::initialize_database { "${module}::initialize_database" :
    modinf => $modinf,
    
    r_connect => $r_privconnect,

    
    newDbName => $dbinf[database],

    userinf => $dbinf[user],
    
    refreshonly => true,
  }
  ~>
  backup::restore_or_initialize_dbcontent { "${module}::restore_or_initialize_dbcontent":
    modinf => $modinf,

    r_connect => $r_connect,
    
    init_dbcontent_sqlfile => $paths[init_dbcontent_sqlfile],
    
    refreshonly => true,
  }
    
}
                                            
