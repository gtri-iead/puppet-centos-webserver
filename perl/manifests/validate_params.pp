class perl::validate_params($ensure)
{
  if($ensure !~ /installed|latest/) {
    fail("\$ensure($ensure) must be 'installed' or 'latest'")
  }
}
