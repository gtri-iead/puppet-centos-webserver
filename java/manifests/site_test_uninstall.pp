node default {
  include ppext

  class { java: version => '1.6.0', ensure => absent }
}
