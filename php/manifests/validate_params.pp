class php::validate_params($ensure)
{

#  if($version !~ /^[0-9]+\.[0-9]+\.[0-9]+$/)
#  {
#    fail("\$version($version) must match 'MAJOR.MINOR.FIX' format, ex: 1.6.0")
#  }
  if($ensure !~ /installed|latest/) {
    fail("\$ensure($ensure) must be 'installed' or 'latest'")
  }
}
