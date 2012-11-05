node default {
  include bash, ppext
  
  class { 'imagemagick' :
    version => '*',
    ensure => latest,
  }
}
