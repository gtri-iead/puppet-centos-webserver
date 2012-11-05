define ppdb::initialize_dbcontent_bashfile(
  $resinf,
  $r_connect,
  $init_dbcontent_sqlfile
) {

  include ppext::params

  $binpath = $r_connect[modinf][binpath]
  $connect = $r_connect[resname]
  $connectfile = "${binpath}/${connect}"

  ppext::bashfile { $resinf[name]:
    resinf => $resinf,
    command => [
      "$connectfile --echo=0 < $init_dbcontent_sqlfile",
    ],
  }
}
