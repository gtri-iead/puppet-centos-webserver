define backup::backup_files_bashfile(
  $resinf,
  $srcpath
) {

  include backup::params

  $modinf = $resinf[modinf]
  $module = $modinf[name]
  if !has_key($modinf, backuppath) { fail("modinf[${modinf[name]}] is missing backuppath") }
  $backuppath = $resinf[modinf][backuppath]
  
  $RSYNC = $params::RSYNC
  $MKDIR = $params::MKDIR

  ppext::bashfile { $resinf[name]:
    resinf => $resinf,
    command => [
    "$MKDIR -p $backuppath/files",
    "$RSYNC -a --delete $srcpath/* $backuppath/files",
    ]
  }
}
