class samba_devel::install_packages($modinf) {
  ppext::package { 'samba' :
    packageName => $params::pkg_samba,
    version => $modinf[version],
    ensure => $modinf[ensure],
  }
}
