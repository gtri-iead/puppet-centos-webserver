class basics::install_packages($ensure) {

  Package { ensure => $ensure }
  
  package { 'wget': name => $params::pkgs[wget] }

  package { 'nano': name => $params::pkgs[nano] } 
  package { 'emacs': name => $params::pkgs[emacs] }
  package { 'gcc': name => $params::pkgs[gcc] }
  package { 'make': name => $params::pkgs[make] }
  package { 'unzip': name => $params::pkgs[unzip] }
  package { 'sudo': name => $params::pkgs[sudo] }
  package { 'vim-enhanced': name => $params::pkgs[vim-enhanced] }
  package { 'bind-utils': name => $params::pkgs[bind-utils] }

}
