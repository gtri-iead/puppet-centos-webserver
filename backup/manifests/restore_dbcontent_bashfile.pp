define backup::restore_dbcontent_bashfile(
  $resinf,
  $r_connect
) {
  include backup::params, ppext::params

  $modinf = $resinf[modinf]
  $module = $modinf[name]
  $binpath = $modinf[binpath]
  if !has_key($modinf, backuppath) { fail("modinf[${modinf[name]}] is missing backuppath") }
  $backuppath = $modinf[backuppath]

  $connectfile = "${r_connect[modinf][binpath]}/${r_connect[resname]}"

  $ECHO = $params::ECHO
  $GZIP = $params::GZIP
  
  ppext::bashfile { $resinf[name]:
    resinf => $resinf,
    command => [
      "$ECHO 'Restoring $backuppath/dbcontent/$dbName.sql.gz to database $dbName'",
      "$GZIP -c -d $backuppath/dbcontent/$dbName.sql.gz | $connectfile --echo=0",
    ],
    echo => false,
  }
}
