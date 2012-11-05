class maven::install_files(
  $modinf,
  $mvnpath,
  $downloadURL,
  $unpackDir
) {

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

  $linkEnsure = $ensure ? { default => link, absent => absent }
  
  file { $mvnpath :
    ensure => $dirEnsure,
    mode => 755,
  }
  ->
  ppext::download_files { "maven::download_files" :
    modinf => $modinf,
    downloadURL => $downloadURL,
    unpackDir => $unpackDir,
    destpath => $mvnpath,
    creates => "$mvnpath/bin/mvn",
  }
  ->
  # Make mvn and mvnDebug executable
  file { "$mvnpath/bin/mvn" :
    mode => 755,
  }
  ->
  file { "$mvnpath/bin/mvnDebug" :
    mode => 755,
  }
  ->   
  # Link the maven executable into /usr/bin
  file { $params::mvn_linkfile:
    ensure => $linkEnsure,
    target => "$mvnpath/bin/mvn",
  }
}
