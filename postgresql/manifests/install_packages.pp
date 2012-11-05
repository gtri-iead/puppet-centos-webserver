class postgresql::install_packages($modinf) {

  $ensure = $modinf[ensure]
  $version = $modinf[version]
  
  $SERVICE = $params::SERVICE
  
  ppext::package { 'postgresql':
    version => $version,
    packageName => $params::pkg_pg,
    ensure => $ensure,
  }
  
  ppext::package { 'postgresql-server':
    version => $version,
    packageName => $params::pkg_pg_server,
    ensure => $ensure,
  }   

  if $ensure != absent {
    Ppext::Package['postgresql'] -> Ppext::Package['postgresql-server']
    
  } else {  
    Ppext::Package['postgresql'] <- Ppext::Package['postgresql-server']
  }
}
