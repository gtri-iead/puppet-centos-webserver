node default {
  include bash, ppext

  $password = file("/etc/puppet/passwords/$hostname.pwd")
  
  class { 'jptstack' :
    password => $password,
    versions => {
      java => '1.6.0',
      postgresql => '8.4*',
      log4j => '*',
      tomcat => '6.0*'
    },
    ensure => installed,
  }
}
