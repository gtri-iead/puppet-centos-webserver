class backup::config_cron($dailyBackupCount, $weeklyBackupCount, $monthlyBackupCount, $ensure=undef) {

  $path = $params::path

  $cronEnsure = $ensure ? { default => present, absent => absent }

  cron { 'backup::shift_daily' :
    command => "$path/shift_backup.sh --input-interval=$path/current --interval=$path/daily --n=$dailyBackupCount",
    user => root,
    hour => 3,
    ensure => $cronEnsure,
  }
  
  cron { 'backup::shift_weekly' :
    command => "$path/shift_backup.sh --input-interval=$path/daily --interval=$path/weekly --n=$weeklyBackupCount",
    user => root,
    weekday => 7,
    hour => 2,
    ensure => $cronEnsure,
  }
  
  cron { 'backup::shift_monthly' :
    command => "$path/shift_backup.sh --input-interval=$path/weekly --interval=$path/monthly --n=$monthlyBackupCount",
    user => root,
    monthday => 1,
    hour => 1,
    ensure => $cronEnsure,
  }
        
}
