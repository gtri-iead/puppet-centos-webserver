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

define wordpress(
  $version,
  $ensure,
  $targetPath,
  $testURL,
  
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
  lang
  user
    username
    nicename
    displayname
    nickname
    email
*/  

) { 

  include wordpress::params

  # Why puppet why? why must I backslash a period?!?
  $vtmp = split($version,'\.')
  $majorVersion = $vtmp[0]
  $minorVersion = $vtmp[1]

  $module = "wordpress-$name"
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
  if $dbType != 'mysql' { fail("Wordpress only supports mysql database.") }
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

  $paths = {
    destpath => $targetPath,

    # config_files
    wp_config_phpfile => "$targetPath/wp-config.php",
    
    # init_database
    init_dbcontent_sqlfile => "${modinf[filespath]}/init_dbcontent.sql",

    # install_files
    install_flag_path => "$targetPath/index.php",
  }
  
  $downloadURL = "http://wordpress.org/wordpress-${version}.tar.gz"
  $unpackDir = "wordpress"

  if $ensure != absent {

    ppext::module { $module : modinf => $modinf }
    ->
    wordpress::prereqs { $name :
      modinf => $modinf,
      paths => $paths,
    }
    ->
    wordpress::install_files { $name :
      modinf => $modinf,
      paths => $paths,
      downloadURL => $downloadURL,
      unpackDir => $unpackDir,
    }
    ->
    wordpress::config_files  { $name :
      modinf => $modinf,
      dbinf => $dbinf,
      paths => $paths,
      options => $options,
    }
    ->
    wordpress::init_database { $name :
      modinf => $modinf,
      paths => $paths,
      r_privconnect => $r_privconnect,
      r_connect => $r_connect,
      dbinf => $dbinf,
      options => $options,
    }
    ->
    wordpress::test { $name :
      modinf => $modinf,
      testURL => $testURL,
      siteName => $options[siteName],
    }
    ->
    wordpress::backup { $name:
      modinf => $modinf,
      paths => $paths,
      r_dump => $r_dump,
      dbinf => $dbinf,
    }

  } else {

    ppext::module { $module : modinf => $modinf }
    <-
    wordpress::prereqs { $name :
      modinf => $modinf,
      paths => $paths,
    }
    <-
    wordpress::uninstall { $name :
      modinf => $modinf,
      dbinf => $dbinf,
      paths => $paths,
      r_privconnect => $r_privconnect,
    }

    # Doesn't remove backups
  }
}
