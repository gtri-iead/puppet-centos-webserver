/*
  bash::file
    Creates a shell bash in a modules etc directory:
      *command may be an array
      *echo of commands can be enabled/disabled
      *can set path or environment variables (either can be arrays)
      *can set owner and mode of bash file
      
  Usage:
    
    bash::file { '/home/someuser/doit.sh' :
      command => [ 'command1','command2' ],
      envpath => [ '/bin','/bin/usr' ],
      environment => [ 'SOME=SETTING', 'ANOTHER=SETTING' ],
      owner => auser,
      mode => 700,
    }
*/
define bash::file(
  $command, /* Array of commands or single command. Required. */
  $environment = undef, /* Array of environment variable assignments */
  $envpath = undef, /* The environment path variable assignment, can be an array. Optional. */
  $cwd = undef, /* The current working directory for the shell script. Optional. */
  $echo = true, /* Turn on/off bash command echo. Optional.  */
  $timestamp = true, /* Toggle header/footer timestamp. Optional. */
  $path = $name, /* The path to the bash file. Optional, assigned to name if not supplied. */
  $owner = undef, /* Owner of the file. Optional. */
  $group = undef, /* Group of the file. Optional. */
  $mode = 700, /* Mode of the file. Optional, should be executable.  */

  $namedArgs = false, /* Set to true to enable embedding of named argument script. Optional. */
  $requiredArgs = '', /* Array of required arguments used if namedArgs is true. Optional. */
  $optionalArgs = '', /* Array of optional arguments used if namedArgs is true. Optional.*/
  $help = '' /* Help to show if arguments are wrong if namedArgs is true. Optional. */
  ) {

  include bash::params
  
  $ECHO = $params::ECHO
  $DATE = $params::DATE
  
  # Requested named arguments for script?
  if $namedArgs {
    # Build the named args command from template
    $named_args_sh = template("bash/named_args.sh.erb")
    $named_args_command = "\n${named_args_sh}\n"
  } else {
    # No named args
    $named_args_command = ''
  }

  # Turn on echo in the bash bash if it is enabled
  if $echo {
    $echo_on_command = "set -x # echo on\n"
    $echo_off_command = "set +x # echo off\n"
  } else {
    $echo_on_command = ''
    $echo_off_command = ''
  }

  # Build the environment statements if enabled
  if $environment {
    $env_command = inline_template('<% if environment.respond_to?(\'each\') %><% environment.each do |e| %><%= e %><%= "\n" %><% end %><% else %><%= environment %><% end %><%= "\n" %>')
  } else {
    $env_command = ''
  }

  # Build command to change to cwd if enabled
  if $cwd {
    $cwd_command = "cd $cwd\n"
  } else {
    $cwd_command = ''
  }
  
  # Build the path statement if enabled
  if $envpath {
    $path_command = inline_template('<%= "PATH=" %><% if envpath.respond_to?(\'join\') %><%= envpath.join(\':\') %><% else %><%= envpath %><% end %><%= "\n" %>')
  } else {
    $path_command = ''
  }

  # Add a timestamp, if enabled
  if $timestamp {
    $ts_header = "$ECHO `$DATE` $name[START]\n"
    $ts_footer = "$ECHO `$DATE` $name[END]\n"
  } else {
    $ts_header = ''
    $ts_footer = ''
  }
  
  # Build the bash header and footer 
  $bash_header = "#!/bin/sh\n${named_args_command}${path_command}${env_command}${ts_header}${echo_on_command}${cwd_command}"
  $bash_footer = "${echo_off_command}${ts_footer}"

  # Assemble the commands, if an array is passed join the strings otherwise just set commands to the string
  $commands = inline_template('<% if command.respond_to?(\'join\') %><%= command.join("\n") %><% else %><%= command %><% end %><%= "\n" %>')

  # Store the bash script
  file { $path :
    content => "${bash_header}${commands}${bash_footer}",
    ensure => present,
    mode => $mode,
    owner => $owner,
    group => $group,
  }
   
}
          
