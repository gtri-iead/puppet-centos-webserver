class samba_devel::config_files($modinf, $smbWorkGroup,$smbServerName) {
  
  $module = $modinf[name]
  $ensure = $modinf[ensure]
  
  # START PATTERN file_defaults
  $dirEnsure = $ensure ? { default => directory, absent => absent }
  $fileEnsure = $ensure ? { default => present, absent => absent }

  File {
    force => true,
    ensure => $fileEnsure,
    owner => root,
    group => root,
    mode => 644,
  }
  #END PATTERN
    
  file { $params::smb_conffile:
    content => template('samba_devel/smb.conf.erb'),
  }
  
}
