/* Java-Postgres-Tomcat stack */
class jptstack($password,$versions,$ensure) {
  
  class { 'java' :
    version => $versions[java],
    ensure => $ensure,
  }
    
  class { 'postgresql' :
    version => $versions[postgresql],
    ensure => $ensure,
    rootUserPassword => $password,
  }
  ppdb::connect_root { 'postgresql': ensure => $ensure }
  
  class { 'log4j' :
    version => $versions[log4j],
    ensure => $ensure,
  }
    
  class { 'tomcat' :
    version => $versions[tomcat],
    ensure => $ensure,
    rootUserPassword => $password,
  }      

}
