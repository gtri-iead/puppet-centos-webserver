class mysql::validate_params($modinf)
{
  $ensure = $modinf[ensure]
  
  if($ensure !~ /installed|latest/) {
    fail("\$ensure($ensure) must be 'installed', 'latest' or 'absent'")
  }
}
