define phpmyadmin::prereqs($modinf) {

  if $modinf[ensure] != absent {
    
    Class['ppdb'] -> Phpmyadmin::Prereqs[$name]

    # Thread for apache restart
    Class['apache::config_files'] -> Phpmyadmin::Prereqs[$name]
    # TODO: Shouldn't need to restart apache for no apparent reason; test fails otherwise with odd php error
    Phpmyadmin::Init_database[$name] ~> Service['apache']

    Class['php'] -> Phpmyadmin::Prereqs[$name]   
    Class['mysql'] -> Phpmyadmin::Prereqs[$name]
    realize Package['php-mysql']
    Package['php-mysql'] -> Phpmyadmin::Prereqs[$name]

    
    Service['apache'] -> Phpmyadmin::Test[$name]
    
  } else {
  
    Class['ppdb'] <- Phpmyadmin::Prereqs[$name]
#    Class['apache'] <- Phpmyadmin::Prereqs[$name]
    Service['apache'] <- Phpymadmin::Prereqs[$name]
    Class['php'] <- Phpmyadmin::Prereqs[$name]
#    Class['mysql'] <- Phpmyadmin::Prereqs[$name]
    Service['mysql'] <- Phpmyadmin::Prereqs[$name]
  
    realize Package['php-mysql'] # Not needed but shouldnt hurt
    Package['php-mysql'] <- Phpmyadmin::Prereqs[$name]
  }
}
