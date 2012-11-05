define mediawiki::backup($modinf, $paths, $r_dump, $dbinf) {

  $module = $modinf[name]
  $binpath = $modinf[binpath]

  $dbName = $dbinf[database]
  
  $r_backup_files = {
    name => "${module}::backup_files",
    resname => "backup_files",
    modinf => $modinf,
  }
  $r_backup_dbcontent = {
    name => "${module}::backup_dbcontent",
    resname => "backup_dbcontent",
    modinf => $modinf,
  }
  $r_backup = {
    name => "${module}::backup",
    resname => "backup",
    modinf => $modinf,
  }
  
  ppdb::dump { $r_dump[name]:
    resinf => $r_dump,
  }
  ->
  backup::backup_files_bashfile { $r_backup_files[name]:
    resinf => $r_backup_files,
    srcpath => $paths[destpath]
  }
  ->
  backup::backup_dbcontent_bashfile { $r_backup_dbcontent[name]:
    resinf => $r_backup_dbcontent,
    r_dump => $r_dump,
  }
  ->
  ppext::bashfile { $r_backup[name]:
    resinf => $r_backup,
    command => [
      "$binpath/backup_files",
      "$binpath/backup_dbcontent",
    ],
    echo => false,
  }
  
  cron { $r_backup[name] :
   command => "$binpath/backup",
   user => root,
   hour => 1,
 }
     
}
