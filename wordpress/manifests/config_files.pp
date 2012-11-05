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

define wordpress::config_files($modinf, $dbinf, $paths, $options) {

  # Unpack parameters for replacement in templates
  $version = $modinf[version]
  
  # Set some local variables for use in templates below 
  $dbType = $dbinf[type]
  $serverinf = $dbinf[server]

  if has_key($serverinf,port) {
    $dbServer = "${serverinf[host]}:${serverinf[port]}"
  } else {
    $dbServer = has_key($serverinf,host) ? { true => $serverinf[host], false => 'localhost' }
  }
          
  $dbName = $dbinf[database]
  $dbUser = $dbinf[user][username]
  $dbUserPassword = $dbinf[user][password]
  
#  $wpSiteName = $options[siteName]
  $wpLang = $options[lang]
#  $wpUserName = $options[user][username]
#  $wpUserNiceName = $options[user][nicename]
#  $wpUserDisplayName = $options[user][displayname]
#  $wpUserEmail = $options[user][email]
#  $wpUserNickName = $options[user][nickname]
  
  /* This requires rubygem-activesupport to be installed *before* starting puppet */

  /* Main config file for wordpress */
  file { $paths[wp_config_phpfile]:
    content => template("wordpress/$version/wp-config.php.erb"),
    replace => false,
  }
                  
}
