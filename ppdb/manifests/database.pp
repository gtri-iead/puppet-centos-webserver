define ppdb::database(
  $modinf,
   
  $r_connect,

  $createUserWithDbName = false,
  $newUserPassword = undef,
  
  $refreshonly = false
) {
 
  $module = $modinf[name]

  # START PATTERN parse_resname
  $tmp = split($name,'::')
  if $tmp[0] != $modinf[name] { warning("Modinf[name](${modinf[name]}) does not match name($name)") }
  $resname = $tmp[1]
  # END PATTERN

  $newDbName = $resname

  $type = $r_connect[type]

  $dname = "${module}::CREATE_DATABASE_${newDbName}"        
  ppdb::runsql { $dname :
    modinf => $modinf,

    r_connect => $r_connect,
    
    content => template("ppdb/$type/CREATE_DATABASE.sql.erb"),
    expected_outregex => template("ppdb/$type/CREATE_DATABASE.expected.regex.erb"),

    refreshonly => $refreshonly,
  }
  
  if $createUserWithDbName {

    if !$newUserPassword {
      fail("Cannot create user for database ($newDbName), newUserPassword is undefined")
    }
    $newUserName = $newDbName
  
    $userinf = {
      username => $newUserName,
      password => $newUserPassword,
      options => '',
      host => $r_connect[serverinf][host],
    }

    $uname = "${module}::${newUserName}"
    
    ppdb::user { $uname :
      modinf => $modinf,

      r_connect => $r_connect,
      
      userinf => $userinf,

      database => $newDbName,
      
      refreshonly => $refreshonly,
    }
        
    if $refreshonly {
      Ppdb::Runsql[$dname] ~> Ppdb::User[$uname]
    } else {
      Ppdb::Runsql[$dname] -> Ppdb::User[$uname]
    }                           
  }
}
