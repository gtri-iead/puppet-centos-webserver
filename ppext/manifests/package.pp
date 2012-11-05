define ppext::package($packageName, $version, $ensure, $virtual = false) {

  if $ensure !~ /latest|installed|absent/ { fail("$ensure($ensure) must be either 'latest','installed' or 'absent'") }

  $pkgname =
    $version ? {
      '*' => $packageName,
      'latest' => $packageName,
      'installed' => $packageName,
      'present' => $packageName,
      undef => $packageName,
      '' => $packageName,
      default => "${packageName}-${version}"
    }
    
  if $virtual == true and $ensure != absent {
    @package { $name:
      name => $pkgname,
      ensure => $ensure,
    }
  } else {
    package { $name:
      name => $pkgname,
      ensure => $ensure,
    }           
  }
}
