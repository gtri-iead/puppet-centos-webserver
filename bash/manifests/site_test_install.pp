/*
    Copyright 2012 Georgia Tech Research Institute

    Author: Lance Gatlin [lance.gatlin@gtri.gatech.edu]
	
    This file is part of puppet-centos-webserver.

    puppet-centos-webserver is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    puppet-centos-webserver is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with puppet-centos-webserver. If not, see <http://www.gnu.org/licenses/>.

*/

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
