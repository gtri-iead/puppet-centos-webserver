class imagemagick::params {

  include paths#, ppext::params

  $module = 'imagemagick'
  $modinf = {
    name => $module,
    logpath => $ppext::params::logpath,
    logfile => "$ppext::params::logpath/${module}.log",
    pwdpath => $ppext::params::pwdpath,
    binpath => "$ppext::params::binpath/$module/bin",
    outpath => "$ppext::params::outpath/$module/results",
    flagpath => "$ppext::params::flagpath/$module/flags",
    filespath => "$ppext::params::filespath/$module",
  }

  $pkg_imagemagick = 'ImageMagick'
  
  $CONVERT = "$paths::usr_bin/convert"
}
