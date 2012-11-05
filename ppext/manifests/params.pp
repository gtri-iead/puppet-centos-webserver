class ppext::params {
  include paths
         
  # Warning: don't use /etc/puppet/modules as puppet will get confused and try loading module files from here
  $etcpath = $paths::pp_etc
  # Where to put password files
  $pwdpath = "$etcpath/passwords"
  # Where to put logs
  $logpath = $paths::pp_log
  # Where to put scripts
  $binpath = $etcpath
  # Where to put output of scripts
  $outpath = $etcpath
  # Where to put notifyonce flags
  $flagpath = $etcpath
  # Where to stash files
  $filespath = $etcpath

  $uninstall_module = 'uninstall'
  $uninstall_modinf = {
    name => $uninstall_module,
    logpath => $paths::tmp,
    logfile => "$paths::tmp/uninstall.log",
    pwdpath => $paths::tmp,
    binpath => $paths::tmp,
    outpath => $paths::tmp,
    flagpath => $paths::tmp,
    filespath => $paths::tmp,
  }
        
  # Where to log output of uninstall scripts
  $uninstall_path = $paths::tmp
  
  $CURL = $paths::CURL
  $MV = $paths::MV
  $CHOWN = $paths::CHOWN
  $FIND = $paths::FIND
  $XARGS = $paths::XARGS
  $TAR = $paths::TAR
  $CHMOD = $paths::CHMOD
  $ECHO = $paths::ECHO

}
