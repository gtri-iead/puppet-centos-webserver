define wordpress::prereqs($modinf, $paths) {

  if $modinf[ensure] != absent {
    
    Class['backup'] -> Wordpress::Prereqs[$name]
    Class['ppdb'] -> Wordpress::Prereqs[$name]
    Class['apache'] -> Wordpress::Prereqs[$name]
    Class['php'] -> Wordpress::Prereqs[$name]
  
  
    Package['mysql'] -> Wordpress::Prereqs[$name]
    realize Package['php-mysql']
    Package['php-mysql'] -> Wordpress::Prereqs[$name]
 
  } else {

    Class['backup'] <- Wordpress::Prereqs[$name]
    Class['ppdb'] <- Wordpress::Prereqs[$name]
    Class['apache'] <- Wordpress::Prereqs[$name]
    Class['php'] <- Wordpress::Prereqs[$name]
    Class['imagemagick'] <- Wordpress::Prereqs[$name]


    Package['mysql'] <- Wordpress::Prereqs[$name]
    realize Package['php-mysql']
    Package['php-mysql'] <- Wordpress::Prereqs[$name]
  }
}
