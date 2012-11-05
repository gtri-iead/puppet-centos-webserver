define mediawiki::test($modinf, $testURL, $siteName) {

  $module = $modinf[name] 
  
  $CURL = $params::CURL

  ppext::exec { "${module}::test":
    modinf => $modinf,
    command => "$CURL --silent --show-error $testURL",
    expected_outregex => "<title>.* - $siteName</title>",
  }

}
