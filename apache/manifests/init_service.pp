class apache::init_service($modinf) {

  $ensure = $modinf[ensure]

  #START PATTERN init_service
  $service_enable = $ensure ? { default => true, absent => false }
  $service_ensure = $ensure ? { default => running, absent => stopped }
  #END PATTERN
  
  service { 'apache' :
    name => $params::svc_apache,
    enable => $service_enable,
    ensure => $service_ensure,
    hasstatus => true,
    hasrestart => true,
  }
}
