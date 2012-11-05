define wwwadmin::prereqs($modinf) {

  if $modinf[ensure] != absent {

    # Thread apache config files to restart apache service
    Class['apache::config_files'] -> Wwwadmin::Prereqs[$name]
    Wwwadmin::Config_files[$name] ~> Service['apache']
    
  } else {
    #Class['apache'] <- Wwwadmin::Prereqs[$name] ~> Service['apache']
    Class['wwwadmin::uninstall'] ~> Class['apache::init_service']
  }
}
