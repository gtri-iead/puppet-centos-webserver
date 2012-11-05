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
