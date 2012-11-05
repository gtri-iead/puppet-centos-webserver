node default {
  include bash, ppext

  $password = file("/etc/puppet/passwords/$hostname.pwd")
  
  class { 'mysql' :
    ensure => latest,
    version => '5.1*',
    rootUserPassword => $password,
  }

}
