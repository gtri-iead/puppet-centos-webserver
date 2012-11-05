/*
    Copyright 2012 Georgia Tech Research Institute

    Author: Lance Gatlin [lance.gatlin@gtri.gatech.edu]
	
    This file is part of puppet-centos-webserver.

    puppet-centos-webserver is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    puppet-centos-webserver is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with puppet-centos-webserver. If not, see <http://www.gnu.org/licenses/>.

*/

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
