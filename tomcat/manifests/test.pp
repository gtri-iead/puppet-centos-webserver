class tomcat::test($modinf) {

  $module = $params::module
  $CURL = $params::CURL

  ppext::exec { "${module}::test":
    modinf => $modinf,
    command => "$CURL --head --silent --show-error localhost:8080",
    expected_outregex => 'Server: Apache-Coyote/[0-9]+\.[0-9]+',
  }
}
