node default {
  include bash,ppext
  
  class { 'java' :
    version => '1.6.0',
#    version => 'asdf',
    ensure => latest,
  }
    
}      
