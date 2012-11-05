define wordpress::install_files($modinf,$paths, $downloadURL, $unpackDir) {

  $version = $modinf[version]
  $module = $modinf[name]

  File { owner => root, group => root, mode => 644 }

  file { $paths[destpath]:
    ensure => directory,
    mode => 755,
  }
  ->
  backup::restore_or_download_files { "${module}::restore_or_download_files":
    modinf => $modinf,

    downloadURL => $downloadURL ,
    unpackDir => $unpackDir,
    destpath => $paths[destpath],

    creates => $paths[install_flag_path],
  }
  
}
