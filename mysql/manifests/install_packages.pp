class mysql::install_packages($modinf) {

  $ensure = $modinf[ensure]
  $version = $modinf[version]
  
  ppext::package { 'mysql' :
    packageName => $params::pkg_mysql,
    version => $version,
    ensure => $ensure,
  }
  
  ppext::package { 'mysql-server' :
    packageName => $params::pkg_mysql_server,
    version => $version,
    ensure => $ensure,
  }

  if $ensure != absent {
    Ppext::Package['mysql'] -> Ppext::Package['mysql-server']
  } else {
    Ppext::Package['mysql'] <- Ppext::Package['mysql-server']
  }
}
