define mediawiki::prereqs($modinf, $dbType, $siteName, $paths) {

  $apache_shortURL_conffile = $paths[apache_shortURL_conffile]

  if $modinf[ensure] != absent {
    
    Class['backup'] -> Mediawiki::Prereqs[$name]
    Class['ppdb'] -> Mediawiki::Prereqs[$name]
    Class['apache'] -> Mediawiki::Prereqs[$name]
    Class['php'] -> Mediawiki::Prereqs[$name]
    Class['imagemagick'] -> Mediawiki::Prereqs[$name]
  
  
    case $dbType {
      'mysql' : {
        Package['mysql'] -> Mediawiki::Prereqs[$name]
        realize Package['php-mysql']
        Package['php-mysql'] -> Mediawiki::Prereqs[$name]
      }
      'postgresql' : {
        Package['postgresql'] -> Mediawiki::Prereqs[$name]
        realize Package['php-pgsql']
        Package['php-pgsql'] -> Mediawiki::Prereqs[$name]
      }
    }
  
    realize Package['php-pear'] 
    Package['php-pear'] -> Mediawiki::Prereqs[$name]
    realize Package['php-pecl-apc']
    Package['php-pecl-apc'] -> Mediawiki::Prereqs[$name]

#    File[$apache_shortURL_conffile] ~> Service['apache']

    Service['apache'] -> Mediawiki::Test[$name]
    
  } else {

    Class['backup'] <- Mediawiki::Prereqs[$name]
    Class['ppdb'] <- Mediawiki::Prereqs[$name]
    Class['apache'] <- Mediawiki::Prereqs[$name]
    Class['php'] <- Mediawiki::Prereqs[$name]
    Class['imagemagick'] <- Mediawiki::Prereqs[$name]


    case $dbType {
      'mysql' : {
        Package['mysql'] <- Mediawiki::Prereqs[$name]
        realize Package['php-mysql']
        Package['php-mysql'] <- Mediawiki::Prereqs[$name]
      }
      'postgresql' : {
         Package['postgresql'] <- Mediawiki::Prereqs[$name]
         realize Package['php-pgsql']
         Package['php-pgsql'] <- Mediawiki::Prereqs[$name]
      }
    }

    realize Package['php-pear']
    Package['php-pear'] <- Mediawiki::Prereqs[$name]
    realize Package['php-pecl-apc']
    Package['php-pecl-apc'] <- Mediawiki::Prereqs[$name]

    Mediawiki::Prereqs[$name] ~> Service['apache']
  }
}
