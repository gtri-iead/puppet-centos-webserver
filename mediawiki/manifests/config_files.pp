define mediawiki::config_files($modinf, $dbinf, $paths, $options, $useShortURLs) {

  # Unpack parameters for replacement in templates
  $version = $modinf[version]

  # Set some local variables for use in templates below

  $index_phpfile = $paths[index_phpfile] # Used in apacheAlias.conf.erb
  
  $dbType = $dbinf[type]
  $serverinf = $dbinf[server]

  if has_key($serverinf, 'host') {
    $dbHost = $serverinf[host]
  } else {
    $dbHost = 'localhost'
  }
  
  if has_key($serverinf,'port') {
    $dbServer = "$dbHost:${serverinf[port]}"
  } else {
    $dbServer = $dbHost
  }
  
  $dbName = $dbinf[database]
  $dbUser = $dbinf[user][username]
  $dbUserPassword = $dbinf[user][password]

  $siteName = $options[siteName]
  $adminEmail = $options[adminEmail]
  $anonCannotRegister = $options[anonCannotRegister]
  $anonCannotRead = $options[anonCannotRead]
  $anonCannotEdit = $options[anonCannotEdit]
  $whiteListRead = $options[whiteListRead]
  $enableSubpages = $options[enableSubpages]
  $namespacesWithSubpages = $options[namespacesWithSubpages]

  /* This requires rubygem-activesupport to be installed *before* starting puppet */

  /* Main config file for mediawiki */
  file { $paths[local_settings_phpfile]:
    content => template("mediawiki/$version/LocalSettings.php.erb"),
    replace => false,
  }
  ->
  /* Script that loads all settings from php files located under LocalSettings.d */
  file { $paths[local_settings_d_phpfile] :
    source => "puppet:///modules/mediawiki/$version/LocalSettings.d.php",
    replace => true,
  }
  ->
  /* The LocalSettings.d directory contains individual php settings file that should be loaded */
  file { $paths[local_settings_d_path] :
    ensure => directory,
  }
  ->
  /* The database settings file */
  file { $paths[db_phpfile] :
    content => template("mediawiki/$version/$dbType/db.php.erb"),
    replace => true,
  }
  ->
  /* The file uploads settings file */
  file { $paths[uploads_phpfile] :
    content => template("mediawiki/$version/uploads.php.erb"),
    replace => false,
  }
  ->
  /* The file that loads extensions */
  file { $paths[extensions_phpfile] :
    source => "puppet:///modules/mediawiki/$version/extensions.php",
    replace => false,
  }
  ->
  /* Keep those pesky bots from crawling Special pages */
  file { $paths[robots_txtfile] :
    source => "puppet:///modules/mediawiki/$version/robots.txt",
    replace => true,
  }
  ->
# This is handled by apache::alias now
#  /* Make apache respond to short URLs -- this depends on single-host apache configuration */
#  file { $paths[apache_shortURL_conffile] :
#    content => template("mediawiki/$version/apacheAlias.conf.erb"),
#    replace => true,
#    /*notify => Service['apache'],*/
#  }
#   ->
  /* Make the image directory writable by apache (for uploads) */
  file { $paths[images_path] :
    ensure => directory,
    mode => 755,
    owner => apache,
    group => apache,
  }
  
  /* Specific configuration settings files below here */

  /* Keep anonymous users from editing the wiki */
  file { $paths[anonCannotEdit_phpfile] :
    ensure => $anonCannotEdit ? {
      true => file,
      false => absent,
      },
    content => template("mediawiki/$version/anonCannotEdit.php.erb"),
    require => File[$paths[local_settings_d_path]],
    replace => true,
  }
  
  /* Keep anonymous users from registering at the wiki */
  file { $paths[anonCannotRegister_phpfile] :
    ensure => $anonCannotRegister ? {
      true => file,
      false => absent,
    },
    content => template("mediawiki/$version/anonCannotRegister.php.erb"),
    require => File[$paths[local_settings_d_path]],
    replace => true,
  }

  /* Keep anonymous users from reading the wiki (woth the exception of a white list) */
  file { $paths[anonCannotRead_phpfile] :
    ensure => $anonCannotRead ? {
      true => file,
      false => absent,
    },
    content => template("mediawiki/$version/anonCannotRead.php.erb"),
    require => File[$paths[local_settings_d_path]],
    replace => true,
  }
  
  /* Enable subpages for certain namespaces */
  file { $paths[enableSubpages_phpfile] :
    ensure => $enableSubpages ? {
          true => file,
          false => absent,
        },
    content => template("mediawiki/$version/enableSubpages.php.erb"),
    require => File[$paths[local_settings_d_path]],
    replace => true,
  }
  

                  
}
