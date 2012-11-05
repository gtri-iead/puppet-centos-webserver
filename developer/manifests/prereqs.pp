class developer::prereqs($ensure) {
  if $ensure != absent {
    # Install
    Class['php'] -> Class['developer::prereqs']

    # Thread an apache config file
    File[$params::xdebug_php_inifile] ~> Service['apache']
    Class['Apache::Config_files'] -> File[$params::xdebug_php_inifile]
    
  } else {
    # Uninstall
    Class['php'] <- Class['developer::prereqs']
  }
}
