class maven::test($modinf) {

  ppext::exec { 'maven::test' :
    modinf => $modinf,
    path => [ '/bin','/usr/bin' ],
    command => "mvn -v",
    expected_outregex => 'Apache Maven [0-9]+\.[0-9]+\.[0-9]+'
  }
}
