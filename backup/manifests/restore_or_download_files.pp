define backup::restore_or_download_files(
  $modinf,
  
  $downloadURL,
  $unpackDir,
  $owner = root,
  $group = root,
  $destpath,
  
  $creates
) {

  $module = $modinf[name]

  $r_bashfile = {
    name => "${module}::restore_or_download_files",
    resname => "restore_or_download_files",
    modinf => $modinf,
  }
  
  backup::restore_or_download_files_bashfile { $r_bashfile[name] :
    resinf => $r_bashfile,
    
    downloadURL => $downloadURL,
    unpackDir => $unpackDir,
    owner => $owner,
    group => $group,
    destpath => $destpath,
  }
  ->
  ppext::execbash { $r_bashfile[name] :
    modinf => $modinf,
    r_bashfile => $r_bashfile,
    creates => $creates,
  }
}  
