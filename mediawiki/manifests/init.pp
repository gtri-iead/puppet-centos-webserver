define mediawiki(
  $version,
  $ensure,
  $destpath,
  $testURL,
  $useShortURLs, # Set to true to enable URLs like http://server.org/wiki/Main_page instead of http://server.org/w/index.php?title=Main_page. If enabled, an apache alias must be declared.
  
  $dbinf, /* Hash with the following keys: */
/*
  type
  server
    host
    port
  database
  privUser
    username
    password
  user
    username
    password
*/
  $options /* Hash with the following keys: */
/*  
  siteName
  adminEmail
  anonCannotRegister
  anonCannotRead
  anonCannotEdit
  whiteListRead
  enableSubpages
  namespacesWithSubpages
*/  

) { 

  include mediawiki::params, apache::params, ppext::params, backup::params

  # Why puppet why? why must I backslash a period?!?
  $vtmp = split($version,'\.')
  $majorVersion = $vtmp[0]
  $minorVersion = $vtmp[1]

  $module = "mediawiki-$name"
  $modinf = {
    name => $module,
    version => $version,
    majorVersion => $majorVersion,
    minorVersion => $minorVersion,
    ensure => $ensure,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
    backuppath => "$backup::params::path/current/$module",
  }

  $dbType = $dbinf[type]
  $r_privconnect = {
    name => "${module}::connect_priv",
    resname => 'connect_priv',
    modinf => $modinf,

    type => $dbType,
    serverinf => $dbinf[server],
    userinf => $dbinf[privUser]
  }

  $dbName = $dbinf[database]
  $r_connect = {
    name => "${module}::connect_$dbName",
    resname => "connect_$dbName",
    modinf => $modinf,

    type => $dbType,
    serverinf => $dbinf[server],
    userinf => $dbinf[user],
    database => $dbName,
  }
  $r_dump = {
    name => "${module}::dump_$dbName",
    resname => "dump_$dbName",
    modinf => $modinf,

    type => $dbType,
    serverinf => $dbinf[server],
    userinf => $dbinf[user],
    database => $dbName,
  }

  $mwpath = "$destpath/w"
  $paths = {
    basepath => $destpath,
    destpath => $mwpath,

    # config_files
    local_settings_phpfile => "$mwpath/LocalSettings.php",
    local_settings_d_phpfile => "$mwpath/LocalSettings.d.php",
    local_settings_d_path => "$mwpath/LocalSettings.d",
    db_phpfile => "$mwpath/LocalSettings.d/db.php",
    uploads_phpfile => "$mwpath/LocalSettings.d/uploads.php",
    extensions_phpfile => "$mwpath/extensions/extensions.php",
    robots_txtfile => "$mwpath/robots.txt",
    apache_shortURL_conffile => "$apache::params::conf_d_path/mediawiki_${siteName}_shortURLAlias.conf",
    images_path => "$mwpath/images",
    anonCannotEdit_phpfile => "$mwpath/LocalSettings.d/anonCannotEdit.php",
    anonCannotRegister_phpfile => "$mwpath/LocalSettings.d/anonCannotRegister.php",
    anonCannotRead_phpfile => "$mwpath/LocalSettings.d/anonCannotRead.php",
    enableSubpages_phpfile => "$mwpath/LocalSettings.d/enableSubpages.php",
    index_phpfile => "$mwpath/index.php",

    # init_database
    init_dbcontent_sqlfile => "${modinf[filespath]}/IMPORT_TABLES.sql",

    # install_files
    redirect_phpfile => "$destpath/index.php",
    install_flag_path => "$mwpath/index.php",
  }
  
  $downloadURL = "http://dumps.wikimedia.org/mediawiki/$majorVersion.$minorVersion/mediawiki-$version.tar.gz"
  $unpackDir = "mediawiki-$version"

  if $ensure != absent {
    
    ppext::module { $module : modinf => $modinf }
    ->
    mediawiki::prereqs { $name :
      modinf => $modinf,
      paths => $paths,
      dbType => $dbType,
      siteName => $options[siteName],
    }
    ->
    mediawiki::install_files { $name :
      modinf => $modinf,
      paths => $paths,
      downloadURL => $downloadURL,
      unpackDir => $unpackDir,
    }
    ->
    mediawiki::config_files  { $name :
      modinf => $modinf,
      dbinf => $dbinf,
      paths => $paths,
      options => $options,
      useShortURLs => $useShortURLs,
    }
/*    ->
    apache::alias { $name:
      ensure => $ensure,
      vhost => $vhost,
      aliasURL => '/wiki',
      htmlpath => $paths[index_phpfile],
    }*/
    ->
    mediawiki::init_database { $name :
      modinf => $modinf,
      paths => $paths,
      r_privconnect => $r_privconnect,
      r_connect => $r_connect,
      dbinf => $dbinf,
    }
    ->
    mediawiki::test { $name :
      modinf => $modinf,
      testURL => $testURL,
      siteName => $options[siteName],
    }
    ->
    mediawiki::backup { $name:
      modinf => $modinf,
      paths => $paths,
      r_dump => $r_dump,
      dbinf => $dbinf,
    }

  } else {

    ppext::module { $module : modinf => $modinf }
    <-
    mediawiki::prereqs { $name :
      modinf => $modinf,
      paths => $paths,
      dbType => $dbType,
      siteName => $options[siteName],
    }
    <-
    mediawiki::uninstall { $name :
      modinf => $modinf,
      dbinf => $dbinf,
      paths => $paths,
      r_privconnect => $r_privconnect,
    }
/*    ->
    apache::alias { $name:
      ensure => $ensure,
      vhost => $vhost,
      aliasURL => '/wiki/',
      htmlpath => $mwpath,
    }*/
              

    # Doesn't remove backups
  }
}
