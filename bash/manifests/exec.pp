/*
  bash::exec
    Execute a command (typically a bash script)
      *output of script is logged
      *scans output log for error regex, fails if any found

      Note: for simplicity the "refresh" parameter has been disabled
      
  Usage:

    file { '/home/someuser/doit.input' :
    }
    ->
    file { '/home/someuser/doit.log' :
    }
    ->
    bash::file { '/home/someuser/doit.sh' :
      command => [ 'command1','command2' ],
      envpath => [ '/bin','/bin/usr' ],
      environment => [ 'SOME=SETTING', 'ANOTHER=SETTING' ],
      owner => auser,
      mode => 700,
    }       
    ~>
    bash::exec { '/home/someuser/doit.sh' :
      parameters => [ 'arg1', 'arg2'],
      infile => '/home/someuser/doit.input',
      logfile => '/home/someuser/doit.log',
      
      refreshonly => true,
    }

*/
define bash::exec(
  $bashfile = $name, /* The path to the bash file. Optional, set to name if absent.  */
  $parameters = undef, /* Array of arguments to send to the script. Optional. */
  $su_user = false, /* Use su to run script as specified user instead of using execs standard user method. Optional. Use this if the script is owned by a certain user (e.g. root) and needs to be executed by a different user (e.g. postgres) */
  
  $infile = undef, /* File path to make the stdin of the script. Optional.  */
  $input = undef, /* String to use as stdin. Optional. */
  $logfile = undef, /* File path to append stdout & stderr to. Optional. */
  
  $testout = 'error_regex', /* Select which type of output checking to enable. Options are: error_regex, expected_outfile, expected_outregexfile, undef. Optional. */
  $outfile = undef, /* File path to store stdout & stderr for testing. Optional, only used if testout is enabled, if not specified then a temp file in /tmp is created. */

  $expected_outfile = undef, /* A file to diff output against to test for success. Must match exactly with the exception of lines matching the time stamp regex: [0-9]{2}:[0-9]{2}:[0-9]{2}. Optional. */
  $expected_outregexfile = undef, /* A regex file to match against output to test for success. Optional. */
  $error_regex = 'error|fatal|not found|could not|couldn\047t|no such|failed|denied|unrecognized', /* A regex to compare against the output to identify errors in the output. Optional  */
  
  /* Normal exec parameters which are forwarded to exec call */
  $creates = undef,
  $cwd = undef,
  $group = undef,
  $environment = undef,
  $logoutput = undef,
  $onlyif = undef,
  $provider = undef,
#  $refresh = undef, Not supported to simplify this code
  $refreshonly = undef,
  $returns = undef,
  $timeout = undef, 
  $tries = undef,
  $try_sleep = undef,
  $unless = undef,
  $user = undef
  ) {

  include bash::params

  # Initialize some shortcut variables
  $tmppath = $params::tmppath
  
  $TEE = $params::TEE
  $GREP = $params::GREP
  $DIFF = $params::DIFF
  $TEST = $params::TEST
  $WC = $params::WC
  $TR = $params::TR
  $PCREGREP = $params::PCREGREP
  $SED = $params::SED
  $SU = $params::SU
  $ECHO = $params::ECHO
  
  $match_regexfile_to_outfile_bashfile = $params::match_regexfile_to_outfile_bashfile
  
  # If su_user then the actual user used to invoke the script is root (SU is used to run as the specified user)
  if $su_user {
    $_user = 'root'
  } else {
    # Otherwise the actual user used to invoke the script using the normal exec method
    $_user = $user
  }

  # Check output of the script?
  if $testout {

    # Is an output file specified?
    if $outfile {
      # Yes, use that
      $_outfile = $outfile
    } else {
      # No, create a tmp file to store the output
      $tmpmd5 = md5($name)
      $tmpfile = "$params::tmppath/$tmpmd5.out"
      $_outfile = $tmpfile
      file { $tmpfile :
        ensure => present,
        mode => 600,
      }
    }

    # Build the command to store output
    $do_output = " | $TEE $_outfile"

    # Ensure outfile is defined
# TODO: bug, see below
#    if !defined(File[$_outfile]) {
#      err("File[$_outfile] is not defined")
#      fail()
#    }

    # What kind of output file checking are we doing?
    case $testout {

      # Using diff?
      'expected_outfile' : {
        # Ensure the expected output file is defined
# TODO: bug, see below
#        if !defined(File[$expected_outfile]) {
#          err("File[$expected_outfile] is not defined")
#          fail("Fatal error (see err above)")
#        }
        # Build the test using test, diff and grep
        /* The regex below excludes lines with '@' and lines with hh:mm:ss time stamps */
        $do_test = "$TEST `diff -U 0 $_outfile $expected_outfile | $GREP -E -v '@|([0-9][0-9]:[0-9][0-9]:[0-9][0-9])' | $WC -l` -eq 0"
        $test_returns = 0
        $env_test = undef
      }

      # Using regex?
      'expected_outregexfile' : {

        # Ensure the expected output regex file is defined
# TODO: bug, see below
#        if !defined(File[$expected_outregexfile]) {
#          err("File[$expected_outregexfile] is not defined")
#          fail("Fatal error (see err above)")
#        }
        # Ensure the script for matching the output against the regex is defined
# TODO: bug, see below
#        if !defined(File[$match_regexfile_to_outfile_bashfile]) {
#          err("File[$match_regexfile_to_outfile_bashfile] is not defined, ensure Class[bash] is defined.")
#          fail("Fatal error (see err above)")
#        }

        # Build the test
        $do_test = "$match_regexfile_to_outfile_bashfile $expected_outregexfile $_outfile"
        $env_test = [ "PCREGREP=$PCREGREP", "SED=$SED" ]
        $test_returns = 0
      }

      # Using simple error keyword scan?
      'error_regex' : {
        # Search for error regex in output. Returns 0 if found, 1 if not. Test should return 1.
        # The first grep is to filter off lines starting with '+ ', which occur from local echo of script commands
        $do_test = "$GREP -E -v '^\\+ ' $_outfile | $GREP -E -i '$error_regex'"
        $test_returns = 1 # Test should not find an error keywords
        $env_test = undef
      }

      default: {
        err("Invalid testout setting ($testout). Valid options are 'expected_outfile','expected_outregexfile','error_regex', and undef")
        fail("Fatal error (see err above)")
      }
    }

    # Test exec is triggered by main exec
    # TODO: the "tries" and "timeout" parameters are made irrelevant by using a second exec for testing. Should the first exec succeed but the test fail, no second attempt will ever be mad 
    exec { "TEST OUTPUT OF $name" :
      environment => $env_test,
      command => $do_test,
      returns => $test_returns,
      refreshonly => true,
      logoutput => $logoutput,
      provider => $provider,
      subscribe => Exec[$name],
      user => $_user, /* Take into account su_user setting */
    }

  } else {
    # No output checking
    $do_output = ''
  }

  # Append output to a log?
  if $logfile {
    $do_log = " | $TEE -a $logfile"

    # Ensure the log file is defined
# TODO: bug, see below
#    if !defined(File[$logfile]) {
#      err("File[$logfile] is not defined")
#      fail("Fatal error (see err above)")
#    }
                 
  } else {
    # No logging
    $do_log =''
  }

  # Pass some parameters to the script?
  if $parameters {
    # Build the arguments
    $args = inline_template('<%= " " %><% if parameters.respond_to?(\'join\') %><%= parameters.join(\' \') %><% else %><%= parameters %><% end %>')
  } else {
    # No arguments
    $args = ''
  }

  # Pass a file as stdin?
  if $infile {
    # Ensure the input file is defined
# TODO: bug, see below
#    if !defined(File[$infile]) {
#      err("File[$infile] is not defined")
#      fail("Fatal error (see err above)")
#    }
    # Build the command to pass the file as stdin
    $do_stdin = " < $infile"
  } else {
    $do_stdin = ''
  }
  
  # Route a string as stdin to the script
  # This is used to prevent storing sensitive info in file system
  # Or for uninstall scripts that can't store files as they uninstall
  if $input {
    # Escape new lines, quotation mark(") and back tick (`) and dollar sign ($)   
    $esc_step1 = regsubst($input,'`','\\`','EG') # \\140 
    $esc_step2 = regsubst($esc_step1,'"', '\\"','EG') # \\042
    $esc_step3 = regsubst($esc_step2,'\$','\\$','EG') # \\044
    $esc_step4 = regsubst($esc_step3,'\n','\\012','EG')
    $do_echoin = "$ECHO -e \"${esc_step4}\" | "
#    warning("input = $input escaped=$escaped_input do_echoin=$do_echoin")
    
  }  else {
    $do_echoin = ''
  }
              
  
  # Strip all non-printable characters from output such as ANSI colors or art
  $do_clean = " | $TR -cd '\\11\\12\\40-\\176'"

  # Assemble the command tail
  $c_tail = " 2>&1${do_stdin}${do_clean}${do_output}${do_log}"

  # Build the command
  if $su_user {
    # If su_user and user specified then run the command using su as user
    $c = "${do_echoin}$SU -c '${bashfile}${args}' - $user ${c_tail}"
  } else {
    # Otherwise, just invoke the script normally
    $c = "${do_echoin}${bashfile}${args}${c_tail}"
  }

  # Ensure the bash file exists
# TODO : bug -- this should work but causes undefined error if bash::file is followed by a bash::exec spread across modules
#  if !defined(File[$bashfile]) {
#    err("File[$bashfile] not defined")
#    fail("Fatal error (see err above)")
#  }

  # Run the bash
  exec { $name :
    command => $c,
    cwd => $cwd,
    creates => $creates,
    environment => $environment,
    group => $group,
    logoutput => $logoutput,
    onlyif => $onlyif,
# Path is controlled by bash file and bashfile is invoked with an absolute path so path environment variable is not needed
#    path => $path,
    provider => $provider,
    # Not supported
#      refresh => $refresh,
    refreshonly => $refreshonly,
    returns => $_returns,
    timeout => $timeout,
    tries => $tries,
    try_sleep => $try_sleep,
    unless => $unless,
    user => $_user,
  }

}
          
