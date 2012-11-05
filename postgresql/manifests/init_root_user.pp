class postgresql::init_root_user($modinf, $rootUserPassword) {

  $PSQL = $params::PSQL
  
  # This is intentionally done not using runsql to remove dependencies, so it requires running as postgres user
  ppext::execonce { 'postgresql::init_root_user' :
    modinf => $modinf,
    input => "CREATE USER root WITH CREATEUSER CREATEDB ENCRYPTED PASSWORD '$rootUserPassword';\n",
    command => "$PSQL -a",
    user => postgres,
    expected_outregex => template("postgresql/initialize.expected.regex.erb"),
  }      

}
