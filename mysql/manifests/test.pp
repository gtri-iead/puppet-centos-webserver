class mysql::test($modinf, $paths) {

  $pwdfile = $paths[pwdfile]
  $MYSQL = $params::MYSQL
  
  ppext::exec { 'mysql::test_root_login':
    modinf => $modinf,
    command => "$MYSQL --defaults-extra-file=$pwdfile mysql",
    /* Use default error_regex */
  }
}
