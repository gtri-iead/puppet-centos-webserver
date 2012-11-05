class perl::install_packages($modinf) {

  $version = $modinf[versions]
  $ensure = $modinf[ensure]
  
  ppext::package { 'perl' :
    packageName => $params::pkg_perl,
    version => $versions[perl],
    ensure => $ensure,
  }
  
  ppext::package { 'mod_perl' :
    packageName => $params::pkg_mod_perl,
    version => $versions[mod_perl],
    ensure => $ensure,
    virtual => $ensure ? { default => true, absent => false } # Virtual resource normally, always present for uninstall
  }

  if $ensure != absent {
    # Install
    Ppext::Package['perl'] -> Ppext::Package['mod_perl']
  } else {
    # Uninstall
    Ppext::Package['perl'] <- Ppext::Package['mod_perl']
  }
}
