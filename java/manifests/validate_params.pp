class java::validate_params($modinf)
{
  $version = $modinf[version]
  $ensure = $modinf[ensure]
  
  if($version !~ /^[0-9]+\.[0-9]+\.[0-9]+$/)
  {
    fail("\$version($version) must match 'MAJOR.MINOR.FIX' format, ex: 1.6.0")
  }
  if($ensure !~ /installed|latest|absent/) {
    fail("\$ensure($ensure) must be 'installed', 'latest' or 'absent'")
  }
}
