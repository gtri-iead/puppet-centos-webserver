class postgresql::init_service($modinf) { 

  $SLEEP = $params::SLEEP

  $ensure = $modinf[ensure]

  #START PATTERN init_service
  $service_enable = $ensure ? { default => true, absent => false }
  $service_ensure = $ensure ? { default => running, absent => stopped }
  #END PATTERN
  
  service { 'postgresql':
    name => $params::svc_pg,
    ensure => $service_ensure,
    enable => $service_enable,
    hasstatus => true,
    hasrestart => true,
  }
  ~>
  /* After starting postgres, it doesnt come up immediately even though it returns and reports okydoky */
  exec { 'hurry_up_postgresql' :
    command => "$SLEEP 30",
    refreshonly => true,
  }

}
