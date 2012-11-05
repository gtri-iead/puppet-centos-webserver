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
