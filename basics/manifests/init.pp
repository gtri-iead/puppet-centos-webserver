class basics($ensure) {

  include basics::params
  
  class { 'basics::install_packages': ensure => $ensure }
}
