define ppdb::dumpsql(
  $modinf,
  
  $r_dump,

  $database = undef,
  $outfile,
  $options = undef,
  $compress = false,
  
  $owner = undef,
  $group = undef,
  $mode = 600,

  $refeshonly = false
  ) {

  include ppext::params
    
  if $options {
    $c_options = " --options=$options"  
  } else {
    $c_options = ''
  }

  if $database {
    $c_database = " --database=$database"
  } else {
    $c_database = ''
  }
  
  if $compress {
    $c_compress = " | gzip > $outfile"
  } else {
    $c_compress = " > $outfile"
  }
  
  # TODO: this probably shouldn't be in here, let caller be responsible for defining the file
  file { $outfile :
    ensure => present,
    owner => $owner,
    group => $group,
    mode => $mode,
  }
  ->      
  ppext::exec { $name :
    modinf => $modinf,
    command => "${r_dump[modinf][binpath]}/${r_dump[resname]}${c_options}${c_database}${c_compress}",
    refreshonly => $refreshonly,
  }
}
