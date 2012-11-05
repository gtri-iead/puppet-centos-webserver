class perl::prereqs($modinf) {

  $ensure = $modinf[ensure]
  
  if $ensure != absent {
    # Install
    Class['apache'] -> Class['perl::prereqs']

    Package['mod_perl'] ~> Service['apache']
  } else {
    # Uninstall
    Class['perl'] -> Class['apache']  
  }
}
