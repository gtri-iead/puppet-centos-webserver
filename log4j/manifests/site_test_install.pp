node default {
  include bash, ppext
  
  class { 'log4j' :
    version => '*',
    ensure => latest,
  }

}
