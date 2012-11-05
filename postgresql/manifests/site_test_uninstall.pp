node default {
  include bash, ppext

  $password = file("/etc/puppet/passwords/$hostname.pwd")
  
  class { 'postgresql' :
    ensure => absent,
    version => '8.4*',
    rootUserPassword => $password,
  }

}
