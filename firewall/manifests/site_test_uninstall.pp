node default {

  include ppext
  
  class { firewall :
    version => '*',
    ensure => absent
  }
}
