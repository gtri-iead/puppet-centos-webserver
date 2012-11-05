define phpmyadmin::install_files($modinf, $destpath, $unpackDir, $downloadURL) {
       
  $module = $modinf[name]

  $dfname = "${module}::download_files"
  
  file { $destpath :
    ensure => directory,
    mode => 755,
  }
  ->
  ppext::download_files { $dfname:
    modinf => $modinf,
   
    downloadURL => $downloadURL,
    unpackDir => $unpackDir,
    destpath => $destpath,
    creates => "$destpath/index.php",
  }

}
