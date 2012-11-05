class postgresql::init_db($modinf) {
  $SERVICE = $params::SERVICE

  # Must be performed once after initial install and service start
  ppext::execonce { 'postgresql::init_db':
    modinf => $modinf,
    command => "$SERVICE postgresql initdb",
    expected_outregex => template("postgresql/initdb.expected.regex.erb"),
  }
         
}
