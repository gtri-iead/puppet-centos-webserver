class php::test($modinf) {
  ppext::exec { 'php::test' :
    modinf => $modinf,
    command => "$params::PHP -v",
    expected_outregex => 'PHP [0-9]+.[0-9]+.[0-9]+ \(cli\)',
  }
}
