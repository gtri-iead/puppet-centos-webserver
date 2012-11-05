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

define wordpress::init_database($modinf, $paths, $r_privconnect, $r_connect, $dbinf, $options) { 

  $module = $modinf[name]

  $wpSiteName = $options[siteName]
  $wpSiteURL = $options[siteURL]
  $wpSiteHome = $options[siteURL]
  
#  $wpLang = $options[lang]
  $wpUserName = $options[user][username]
  $wpUserNiceName = $options[user][nicename]
  $wpUserDisplayName = $options[user][displayname]
  $wpUserEmail = $options[user][email]
  $wpUserNickName = $options[user][nickname]


  file { $paths[init_dbcontent_sqlfile]:
    content => template("wordpress/$version/init_dbcontent.sql.erb"),
#    source => "puppet:///modules/wordpress/$version/init_dbcontent.sql",
    owner => root,
    group => root,
    mode => 600,
  }
  ->
  ppdb::connect { $r_privconnect[name]:
    resinf => $r_privconnect,
  }
  ->
  ppdb::connect { $r_connect[name]:
    resinf => $r_connect,
  }
  ->
  ppext::notifyonce { "${module}::initialize" : modinf => $modinf, }
  ~>
  ppdb::initialize_database { "${module}::initialize_database" :
    modinf => $modinf,
    
    r_connect => $r_privconnect,

    
    newDbName => $dbinf[database],

    userinf => $dbinf[user],
    
    refreshonly => true,
  }
  ~>
  backup::restore_or_initialize_dbcontent { "${module}::restore_or_initialize_dbcontent":
    modinf => $modinf,

    r_connect => $r_connect,
    
    init_dbcontent_sqlfile => $paths[init_dbcontent_sqlfile],
    
    refreshonly => true,
  }
    
}
                                            
