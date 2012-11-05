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
          
