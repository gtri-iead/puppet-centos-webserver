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
