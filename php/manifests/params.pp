class php::params {
  include paths, ppext::params


  $module = 'php'
  $modinf = {
    name => $module,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }
  
  $php_d_path = "$paths::etc/php.d"
  
  $php_inifile = '/etc/php.ini'
  $PHP = "$paths::usr_bin/php"

  $pkgs = {
    php => 'php',
    bcmath => 'php-bcmath',
    cli => 'php-cli',
    common => 'php-common',
    devel => 'php-devel',
    embedded => 'php-embedded',
    enchant => 'php-enchant',
    gd => 'php-gd',
    imap => 'php-imap',
    intl => 'php-intl',
    ldap => 'php-ldap',
    mbstring => 'php-mbstring',
    odbc => 'php-odbc',
    pdo => 'php-pdo',
    process => 'php-process',
    pspell => 'php-pspell',
    recode => 'php-recode',
    snmp => 'php-snmp',
    soap => 'php-soap',
    tidy => 'php-tidy',
    xml => 'php-xml',
    xmlrpc => 'php-xmlrpc',
    zts => 'php-zts',
    mcrypt => 'php-mcrypt',
    dba => 'php-dba',
    mysql => 'php-mysql',
    pear => 'php-pear',
    pecl-apc => 'php-pecl-apc',
    pecl-memcache => 'php-pecl-memcache',
    pgsql => 'php-pgsql'
    
  }
}
