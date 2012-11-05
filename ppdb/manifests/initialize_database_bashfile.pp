define ppdb::initialize_database_bashfile(
  $resinf,

  $r_connect,

  $newDbName,

  $userinf
) {

  include ppext::params

  $modinf = $resinf[modinf]
  $module = $modinf[name]

  $filespath = $modinf[filespath]

  $create_dbsqlfile = "$filespath/CREATE_DATABASE_${newDbName}.sql"

  $type = $r_connect[type]

  $CREATE_DATABASE_sql = template("ppdb/$type/CREATE_DATABASE.sql.erb")

  $newUserName = has_key($userinf, username) ? { true => $userinf[username], false => $newDbName }
  $newUserPassword = $userinf[password]
  $newUserHost = has_key($r_connect[serverinf], host) ? { true => $r_connect[serverinf][host], false => 'localhost' }

  $CREATE_USER_sql = template("ppdb/$type/CREATE_USER.sql.erb")
  
  $privilege = 'ALL PRIVILEGES'
  $target = $newDbName
  $targetType = 'DATABASE'
  $grantTo = $newUserName
  $GRANT_sql = template("ppdb/$type/GRANT.sql.erb")

  $connectfile = "${r_connect[modinf][binpath]}/${r_connect[resname]}"

  file { $create_dbsqlfile:
    content => "${CREATE_DATABASE_sql}\n${CREATE_USER_sql}\n${GRANT_sql}\n",
    owner => root,
    group => root,
    mode => 600,
  }
  ->
  ppext::bashfile { $resinf[name] :
    resinf => $resinf,
    command => [
      "$connectfile --echo=0 < $create_dbsqlfile",
    ],
  }
}
