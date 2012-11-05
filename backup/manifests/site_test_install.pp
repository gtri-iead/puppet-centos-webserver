node default {
  class { 'backup' :
    dailyBackupCount => 3,
    weeklyBackupCount => 2,
    monthlyBackupCount => 1,
  }
}
