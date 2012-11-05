/*
    Copyright 2012 Georgia Tech Research Institute

    Author: Lance Gatlin [lance.gatlin@gtri.gatech.edu]
	
    This file is part of puppet-centos-webserver.

    puppet-centos-webserver is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    puppet-centos-webserver is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with puppet-centos-webserver. If not, see <http://www.gnu.org/licenses/>.

*/

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
