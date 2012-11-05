define phppgadmin::install_files($modinf, $destpath, $unpackDir, $downloadURL) {

  $module = $modinf[name]
  $ensure = $modinf[ensure]
  $version = $modinf[version]

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

  file { $destpath :
    ensure => $dirEnsure,
    mode => 755,
  }

  $dfname = "${module}::download_files"
  ppext::download_files { $dfname :
    modinf => $modinf,
    downloadURL => $downloadURL,
    unpackDir => $unpackDir,
    destpath => $destpath,
    creates => "$destpath/index.php",
  }

  if $ensure != absent {
    File[$destpath] -> Ppext::Download_files[$dfname] 
  } else {
    File[$destpath] <- Ppext::Download_files[$dfname]
  }
}
