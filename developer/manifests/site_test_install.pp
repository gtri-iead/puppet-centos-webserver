node default {

  include bash,ppext
  
  class { 'apache' :
    version => '2.2*',
    ensure => installed,
  }

  class { 'php' :
   versions => {
     php => '5.3.3*',
     dba => '5.3.3*',
     mysql => 'absent',
     pgsql => 'absent',
     pear => '1.9.0*',
     pecl-apc => '3.1.3*',
     pecl-memcache => 'absent',
     mcrypt => '5.3.3*',
   },
   ensure => latest,      
  }
                      
  class { 'developer' : }
}
