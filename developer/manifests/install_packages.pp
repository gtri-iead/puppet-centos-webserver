class developer::install_packages($ensure) {

  Package { ensure => $ensure }

  package { ruby : name => $params::pkgs[ruby] }
  package { git : name => $params::pkgs[git] }
  package { subversion : name => $params::pkgs[subversion] }
  package { rubygems : name => $params::pkgs[rubygems] }
  package { php-pecl-xdebug : name => $params::pkgs[php-pecl-xdebug] }
  
}
