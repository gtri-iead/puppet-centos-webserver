class bash::params {

  include paths
  
  $match_regexfile_to_outfile_bashfile = "/usr/bin/match_regexfile_to_outfile.sh"

  $TEE = $paths::TEE
  $GREP = $paths::GREP
  $DIFF = $paths::DIFF
  $TEST = $paths::TEST
  $WC = $paths::WC
  $TR = $paths::TR
  $PCREGREP = $paths::PCREGREP
  $SED = $paths::SED
  $SU = $paths::SU
  $ECHO = $paths::ECHO
  $DATE = $paths::DATE

  $tmppath = $paths::tmp
}
