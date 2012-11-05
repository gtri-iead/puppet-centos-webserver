define backup::restore_or_initialize_dbcontent(
  $modinf,
  $r_connect,
  $init_dbcontent_sqlfile,
  $refreshonly
) {

  $module = $modinf[name]

  $r_bashfile = {
    name => "${module}::restore_or_initialize_dbcontent",
    resname => "restore_or_initialize_dbcontent",
    modinf => $modinf,
  }
  
  backup::restore_or_initialize_dbcontent_bashfile { $r_bashfile[name] :
    resinf => $r_bashfile,
    r_connect => $r_connect,
    init_dbcontent_sqlfile => $init_dbcontent_sqlfile,
  }
  ->
  ppext::execbash { $r_bashfile[name]:
    modinf => $modinf,
    r_bashfile => $r_bashfile,
    refreshonly => $refreshonly,
  }
}  
