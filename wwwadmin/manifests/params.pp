class wwwadmin::params {
  include apache::params

  $index_htmlfile = "$destpath/index.html"
  $apache_conffile = "$apache::params::conf_d_path/wwwadmin-$name.conf"
  $phpinfo_phpfile = "$destpath/phpinfo.php"                  

}
