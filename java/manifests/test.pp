class java::test($modinf) {

  $JAVA = $params::JAVA
  
  ppext::exec { 'java::test':
    modinf => $modinf,
# Doesn't always work?
#    command => '$JAVA_HOME/bin/java -version',
    command => "$JAVA -version",
    expected_outregex => 'java version "[0-9]+\.[0-9]+\.[0-9_]+"',
  }
}
