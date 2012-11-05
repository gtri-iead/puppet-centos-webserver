class log4j::install_packages($modinf) {

  $version = $modinf[version]
  $ensure = $modinf[ensure]
  
  ppext::package { 'log4j' :
    packageName => $params::pkg_log4j,
    version => $version,
    ensure => $ensure,
  }
}
