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

class samba_devel($version, $ensure, $smbWorkGroup, $smbRemotePassword, $smbServerName) {

  include samba_devel::params

  # PATTERN BEGIN init_modinf_from_params
  $module = $params::module
  $modinf = {
    name => $module,
    ensure => $ensure,
    version => $version,
    versions => $versions,
    logpath => $params::modinf[logpath],
    logfile => $params::modinf[logfile],
    pwdpath => $params::modinf[pwdpath],
    binpath => $params::modinf[binpath],
    outpath => $params::modinf[outpath],
    flagpath => $params::modinf[flagpath],
    filespath => $params::modinf[filespath],
  }
  #END PATTERN

  if $ensure != absent {
    
    # TODO: This samba configuration doesnt work right
    ppext::module { $module : modinf => $modinf }
    ->
    class { 'samba_devel::install_packages' : modinf => $modinf }
    ->
    class { 'samba_devel::config_files' :
      modinf => $modinf,
      smbWorkGroup => $smbWorkGroup,
      smbServerName => $smbServerName,
    }
    ->
    class { 'samba_devel::init_smb_user' :
      modinf => $modinf,
      smbRemotePassword => $smbRemotePassword,
    }
    ->
    class {'samba_devel::service' : }

    File[$params::smb_conffile] ~> Service['samba']
    
  } else {

    ppext::module { $module : modinf => $modinf }
    <-
    class { 'samba_devel::install_packages' : modinf => $modinf }
    <-
    class { 'samba_devel::config_files' :
      modinf => $modinf,
      smbWorkGroup => $smbWorkGroup,
      smbServerName => $smbServerName,
    }
    <-
    class { 'samba_devel::init_smb_user' :
      modinf => $modinf,
      smbRemotePassword => $smbRemotePassword,
    }
          
  }
}
