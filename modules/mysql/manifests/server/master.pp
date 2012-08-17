define mysql::server::master ($user, $password, $host, $root_password, $replica_password, $database=$title, $remote_host='%') {
  db { $database:
    user          => $user,
    password      => $password,
    host          => $host,
    root_password => $root_password,
    remote_host   => $remote_host,
  }
}
