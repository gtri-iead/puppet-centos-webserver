define ppext::download_files_bashfile(
  $resinf,

  $downloadURL,
  $unpackDir,
  $destpath,
  $owner = root,
  $group = root
) {

  include ppext::params

  $CURL = $params::CURL
  $MV = $params::MV
  $CHOWN = $params::CHOWN
  $FIND = $params::FIND
  $XARGS = $params::XARGS
  $TAR = $params::TAR
  $CHMOD = $params::CHMOD
  $ECHO = $params::ECHO

  ppext::bashfile { $resinf[name]:
    resinf => $resinf,
    command => [
      "$ECHO 'Downloading $downloadURL to $destpath'",
      # Follow location hints (--location) in the case of forwarding
      "$CURL --location --silent --show-error $downloadURL | $TAR zx --directory=$destpath",
      "$ECHO 'Unpacking $destpath/$unpackDir'",
      "$MV $destpath/$unpackDir/* $destpath",
      "$ECHO 'Fixing file permissions in $destpath'",
      "$CHOWN -R $owner:$group $destpath",
      "$FIND $destpath -type d -print0 | $XARGS -0 $CHMOD 755",
      "$FIND $destpath -type f -print0 | $XARGS -0 $CHMOD 644",
    ],
    echo => false,
  }
}
