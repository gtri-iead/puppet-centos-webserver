class backup::params {
  include paths
  
  $path = $paths::backup

  $CURL = $paths::CURL
  $MV = $paths::MV
  $RM = $paths::RM
  $CHOWN = $paths::CHOWN
  $FIND = $paths::FIND
  $XARGS = $paths::XARGS
  $TAR = $paths::TAR
  $RSYNC = $paths::RSYNC
  $CP = $paths::CP
  $TEST = $paths::TEST
  $GZIP = $paths::GZIP
  $MKDIR = $paths::MKDIR
  $ECHO = $paths::ECHO  
}
