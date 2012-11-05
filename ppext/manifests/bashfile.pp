/*
  ppext::bashfile
    Creates a bash script in a modules etc directory:
      *command may be an array
      *echo of commands can be enabled/disabled
      *can set path or environment variables (either can be arrays)
      *can set owner and mode of bash file
      
  Usage:
    # Declare module info (see ppext::module.pp)
    $modinf => { ... }

    # Reference info for resource mymodule::create_root
    # This hash allows referencing this resource's parameters inside resources
    $r_bashfile => {
      name => 'mymodule::create_root',
      resname => 'create_root',
      modinf => $modinf,
    }
    
    ppext::bashfile { $r_bashfile[name] :
      resinf => $r_bashfile,

      command => [ 'command1','command2' ],
      path => [ '/bin','/bin/usr' ],
      environment => [ 'SOME=SETTING', 'ANOTHER=SETTING' ],
      owner => root,
      mode => 700,
    }

    The above will create the bash /etc/puppet/modules.etc/mymodule/create_root.sh based on the two commands (and the path and environment settings) owned and only accessible by root */
define ppext::bashfile(
/*  $r_bashfilename = undef, # R_Bashfileource name. Required if bashfiler_bashfile is not specified */
/*  $modinf = undef, # Module info. Required if bashfiler_bashfile is not specified */
  $resinf, # Hash { r_bashfilename => <string name of r_bashfileource>, modinf => <hash of module info> }. Required.

  $command, # Array of commands or single command to put in the bash file. Required. 
  $environment = undef, # Array of environment variables to put in the bash file. Optional.
  $envpath = undef, # The environment path variable to put in the bash file. Optional.
  $cwd = undef, # The current working directory of the bash file. Optional.
  $echo = undef, # Toggle echo of commands from bash file. Optional. 
  $timestamp = undef, # Toggle header/footer timestamp from bash file. Optional.
  $owner = undef, # Owner of the bash file. Optional.
  $group = undef, # Group of the bash file. Optional. 
  $mode = undef, # Mode of the bash file. Optional. 
  $namedArgs = false, # Set to true to enable embedding of named argument script. Optional. 
  $requiredArgs = undef, # Array of required arguments used if namedArgs is true. Optional. 
  $optionalArgs = undef, # Array of optional arguments used if namedArgs is true. Optional.
  $help = undef # Help to show if arguments are wrong if namedArgs is true. Optional. 
  ) {

  include ppext::params

  # START PATTERN parse_resinf
  $resname = $resinf[resname]
  $modinf = $resinf[modinf]
  $tmp = split($name, '::')
  if $tmp[0] != $modinf[name] { warning("Modinf[name](${modinf[name]}) does not match name($name)") }
  if $tmp[1] != $resname { warning("resinf[resname]($resname) does not match name($name)") }
  # END PATTERN

#  if $modinf[ensure] != absent {
    # Install - store in module's bin path
    $bashfile = "${modinf[binpath]}/${resname}"
#  } else {
    # Uninstall - store in /tmp
#    $bashfile = "$params::uninstall_path/$name"
#  }

  bash::file { $name :
    path => $bashfile,
    command => $command,
    envpath => $envpath,
    environment => $environment,
    owner => $owner,
    group => $group,
    mode => $mode,
    echo => $echo,
    timestamp => $timestamp,
    cwd => $cwd,
    namedArgs => $namedArgs,
    requiredArgs => $requiredArgs,
    optionalArgs => $optionalArgs,
    help => $help,
  }
}
          
