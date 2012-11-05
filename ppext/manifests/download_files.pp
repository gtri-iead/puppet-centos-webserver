define ppext::download_files(
  $modinf,

  $downloadURL,
  $unpackDir,
  $destpath,
  $owner = root,
  $group = root,
  $creates
) {

  $module = $modinf[name]
 
  if $modinf[ensure] != absent {
    
    $r_bashfile = {
      name => "${module}::download_files",
      resname => 'download_files',
      modinf => $modinf,
    }
    ppext::download_files_bashfile { $r_bashfile[name] :
      resinf => $r_bashfile,
    
      downloadURL => $downloadURL,
      unpackDir => $unpackDir,
      destpath => $destpath,
      owner => $owner,
      group => $group,
    }
    ->
    ppext::execbash { $r_bashfile[name]:
      modinf => $modinf,
 
      r_bashfile => $r_bashfile,
 
      expected_outregex => template("ppext/download_files.expected.regex.erb"),
      creates => $creates,
    }
    
  }
}
