class php::prereqs($modinf) {

  if $modinf[ensure] != absent {
    # Install - thread to apache::config files to prevent cyclical dependencies
    Class['apache::config_files'] -> Class['php::prereqs']

    # Restart apache after php stuff
    Class['php::install_packages'] ~> Service['apache']
    File[$params::php_inifile] ~> Service['apache']
    Package['php-mysql'] ~> Service['apache']
    Package['php-pear'] ~> Service['apache']
    Package['php-pecl-apc'] ~> Service['apache']
    Package['php-pecl-memcache'] ~> Service['apache']
    Package['php-pgsql'] ~> Service['apache']
  } else {
    # Uninstall
    Class['php'] -> Class['apache']
  }
                              
}
