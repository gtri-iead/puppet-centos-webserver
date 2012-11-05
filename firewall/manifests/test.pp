class firewall::test($modinf) {

  $SERVICE = $params::SERVICE

  ppext::exec { 'firewall::test' :
    modinf => $modinf,
    command => "$SERVICE iptables status",
    expected_outregex => template("firewall/test.expected.regex.erb"),
  }

}
