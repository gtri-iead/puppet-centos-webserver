define phpmyadmin::test($modinf, $testURL) {

  $CURL = $params::CURL
  ppext::exec { "phpmyadmin-${name}::test" :
    modinf => $modinf,
    command => "$CURL --silent --show-error $testURL",
    expected_outregex => '<title>\s*phpMyAdmin\s*</title>'
  }
}
