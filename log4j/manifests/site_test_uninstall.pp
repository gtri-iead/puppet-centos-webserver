node default {
  include ppext
  
  class { log4j: version => latest, ensure => absent }
}
