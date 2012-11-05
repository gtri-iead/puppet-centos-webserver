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

define ppext::exec(
  $modinf, /* Module info hash, see ppext::module */
  
  $command,
  $logecho = true,
  $log_timestamp = true,

  $infile = undef,
  $input = undef,
  
  $expected_out = undef, /* Content to diff output against to test for success. Must match exactly with the exception of lines matching the time stamp regex: [0-9]{2}:[0-9]{2}:[0-9]{2}. Optional, if specified overrides error_regex. */
  $expected_outregex = undef, /* Regex content to match against output to test for success. Optional, if specified overrides expected_out and error_regex */
  $error_regex = undef, /* A regex to compare against the output to identify errors in the output. Optional  */ 
  
  /* Normal exec parameters */
  $creates = undef,
  $cwd = undef,
  $environment = undef,
  $group = undef,
  $logoutput = undef,
  $onlyif = undef,
  $path = undef,
  $provider = undef,
/*  $refresh = undef,*/
  $refreshonly = undef,
  $returns = undef,
  $timeout = undef,
  $tries = undef,
  $try_sleep = undef,
  $unless = undef,
  $user = 'root'
) {

  include ppext::params

  # START PATTERN parse_resname
  $tmp = split($name,'::')
  if $tmp[0] != $modinf[name] { warning("Modinf[name](${modinf[name]}) does not match name($name)") }
  $resname = $tmp[1]
  # END PATTERN

  
  $r_bashfile = {
    name => "${modinf[name]}::${resname}",
    resname => $resname,
    modinf => $modinf,
  }
  
  /* Create a bash script */
  ppext::bashfile { $r_bashfile[name] :
    resinf => $r_bashfile,
    
    command => $command,
    environment => $environment,
    envpath => $path,
    cwd => $cwd,
    timestamp => $log_timestamp,
    echo => $logecho,
    owner => $user,
    group => root, /* This setting and the mode 770 ensure that root has access in addition to the user (which may not be root) */
    mode => 770, 
  }
  ->
  /* Run the bash script */
  ppext::execbash { $r_bashfile[name] :
    modinf => $modinf,
    
    r_bashfile => $r_bashfile,
    
    infile => $infile,
    input => $input,

    expected_out => $expected_out,
    expected_outregex => $expected_outregex,
    error_regex => $error_regex,
    
    creates => $creates,
    group => $group,
    logoutput => $logoutput,
    onlyif => $onlyif,
    provider => $provider,
/*      refresh => $refresh,*/
    refreshonly => $refreshonly,
    returns => $returns,
    timeout => $timeout,
    tries => $tries,
    try_sleep => $try_sleep,
    unless => $unless,
    user => $user,
  }

}
          
