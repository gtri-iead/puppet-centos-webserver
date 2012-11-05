class perl::test($modinf) {

  $PERL = $params::PERL
  
  ppext::exec { 'perl::test':
    modinf => $modinf,
    command => "$PERL -v",
    expected_outregex => 'This is perl, v[0-9]+\.[0-9]+\.[0-9]+', 
  }
}
