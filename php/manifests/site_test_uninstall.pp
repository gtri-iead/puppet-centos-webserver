node default {  
  include bash,ppext
  
  class { 'apache' :
    version => '2.2*',
    ensure => latest,
  }
  
  class { 'php' :
    versions => {
      php => '5.3.3*',
      dba => '5.3.3*',
      mysql => '5.3.3*',
      pgsql => '5.3.3*',
      pear => '1.9*',
      pecl-apc => '3.1*',
      pecl-memcache => '3.0*',
      mcrypt => '5.3.3*',
    },
    ensure => absent,
  }
 
}
      
