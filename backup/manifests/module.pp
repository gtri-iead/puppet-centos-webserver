/*
  backup::module
    Ensures the directory to place a modules backups exists
  Usage:
    backup::module { 'mymodule' : }

*/
define backup::module($ensure = undef) {

  include backup::params

  if $ensure != absent
  {
    $dirEnsure = directory
  } else {
    $dirEnsure = absent
  }
  
  file { "$params::path/$name" :
    ensure => $dirEnsure,
    owner => root,
    group => root,
    mode => 755,
  }
}
