node default {
  include bash,ppext

  $password = file("/etc/puppet/passwords/$hostname.pwd")
  
/*
  class { 'apache' :
    ensure => latest,
    version => '2.2*',
  }
*/  
  class { 'java' :
    ensure => latest,
    version => '1.6.0',
  }

  class { 'log4j' :
    version => '*',
    ensure => latest,
  }
  
  class { 'tomcat' :
    version => '6.0*',
    ensure => latest,
    rootUserPassword => $password,
  }
}
