define backup::restore_files_bashfile(
  $resinf,
  $destpath
) {

  include backup::params

  $module = $resinf[modinf][name]
  if !has_key($modinf, backuppath) { fail("modinf[${modinf[name]}] is missing backuppath") }
  $backuppath = $resinf[modinf][backuppath]

  $ECHO = $params::ECHO
  $CP = $params::CP

  ppext::bashfile { $resinf[name]:
    resinf => $resinf,
    command => [
      "$ECHO 'Restoring $backuppath/files to $destpath'",
      "$CP -Rf $backuppath/files/* $destpath",
      # Assumed that file permissions are preserved in backup
    ],
    echo => false,
  }
}
