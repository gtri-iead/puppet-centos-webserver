class tomcat::prereqs($modinf,$paths) {

  if $modinf[ensure] != absent {
    Class['java'] -> Class['tomcat::prereqs']
    Class['log4j'] -> Class['tomcat::prereqs']
    # TODO: puppet bug, on initial install this causes a cascading failure by forcing tomcat to restart seconds after it is initially started
#    File[$paths[tomcat_users_xmlfile]] ~> Service['tomcat']
  } else {
    Class['java'] <- Class['tomcat::prereqs']
    Class['log4j'] <- Class['tomcat::prereqs']
  }
}
