define backup::backup_dbcontent_bashfile(
  $resinf,
  $r_dump
) {
  include backup::params, ppext::params

  $modinf = $resinf[modinf]
  $module = $modinf[name]
  $binpath = $modinf[binpath]
  if !has_key($modinf, backuppath) { fail("modinf[${modinf[name]}] is missing backuppath") }
  $backuppath = $modinf[backuppath]

  $dbName = $r_dump[database]
  $dumpfile = "${r_dump[modinf][binpath]}/${r_dump[resname]}"

  $MKDIR = $params::MKDIR

  ppext::bashfile { $resinf[name]:
    resinf => $resinf,
    command => [
      "$MKDIR -p $backuppath/dbcontent",
      "$dumpfile | gzip > $backuppath/dbcontent/$dbName.sql.gz",
    ],
  }
}
