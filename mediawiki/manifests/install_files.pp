define mediawiki::install_files($modinf,$paths, $downloadURL, $unpackDir) {

  $version = $modinf[version]
  $module = $modinf[name]

  File { owner => root, group => root, mode => 644 }

  if !defined(File[$paths[basepath]]) {
    file { $paths[basepath] :
      ensure => directory,
      mode => 755,
    }
  }
  
  file { $paths[destpath]:
    ensure => directory,
    mode => 755,
    require => File[$paths[basepath]],
  }
  ->
  file { $paths[redirect_phpfile] :
    content => '<?php header( \'Location: http://\' . $_SERVER[\'SERVER_NAME\'] . \'/w/\' ) ;',
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
