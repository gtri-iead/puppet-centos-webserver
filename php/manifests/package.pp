define php::package($versions, $ensure, $virtual) {

  if has_key($versions, $name) {
    $version = $versions[$name]
  } else {
    $version = $versions[php]
  }
  
  ppext::package { "php-$name":
    packageName => $params::pkgs[$name],
    version => $version,
    ensure => $ensure,
    virtual => $virtual,
  }
}
