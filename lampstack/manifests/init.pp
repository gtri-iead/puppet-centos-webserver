/* Linux-Apache-Mysql-PHP  stack (also perl) */
class lampstack(
  $password,
  $versions,
  /*
    apache
    mysql
    php
      php
      mcrypt
      dba
      mysql
      pgsql
      pear
      pecl_apc
      pecl_memcache
  */
  $ensure,
  $r_defaultvhost = undef,
  $multiHost = false
  ) {
  
  class { 'apache' :
    version => $versions[apache],
    ensure => $ensure,
    r_defaultvhost => $r_defaultvhost,
    multiHost => $multiHost,
  }
 
  class { 'mysql' :
    version => $versions[mysql],
    rootUserPassword => $password,
    ensure => $ensure,
  }
  ppdb::connect_root { 'mysql': ensure => $ensure }
   
  class { 'perl' :
    versions => $versions[perl],
    ensure => $ensure,
  }
          
  class { 'php' :
/*
    versions => {
      php => ,
      mcrypt => '5.3*',
    
      #The following modules are virtual resources that can be "realized" later.
      # If they are never realized they are never installed. 
      dba => '5.3*',
      mysql => '5.3*',
      pgsql => '5.3*',
      pear => '1.9*',
      pecl_apc => '3.1*',
      pecl_memcache => '3.0*',
    },
    */
    versions => $versions[php],
    ensure => $ensure,
  }

}                
