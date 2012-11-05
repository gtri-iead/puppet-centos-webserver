class imagemagick::install_packages($modinf) {

  $version = $modinf[version]
  $ensure = $modinf[ensure]
  
  ppext::package { 'imagemagick' :
    packageName => $params::pkg_imagemagick,
    version => $version,
    ensure => $ensure,
  }
}
