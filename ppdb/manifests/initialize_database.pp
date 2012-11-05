define ppdb::initialize_database(
  $modinf,

  $r_connect,

  $newDbName,

  $userinf,
  
  $refreshonly
) {

  $module = $modinf[name]

  $r_bashfile = {
    name => "${module}::initialize_database",
    resname => 'initialize_database',
    modinf => $modinf,
  }
  
  ppdb::initialize_database_bashfile { $r_bashfile[name] :
    resinf => $r_bashfile,
    r_connect => $r_connect,
    newDbName => $newDbName,
    userinf => $userinf,
  }
  ->
  ppext::execbash { $r_bashfile[name]:
    modinf => $modinf,
    r_bashfile => $r_bashfile,
    refreshonly => $refreshonly,
  }
}
