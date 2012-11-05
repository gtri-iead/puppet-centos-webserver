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
