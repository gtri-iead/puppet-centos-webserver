define apache::test($modinf, $r_vhost) {

  include apache::params

  $module = $modinf[name]
  $vhost = $r_vhost[name]
  $testURL = $r_vhost[baseURL]
  
  $CURL = $params::CURL
  
  ppext::exec { "${module}::test_vhost_$vhost" :
    modinf => $modinf,
    command => "$CURL --silent --show-error --head $testURL",
    expected_outregex => "Server: Apache/[0-9]+\\.[0-9]+\\.[0-9]+ \\(.+\\)",
    require => Class['apache::init_service'],
  }
}
