class paths {

  $etc = '/etc'
  $sysconfig = "$etc/sysconfig"
  $profile_d = "$etc/profile.d"
  
  $log = '/var/log'
  $www = '/var/www'
  $bin = '/bin'
  $sbin = '/sbin'
  $usr_bin = '/usr/bin'
  $usr_share = '/usr/share'
  $usr_lib = '/usr/lib'
  $lib = '/var/lib'
  $tmp = '/tmp'
  $backup = '/var/backup'
  $var_lib = $lib
  $var_log = $log
  $var_www = $www

  $pp_etc = '/etc/puppet'
  $pp_log = '/var/log/puppet'

  $jvm = "$usr_lib/jvm"
  
  $CURL = "$usr_bin/curl"
  $ECHO = "$bin/echo"
  $TEE = "$usr_bin/tee"
  $GREP = "$bin/grep"
  $DIFF = "$usr_bin/diff"
  $TEST = "$usr_bin/test"
  $WC = "$usr_bin/wc"
  $TR = "$usr_bin/tr"
  $PCREGREP = "$usr_bin/pcregrep"
  $SED = "$bin/sed"
  $DATE = "$bin/date"
  $SU = "$bin/su"
  $SERVICE = "$sbin/service"  
  $RM = "$bin/rm"
  $TAR = "$bin/tar"
  $MV = "$bin/mv"
  $SLEEP = "$bin/sleep"
  $CHMOD = "$bin/chmod"
  $CHOWN = "$bin/chown"
  $FIND = "$bin/find"
  $XARGS = "$usr_bin/xargs"
  $CP = "$bin/cp"
  $GZIP = "$bin/gzip"
  $RSYNC = "$usr_bin/rsync"
  $MKDIR = "$bin/mkdir"
}
