/*
  ppext::exec
    Extends the base exec to add the following:
      *command may be an array
      *command is assembled into a bash script stored on the client
      *output of bash is logged
      *bash stored on client can be removed if required
      *scans output log for error strings, fails if any found

      Note: for simplicity the "refresh" parameter has been disabled in ppext::exec
      
  Usage:
    # Declare module and modinf (see ppext::module)
    $modinf => { ... }
    
    
    ppext::exec { 'mymodule::create_root' :
      modinf => $modinf,
      
      command => [ 'command1','command2' ],
    }
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
          
