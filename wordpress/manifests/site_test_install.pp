node default {
  include bash,ppext,ppdb
  
  class { 'backup' :
    dailyBackupCount => 3,
    weeklyBackupCount => 2,
    monthlyBackupCount => 1,
    ensure => installed,
  }
 
  class { 'lampstack' :
    password => 'UOief0833lAXzdr',
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
                                            
  $dbinf = {
    type => 'mysql',
    database => 'wp_test',
   privUser => {
     username => 'root',
#     password => 'password',
   },
   server => {
     host => 'localhost',
     port => '3306',
   },
   user => {
     username => 'wp_test',
     password => 'password1',
   },
  }

  $options = {
    siteName => 'TestBlog',
    siteURL => 'http://countzero/blog',
    lang => '',
    user => {
      username => 'Test',
      nicename => 'test',
      displayname => 'Test',
      nickname => 'Test',
      email => 'test@testytesttestest.org',
    }
  }

  wordpress { 'test' :
    version => '3.3.1',
    ensure => installed,
    targetPath => '/var/www/html/blog',
    testURL => 'http://localhost/blog/',
    
    dbinf => $dbinf,
    
    options => $options,
  }

}
