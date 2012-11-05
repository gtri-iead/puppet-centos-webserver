define phpmyadmin::uninstall($modinf, $destpath) {

  include ppext::params
  
  $module = $modinf[name]

  ppdb::runsql { "uninstall::drop_pma_db" :
    modinf => $ppext::params::uninstall_modinf,

    r_connect => $ppdb::params::r_mysql_root_connect,
    content => "DROP DATABASE phpmyadmin;DROP USER 'pma'@'localhost'",
  }
  ->
  file { $destpath:
    ensure => absent,
    recurse => true,
    force => true,
  }
                        
}
