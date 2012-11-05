class postgresql::params {
  include paths, ppext::params

  $module = 'postgresql'
  $modinf = {
    name => $module,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }
        
  $pgpath = "$paths::var_lib/pgsql"
  $pg_hbafile = "$pgpath/data/pg_hba.conf"

#  $initsqlfile = "${modinf[filespath]}/initialize.sql"
 
  $rootpgpassfile = '/root/.pgpass'

  $SERVICE = $paths::SERVICE
  $SLEEP = $paths::SLEEP
  $PSQL = "$paths::usr_bin/psql"
  $PG_DUMP = "$paths::usr_bin/pg_dump"

  $pkg_pg = 'postgresql'
  $pkg_pg_server = 'postgresql-server'

  $svc_pg = 'postgresql'
}
