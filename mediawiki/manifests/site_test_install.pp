node default {
  include bash,ppext,ppdb

  $ensure = installed
  $password = file("/etc/puppet/passwords/$hostname.pwd")
  
  class { 'backup' :
    dailyBackupCount => 3,
    weeklyBackupCount => 2,
    monthlyBackupCount => 1,
    ensure => installed,
  }
 
  class { 'lampstack' :
    password => $password,
    versions => {
      apache => '2.2.15*',
      mysql => '5.1*',
      php => {
        php => '5.3.3*',
        mcrypt => '5.3.3*',
        #The following modules are virtual resources that can be "realized" later.
        # If they are never realized they are never installed.
        dba => '5.3.3*',
        mysql => '5.3.3*',
        pgsql => '5.3.3*',
        pear => '1.9*',
        pecl-apc => '3.1*',
        pecl-memcache => '3.0*',
      },
      perl => {
        perl => '5.10*',
        mod_perl => '*',
      },
    },
    ensure => latest,
  }
                                            
  
  class { 'imagemagick' :
    version => '*',
    ensure => latest,
  }

  apache::alias { $hostname:
    ensure => $ensure,
    aliasURL => '/wiki',
    destpath => '/var/www/html/w/index.php',
  }
  ->
  mediawiki { $hostname :
    version => '1.16.5',
    ensure => $ensure,
    destpath => '/var/www/html',
    useShortURLs => true,
    testURL => 'http://localhost/wiki/Main_Page',
    
    dbinf => {
      type => 'mysql',
      database => 'wikidb',
      privUser => {
        username => 'root',
        #password => 'password',
      },
      server => {
        #host => 'localhost',
        #port => '3306',
      },
      user => {
        username => 'wikidb',
        password => 'password1',
      },
    },
                                    
    
    options =>  {
      siteName => 'TestWiki',
      adminEmail => 'root@localhost',
      anonCannotRegister => true,
      anonCannotRead => true,
      anonCannotEdit => true,
      whiteListRead => [ 'Main_Page' ],
      enableSubpages => true,
      namespacesWithSubpages => 'NS_MAIN',
    },
        
  }

}
