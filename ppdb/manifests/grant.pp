define ppdb::grant( 
  $modinf,

  $privilege = 'ALL PRIVILEGES',
  $grantTo,
  $target,
  $targetType,

  $r_connect,
  
  $refreshonly = false
  ) {

  $ECHO = $params::ECHO
  $PSQL = $params::PSQL
  $GREP = $params::GREP
  
  $module = $modinf[name]
  
  $type = $r_connect[type]

  # GRANT [PRIV] ON DATABASE db.* TO user
  if $type == 'postgresql' and $targetType == 'database' {
    $pg_database = regsubst($target,'\.\*','')
  } else {
    # GRANT [PRIV] ON TABLE * TO user
    $pg_database = $r_connect[database]
  }
                
  # Simulate * behavior for postgresql grant
  if $type == 'postgresql' and (($targetType == 'DATABASE' and '.*' in $target) or ($targetType == 'TABLE' and $target == '*')) {
    
    $r_bashfile = {
      modinf => $params::modinf,
      name => 'ppdb::pg_grant',
      resname => 'pg_grant',
    }
    
    $pwdfile = "${r_connect[modinf][pwdpath]}/postgresql.${r_connect[userinf][username]}.pwd"
      
    if !defined(Ppext::Bashfile[$r_bashfile[name]]) {

      # Magical postgres grant script which can grant a user privileges on all tables in database
      ppext::bashfile { $r_bashfile[name]:
        resinf => $r_bashfile,
        # PGPASSFILE must be set for this script to work
        command => [
          # This SQL fetchs a list of all the table names and generates the SQL needed to grant user access to them
          "GET_GRANT_SQL=\"SELECT 'GRANT \$PRIVILEGE ON TABLE '||tablename||' to \$USER;' from pg_tables where schemaname in ('public') order by schemaname, tablename;\"",
          # Process the above SQL, returning the SQL actually required to grant the user the privilege on all the database's tables
          "GRANT_SQL=`$ECHO \$GET_GRANT_SQL | $PSQL \$DATABASE | $GREP '^ GRANT'`",
          # Execute the SQL to give user privileges on all the database's tables
          "$ECHO \$GRANT_SQL | $PSQL \$DATABASE",
          ],
        namedArgs => true,
        requiredArgs => [ 'privilege','user','database' ],
      }
      
    }

    # Can't pass ALL PRIVILEGES as a string due to the space
    if $privilege == 'ALL PRIVILEGES' {
      $priv = 'ALL'
    } else {
      $priv = $privilege
    }
    
    ppext::execbash { $name:
      modinf => $modinf,
      environment => "PGPASSFILE=$pwdfile",
      r_bashfile => $r_bashfile,
      # TODO: named arguments should accept things like --privilege='ALL PRIVILEGES'
      parameters => [ "--debug=1", "--privilege=${priv}", "--user=${grantTo}", "--database=${pg_database}", ],
      refreshonly => $refreshonly,
    }
  }
  
  if $type == 'postgresql' and  $targetType == 'TABLE' and $target == '*' {
    # Table case handled above completely
  } else {
    # Anything else execute normally (including postgresl DATABASE)
    # Normal grant is so easy, its nice when databases work like they are should
    $gname =  "${module}::GRANT_PRIVILEGE_ON_${target}_TO_${grantTo}"
    ppdb::runsql { $gname :
      modinf => $modinf,

      r_connect => $r_connect,
    
      content => template("ppdb/$type/GRANT.sql.erb"),
      expected_outregex => template("ppdb/$type/GRANT.expected.regex.erb"),

      refreshonly => $refreshonly,
    }
                      
  }
}
        
