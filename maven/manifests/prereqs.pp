class maven::prereqs($modinf) {
  if $modinf[ensure] != absent {
    # Install
    Class['java'] -> Class['maven::prereqs']
  } else {
    # Uninstall
    Class['java'] <- Class['maven::prereqs']
  }
}
