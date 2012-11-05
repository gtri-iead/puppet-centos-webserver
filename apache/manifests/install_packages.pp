class apache::install_packages($modinf) {

  $version = $modinf[version]
  $ensure = $modinf[ensure]
  
  ppext::package { 'apache':
    packageName => $params::pkg_apache,
    version => $version,
    ensure => $ensure,
  }

  ppext::package { 'mod_ssl':
    packageName => $params::pkg_mod_ssl,
    version => $version,
    ensure => $ensure,
  }
                      
  if $ensure != absent {
    Ppext::Package['apache'] -> Ppext::Package['mod_ssl']
  } else {
    Ppext::Package['mod_ssl'] -> Ppext::Package['apache']
  }
}
