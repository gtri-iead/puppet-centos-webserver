class samba_devel::service {
  service { 'samba' :
    name => 'smb',
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
  }
}
