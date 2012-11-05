class tomcat::install_packages($modinf, $packageName) {

  $ensure = $modinf[ensure]
  $version = $modinf[version]
  
  ppext::package { 'tomcat' :
    packageName => $packageName,
    version => $version,
    ensure => $ensure,
  }
  
  ppext::package { 'tomcat-webapps' :
    packageName => "${packageName}-webapps",
    version => $version,
    ensure => $ensure,
  }
  
  ppext::package { 'tomcat-admin-webapps' :
    packageName => "${packageName}-admin-webapps",
    version => $version,
    ensure => $ensure,
  }

  if $ensure != absent {
    Ppext::Package['tomcat'] -> Ppext::Package['tomcat-webapps'] -> Ppext::Package['tomcat-admin-webapps']
  } else {
    Ppext::Package['tomcat'] <- Ppext::Package['tomcat-webapps'] <- Ppext::Package['tomcat-admin-webapps']
  }
}
