define postgres::exec(
  $command = $title,
  $host = '',
  $username = 'postgres',
  $password = '',
  $database = 'postgres',
  $unless = undef
) {

  $pg_environ = [
    "PGUSER=${username}",
    "PGDATABASE=${database}"
  ]

  # My *GOD* Puppet's DSL can be infuriating sometimes...

  if $password != '' {
    $pg_environ_pw = [ $pg_environ, "PGPASSWORD=${password}" ]
  } else {
    $pg_environ_pw = $pg_environ
  }

  if $host != '' {
    $pg_environ_pw_host = [ $pg_environ_pw, "PGHOST=${host}" ]
  } else {
    $pg_environ_pw_host = $pg_environ_pw
  }

  exec { $title:
    user        => 'postgres',
    environment => $pg_environ_pw_host,
    command     => $command,
    unless      => $unless,
    require     => Class['postgres::service'],
  }

}
