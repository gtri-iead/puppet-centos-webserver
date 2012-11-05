node default {

  include bash,ppext,ppdb

  $password = file("/etc/puppet/passwords/$hostname.pwd")
  
  class { 'apache' :
    version => '2.2*',
    ensure => latest,
  }

  class { 'php' :
    versions => {
      php => '5.3*',
      mcrypt => '5.3*',
      dba => '5.3*',
      mysql => '5.3*',
      pgsql => '5.3*',
      pear => '1.9*',
      pecl_apc => '3.1*',
      pecl_memcache => '3.0*',
    },
    ensure => latest,
  } 

  class { 'mysql' :
    
    version => '5.1*',
    ensure => latest,
    rootUserPassword => $password,
  }

  ppdb::connect_root { 'mysql' : ensure => installed }
  
  file { '/var/www/html/admin':
    ensure => directory
  }
  ->
  phpmyadmin { 'webserver' :
    version => '3.4.8',
    ensure => installed,
    destpath => '/var/www/html/admin/phpmyadmin',
    testURL => 'http://localhost/admin/phpmyadmin/',
  }

}
