node default {

  include bash, ppext

  class { apache :
    version => '2.2*',
    ensure => latest,
  }

  class { php :
    versions => {
      php => '5.3*',
      mcrypt => '5.3*',
      dba => '5.3*',
      mmysql=> '5.3*',
      pgsql => '5.3*',
      pear => '1.9*',
      pecl_apc => '3.1*',
      pecl_memcache => '3.0*',
    },
    ensure => latest,
  }
                  }                
  class { developer: ensure => absent }
}
