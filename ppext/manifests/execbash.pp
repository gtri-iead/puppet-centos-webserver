/*
  ppext::execbash
    Execute a previously created ppext::bashfile
      *output of bash is logged
      *scans output log for error strings, fails if any found

      Note: for simplicity the "refresh" parameter has been disabled
      
  Usage:
    $module = 'mymodule'
    # Declare module info (see ppext::module.pp)
    $modinf = { ...}

    # "Reference" info for mymodule::does_awesome_stuff
    $r_bashfile = {
      name => "${module}::${resname}",
      resname => 'does_awesome_stuff',
      modinf => $modinf,
    }

    # Initialize the bashfile resource with the parameters
    ppext::bashfile { $r_bashfile[name] :
      resinf => $r_bashfile,
      
      command => [ 'command1', 'command2' ],
    }

    # Execute the bashfile
    ppext::execbash { 'mymodule::do_awesome_stuff1' :
      modinf => $modinf,

      r_bashfile => $r_bashfile,
      
      parameters => [ 'arg1', 'arg2' ],

      subscribe => Etc::Bashfile['mymodule::does_awesome_stuff'],
      refreshonly => true,
    }
    
    ppext::execbash { 'mymodule::do_awesome_stuff2' :
      modinf => $modinf,

      r_bashfile => $r_bashfile,
      
      parameters => [ 'arg3', 'arg4' ],

      subscribe => Etc::Bashfile['mymodule::does_awesome_stuff'],
      refreshonly => true,
    }
*/
define ppext::execbash(
  $modinf, # Module info hash. For expected keys, see ppext::module.pp 

  $r_bashfile, # Hash { bashfile => <name of bashfile resource>, modinf => <module info for bashfile> }

  $parameters = undef, # Array of arguments to send to the script. Optional.

  $infile = undef, # Path to file to make the stdin of the script. Optional.
  $input = undef, # String to make the stdin of the script. Optional.

  $expected_out = undef, # The content to diff output against to test for success. Must match exactly with the exception of lines matching the time stamp regex: [0-9]{2}:[0-9]{2}:[0-9]{2}. Optional, if specified overrides error_regex.
  $expected_outregex = undef, # The regex content to match against output to test for success. Optional, if specified overrides expected_out and expected_outregex.
  $error_regex = undef, # A regex to compare against the output to identify errors in the output. Optional. 
  
  # Normal exec parameters which are forwarded to exec call 
  $creates = undef,
  $environment = undef,
  $group = undef,
  $logoutput = undef,
  $onlyif = undef,
  $provider = undef,
#  $refresh = undef,
  $refreshonly = undef,
  $returns = undef,
  $timeout = undef,
  $tries = undef,
  $try_sleep = undef,
  $unless = undef,
  $user = undef
  ) {

  include ppext::params     

  File { owner => root, group => root, mode => 600 }
  
  # START PATTERN parse_resname
  $tmp = split($name,'::')
  if $tmp[0] != $modinf[name] { warning("Modinf[name](${modinf[name]}) does not match name($name)") }
  $resname = $tmp[1]
  # END PATTERN
  $module = $modinf[name]
 
  # Detect un/install in bashfile
#  if $r_bashfile[modinf][ensure] != absent {
    $bashfile = "${r_bashfile[modinf][binpath]}/${r_bashfile[resname]}" # Use bash file's module binpath and resname  
#  } else {
#    $bashfile = "$params::uninstall_path/${r_bashfile[name]}" # Use /tmp and resource's full module::name
#  }

  # Detect un/install for this execbash
#  if $modinf[ensure] != absent {
    
    # Install
    $outpath = $modinf[outpath]
    $fname = $resname
    $logfile = $modinf[logfile]
    
#  } else {
  
    #Uninstall
#    $outpath = $params::uninstall_path
#    $fname = $name # Use full module::name for /tmp
#    $uninstall_logfile = "$params::uninstall_path/${module}::uninstall.log"

    # Tried moving this to module, but since module is always processed "last" it doesn't work and generates cyclical dependencies
#    if !defined(File[$uninstall_logfile]) {
#      file { $uninstall_logfile:
#        ensure => present,
#      }
#    }
#    File[$uninstall_logfile] -> Bash::Exec[$name]
    
#    $logfile = $uninstall_logfile
#  }

  $outfile = "$outpath/$fname.out"
  
  if $expected_outregex {
    $testout = 'expected_outregexfile'
    $expected_outregexfile = "$outpath/$fname.expected.regex"
    file { $expected_outregexfile :
      content => $expected_outregex,
    }
    ->
    Bash::Exec[$name] 
  } else {
    if $expected_out {
      $testout = 'expected_outfile'
      $expected_outfile = "$outpath/$fname.expected.out"
      file { $expected_outfile :
        content => $expected_outfile,
      }
      ->
      Bash::Exec[$name]
    } else {
      $testout = 'error_regex'
    }
  }

  if $user and $user != 'root' {
    $su_user = true
  } else {
    $su_user = false
  }

  file { $outfile:
    ensure => present,
  }
   ->       
  /* Run the bash, route stdout and stderr to the log file */
  bash::exec { $name :
    bashfile => $bashfile,
    parameters => $parameters,
    infile => $infile,
    input => $input,
    logfile => $logfile,
    outfile => $outfile,
    testout => $testout,
    expected_outfile => $expected_outfile,
    expected_outregexfile => $expected_outregexfile,
    error_regex => $error_regex,
    su_user => $su_user,
    
    cwd => $extpath,
    creates => $creates,
    environment => $environment,
    group => $group,
    logoutput => $logoutput,
    onlyif => $onlyif,
    /*path => $path,*/
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
          