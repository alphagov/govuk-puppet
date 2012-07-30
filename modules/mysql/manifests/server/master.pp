define mysql::server::master ($database, $user, $password, $host, $root_password, $replica_password, $remote_host='%') {
  db{"$database":
    user          => $user,
    password      => $password,
    host          => $host,
    root_password => $root_password,
    remote_host   => $remote_host,
  }
  replica_user { "$database":
    host           => $host,
    root_password  => $root_password,
    remote_host    => $remote_host,
    password       => $replica_password,
  }
}