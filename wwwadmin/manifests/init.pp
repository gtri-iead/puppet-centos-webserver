define wwwadmin(
  $ensure,
  $versions,
  $destpath, # => '/var/www/html/admin',
  $basedir, # => 'admin',
  $apache_confpath, # => '/etc/httpd/conf.d',
  $destURL # => 'http://localhost/admin',
) {

  include wwwadmin::params, ppext::params, apache::params

  $module = "wwwadmin-$name"
  $modinf = {
    name => $module,
    ensure => $ensure,
    version => $version,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }

  $paths = {
    destpath => $destpath,
    basedir => $basedir,
    index_htmlfile => "$destpath/index.html",
    apache_conffile => "$apache_confpath/wwwadmin-$name.conf",
    phpinfo_phpfile => "$destpath/phpinfo.php",
  }
        
  if $ensure != absent {

    ppext::module { $module : modinf => $modinf }
    ->
    wwwadmin::prereqs { $name : modinf => $modinf }
    ->
    wwwadmin::config_files { $name:
      modinf => $modinf,
      paths => $paths,
    }
    
    if $versions[phpmyadmin] != absent {
      phpmyadmin { $name :
        version => $versions[phpmyadmin],
        ensure => $ensure,
        destpath => "$destpath/phpmyadmin",
        testURL => "$destURL/phpmyadmin/",
        require => Wwwadmin::Config_files[$name],
      }
    }
    
    if $versions[phppgadmin] != absent {
      phppgadmin { $name :
        version => $versions[phppgadmin],
        ensure => $ensure,
        destpath => "$destpath/phppgadmin",
        testURL => "$destURL/phppgadmin/",
       require => Wwwadmin::Config_files[$name],
      }
    }
    
  } else {

    ppext::module { $module : modinf => $modinf }
    <-
    wwwadmin::prereqs { $name : modinf => $modinf }
    <-
    wwwadmin::config_files { $name:
      modinf => $modinf,
      paths => $paths,
    }
    # <- same here
    phpmyadmin { $name :
      version => $versions[phpmyadmin],
      ensure => $ensure,
      destpath => "$destpath/phpmyadmin",
      testURL => "$destURL/phpmyadmin/",
    }
    # <- TODO: this causes a cyclical dependency
    phppgadmin { $name :
      version => $versions[phppgadmin],
      ensure => $ensure,
      destpath => "$destpath/phppgadmin",
      testURL => "$destURL/phppgadmin/"
    }
                                
  }
}
