define ppdb::user(
  $modinf,
  $database = undef, # Optional. Database to auto-grant all priv to
  $userinf,
  /*
    username,
    password,
    options,
    host
  */
  
  $r_connect,
  $storeSQL = false,

  $refreshonly = false
) {
  
  $newUserName = $userinf[username]
  $newUserPassword = $userinf[password]

  if has_key($userinf,host) and $userinf[host] {
    $newUserHost = $userinf[host]
  } else {
    $newUserHost = 'localhost'
  }
        
  if has_key($userinf,options) and $userinf[options] {
    $newUserOptions = $userinf[options]
  } else {
    $newUserOptions = ''
  }
 
  $type = $r_connect[type]
  
  $uname = "${module}::CREATE_USER_${newUserName}"
  ppdb::runsql { $uname :
    modinf => $modinf,
    content => template("ppdb/$type/CREATE_USER.sql.erb"),

    r_connect => $r_connect,
    
    refreshonly => $refreshonly,
    storeSQL => $storeSQL,
    expected_outregex => template("ppdb/$type/CREATE_USER.expected.regex.erb"),
  }

  if $database {

    $gname = "${module}::${newUserName}"
    ppdb::grant { $gname :
      modinf => $modinf,

      r_connect => $r_connect,

      privilege => 'ALL PRIVILEGES',
      grantTo => $newUserName,
      targetType => 'DATABASE',
      target => $database,

      refreshonly => $refreshonly,
    }
    
    if $refreshonly {
      Ppdb::Runsql[$uname] ~> Ppdb::Grant[$gname]
    } else {
      Ppdb::Runsql[$uname] -> Ppdb::Grant[$gname]
    }
              
  }
}
        
