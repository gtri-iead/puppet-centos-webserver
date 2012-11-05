class imagemagick::test($modinf) {

  ppext::exec { 'imagemagick::test' :
    modinf => $modinf,
    command => "$params::CONVERT --version",
    expected_outregex => 'Version: ImageMagick [0-9]+\.[0-9]+\.[0-9]+',
  }
}
