define ppdb::connect_root(
  $type = $name,
  $ensure
) {

  # TODO: ppdb needs to be ensure aware, this should uninstall the connect_root bashfile but doesn't
  if $ensure != absent {
    case $type {
      'mysql': {
        $r_mysql_connect = $ppdb::params::r_mysql_root_connect
        ppdb::connect { $r_mysql_connect[name] :
          resinf => $r_mysql_connect
        }
      }
      'postgresql': {
        $r_pg_connect = $ppdb::params::r_postgresql_root_connect
        ppdb::connect { $r_pg_connect[name] :
          resinf => $r_pg_connect
        }
      }
      default: { fail("Unsupported database type: $type") }
    }
  }
}
