class firewall::install_packages($modinf) {
  $ensure = $modinf[ensure]
  $version = $modinf[version]
  
  ppext::package { 'firewall': 
    packageName => $params::pkg_firewall,
    version => $version,
    ensure => $ensure,
  }
}
