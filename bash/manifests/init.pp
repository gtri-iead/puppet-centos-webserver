class bash($ensure=undef) {
  include bash::params

  class { 'bash::install_files': ensure => $ensure}
}
