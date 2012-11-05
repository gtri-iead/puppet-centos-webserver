node default {
  include bash, ppext
  
  class { 'samba_devel' :
    version => '*',
    ensure => latest,
    smbWorkGroup => 'WORKGROUP',
    smbRemotePassword => 'password',
    smbServerName => 'devbox',
  }
}
