node default {
  include bash, ppext

  class { 'firewall':
    version => '*',
    ensure => latest,
  }
}
