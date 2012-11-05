<?php
# THIS FILE IS MANAGED BY PUPPET - CHANGES WILL BE OVERRIDEN

function loadLocalSettingsD()
{
  $dirPath="LocalSettings.d";
  
  if(!is_dir($dirPath))
    return;

  $d = dir($dirPath);
  $entry = $d->read();
  while($entry !== false)
    {
      $path = $d->path . '/' . $entry;
      $pathInfo = pathinfo($path);

      if(filetype($path) == 'file' && $pathInfo['extension'] == 'php')
        global_include($path);

      $entry = $d->read();
    }
}

// From http://www.php.net/manual/en/function.include.php#98835
function global_include($script_path) {
  // check if the file to include exists:
  if (isset($script_path) && is_file($script_path)) {
    // extract variables from the global scope:
    extract($GLOBALS, EXTR_REFS);
    ob_start();
    include($script_path);
    return ob_get_clean();
  } else {
    ob_clean();
    trigger_error('The script to parse in the global scope was not found');
  }
}

loadLocalSettingsD();