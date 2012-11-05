define phppgadmin::prereqs($modinf) {

  if $modinf[ensure] != absent {
    
    Class['ppdb'] -> Phppgadmin::Prereqs[$name]
    Class['apache'] -> Phppgadmin::Prereqs[$name]
    Class['php'] -> Phppgadmin::Prereqs[$name]
    Class['postgresql'] -> Phppgadmin::Prereqs[$name]
    realize Package['php-pgsql']
    Package['php-pgsql'] -> Phppgadmin::Prereqs[$name]

    Service['apache'] -> Phppgadmin::Test[$name]
    
  } else {
    Class['ppdb'] <- Phppgadmin::Prereqs[$name]
#    Class['apache'] <- Phppgadmin::Prereqs[$name]
    Service['apache'] <- Phppgadmin::Prereqs[$name]
    Class['php'] <- Phppgadmin::Prereqs[$name]
#    Class['postgresql'] <- Phppgadmin::Prereqs[$name]
    Service['postgresql'] <- Phppgadmin::Prereqs[$name]
    realize Package['php-pgsql']
    Package['php-pgsql'] <- Phppgadmin::Prereqs[$name]
  }
}
