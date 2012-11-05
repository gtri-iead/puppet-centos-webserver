define ppdb::runsql(
  $modinf, /* Module info */

  $r_connect, /* Connection info, see ppdb::connect.pp */
  
  $path = '', /* Path to the SQL file. Optional, if specified overrides content & source. */
  $content = '', /* The SQL content. Optional */
  $source = '', /* The SQL source. Optional, if specified overrides content. */

  $expected_out = undef, /* The content to diff against the output. Optional. */
  $expected_outregex = undef, /* The regex content to match against the output. Optional. */

  $storeSQL = true,
  
  $refreshonly = false
) {

  include ppdb::params, ppext::params
  
  # START PATTERN parse_resname
  $tmp = split($name,'::')
  if $tmp[0] != $modinf[name] { warning("Modinf[name](${modinf[name]}) does not match name($name)") }
  $resname = $tmp[1]
  # END PATTERN

  if $storeSQL {
    
    if $path == '' {
      $sqlfile = "${modinf[filespath]}/$resname.sql"

      /* Set SQL file content/source later based on parameters */
      file { $sqlfile :
        ensure => present,
        mode => 600,
        owner => root,
        group => root,
      }

      File[$sqlfile] -> Ppext::Execbash[$name]
    
    } else {
      $sqlfile = $path
    }

    $sqlin = undef

    if $source != '' {
      File[$sqlfile] { source => $source }
    } else {
      File[$sqlfile] { content => "$content\n" }
    }

    $parameters = ''
    
  } else {
    $sqlin = $content
    $sqlfile = undef
    $parameters = '--echo=0'
  }

  ppext::execbash { $name :
    modinf => $modinf,
    r_bashfile => $r_connect,
    parameters => $parameters,
    infile => $sqlfile,
    input => $sqlin,
    expected_out => $expected_out,
    expected_outregex => $expected_outregex,
    refreshonly => $refreshonly,
  }
        
}
