node default {
  include bash, ppext
  
  class { 'java' :
    version => '1.6.0',
    ensure => latest,
  }
  
  class { 'maven' :
    version => '2.2.1',
    ensure => installed,
  }
}
