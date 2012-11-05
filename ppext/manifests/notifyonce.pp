/*
 ppext::notifyonce

 Used to create a notify signal that can be subscribed to that occurs exactly once no matter how many times the manifest is applied. This is accomplished by placing a flag file with extension .notifyonce in the extpath for the module.

  Usage:
    # Declare module info (see ppext::module.pp)
    $modinf = { ... }
    
    ppext::notifyonce { 'mymodule::notifymeonce' : modinf => $modinf }
    ~>
    exec { 'dothisonce' :
      command => '...',
    }
*/
define ppext::notifyonce(
  $modinf /* Module info (see ppext::module.pp) */
) {

  include ppext::params
        
  # START PATTERN parse_resname
  $tmp = split($name,'::')
  if $tmp[0] != $modinf[name] { warning("Modinf[name](${modinf[name]}) does not match name($name)") }
  $resname = $tmp[1]
  # END PATTERN

  $flagfile = "${modinf[flagpath]}/${resname}.notifyonce"

  file { $flagfile :
    ensure => file,
    mode => 600,
  }
}
