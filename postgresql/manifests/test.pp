class postgresql::test($modinf, $paths) {

  $PSQL = $params::PSQL
  ppext::exec { 'postgresql::test_root_login':
    modinf => $modinf,
    command => "$PSQL postgres",
    environment => "PGPASSFILE=${paths[rootpwdfile]}",
    # Use default error_regex checking
  }
}
