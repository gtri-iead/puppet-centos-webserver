class tomcat::init_service($modinf, $packageName) {

  $ensure = $modinf[ensure]
  $binpath = $modinf[binpath]
  
  #START PATTERN init_service
  $service_enable = $ensure ? { default => true, absent => false }
  $service_ensure = $ensure ? { default => running, absent => stopped }
  #END PATTERN
  
  $SLEEP = $params::SLEEP
  $GREP = $params::GREP
  $CURL = $params::CURL
  
  service { 'tomcat':
    name => $packageName,
    enable => $service_enable,
    ensure => $service_ensure,
    hasstatus => true,
#    hasrestart => true,
    hasrestart => false,
 }

 if $ensure != absent {

   $r_test_connect = {
     name => 'tomcat::test_connect',
     resname => 'test_connect',
     modinf => $modinf
   }
   
   ppext::bashfile { $r_test_connect[name]:
     resinf => $r_test_connect,
     command => [
       "$CURL --silent --show-error --connect-timeout 1 -I http://localhost:8080 2>&1 | $GREP 'Coyote'",
       "exit $?",
     ],
   }
   ->
   # After starting tomcat service, it doesn't come up immediately even though it returns and reports okydoky 
   ppext::exec { "${module}::wait_for_tomcat_to_really_start" :
     modinf => $modinf,
     command => [
        # From http://stackoverflow.com/questions/376279/wait-until-tomcat-finishes-starting-up
        "until $binpath/test_connect",
        "do",
        "$SLEEP 10",
        "done",
      ],
      subscribe => Service['tomcat'],
      refreshonly => true,
    }
    
  }
}
        
