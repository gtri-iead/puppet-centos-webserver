class developer::params {

  include paths, php::params

  $xdebug_php_inifile = "$php::params::php_d_path/xdebug.ini"

  $pkgs = {
    git => 'git',
    subversion => 'subversion',
    ruby => 'ruby',
    rubygems => 'rubygems',
    php-pecl-xdebug => 'php-pecl-xdebug',
  }                       
}
