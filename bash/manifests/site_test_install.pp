node default {
  include bash
  
  file { '/tmp/test.log' : }
  
  bash::file { '/tmp/test.sh' :
    command => [ 'echo $1', 'echo $2', 'echo 3', 'echo $CHOCOLATE', 'echo $BRUSSEL_SPROUTS', 'echo $TEST' ],
    cwd => "/home",
    envpath => [ "/root", "/var" ],
    environment => [ "CHOCOLATE=YUM", "BRUSSEL_SPROUTS=YUCK" ],
    namedArgs => true,
    requiredArgs => 'test',
    optionalArgs => 'debug',
    help => 'some help',
  }
  ->
  bash::exec { '/tmp/test.sh' :
    parameters => [ '--test=testytesttest' ],
    logfile => '/tmp/test.log',
  }

  file { '/tmp/hello.expected.out' :
    content => "+ echo hello 99\nhello 99\n+ set +x\n"
  }
  ->
  file { '/tmp/hello.expected.regex':
    content => 'hello [0-9]+',
  }
  ->
  bash::file { '/tmp/hello.sh' :
    command => 'echo hello $1'
  }
  
  bash::exec { 'TEST FAIL expected_outregexfile':
    bashfile => '/tmp/hello.sh',
    parameters => 'axc',
    logfile => '/tmp/test.log',
    testout => 'expected_outregexfile',
    expected_outregexfile => '/tmp/hello.expected.regex',
    require => [ File['/tmp/hello.expected.regex'], File['/tmp/hello.sh'], File['/tmp/test.log'], ],
  }
  
  bash::exec { 'TEST PASS expected_outregexfile':
    bashfile => '/tmp/hello.sh',
    parameters => '67',
    logfile => '/tmp/test.log',
    testout => 'expected_outregexfile',
    expected_outregexfile => '/tmp/hello.expected.regex',
    require => [ File['/tmp/hello.expected.regex'], File['/tmp/hello.sh'], File['/tmp/test.log'], ],
  }

  bash::exec { 'TEST input':
    bashfile => '/tmp/hello.sh',
    input => "hello $'`\"123\nad\nsf",
    logfile => '/tmp/test.log',
    require => [ File['/tmp/hello.sh'], File['/tmp/test.log'] ],
  }
  
  bash::exec { 'TEST FAIL expected_outfile':
    bashfile => '/tmp/hello.sh',
    parameters => '66',
    logfile => '/tmp/test.log',
    testout => 'expected_outfile',
    expected_outfile => '/tmp/hello.expected.out',
  }
  
  bash::exec { 'TEST PASS expected_outfile':
    bashfile => '/tmp/hello.sh',
    parameters => '99',
    logfile => '/tmp/test.log',
    testout => 'expected_outfile',
    expected_outfile => '/tmp/hello.expected.out',
  }

}
