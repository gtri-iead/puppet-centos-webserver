class java::install_packages($modinf, $packageName) {

  $version = $modinf[version]
  $ensure = $modinf[ensure]
  
  ppext::package { 'java': 
    packageName => $packageName,
    version => "$version*",
    ensure => $ensure,
  }
}
