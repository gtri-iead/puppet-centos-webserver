class backup($dailyBackupCount, $weeklyBackupCount, $monthlyBackupCount, $ensure = undef) {

  include backup::params
  
  class { 'backup::install_files' : ensure => $ensure}
  ->
  class { 'backup::config_cron' :
    dailyBackupCount => $dailyBackupCount,
    weeklyBackupCount => $weeklyBackupCount,
    monthlyBackupCount => $monthlyBackupCount,
    ensure => $ensure,
  }
}
