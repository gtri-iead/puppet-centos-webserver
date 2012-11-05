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

define ppext::execonce(
  $modinf, /* Module info (see ppext::module) */
  
  $command,

  $infile = undef,
  $input = undef,
 
  $expected_out = undef, /* Content to diff output against to test for success. Must match exactly with the exception of line s matching the time stamp regex: [0-9]{2}:[0-9]{2}:[0-9]{2}. Optional, if specified overrides error_regex. */
  $expected_outregex = undef, /* Regex content to match against output to test for success. Optional, if specified overrides expected_out and error_regex */
  $error_regex = undef, /* A regex to compare against the output to identify errors in the output. Optional  */
  
  $cwd = undef,
  $environment = undef,
  $group = undef,
  $logoutput = undef,
  $path = undef,
  $provider = undef,
  $returns = undef,
  $timeout = undef,
  $tries = undef,
  $try_sleep = undef,
  $user = undef,
  $logecho = undef
  ) {
          
  ppext::notifyonce { $name : modinf => $modinf }
  ~>
  ppext::exec { $name :
    modinf => $modinf,
    
    command => $command,

    infile => $infile,
    input => $input,

    expected_out => $expected_out,
    expected_outregex => $expected_outregex,
    error_regex => $error_regex,
    
    cwd => $cwd,
    environment => $environment,
    group => $group,
    logoutput => $logoutput,
    path => $path,
    provider => $provider,
    returns => $returns,
    timeout => $timeout,
    tries => $tries,
    try_sleep => $try_sleep,
    user => $user,
    refreshonly => true,
    logecho => $logecho,
  }    
}
