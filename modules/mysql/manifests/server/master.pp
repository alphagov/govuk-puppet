class mysql::server::master ($database, $user, $password, $host, $root_password, $replica_password, $remote_host='%') {
  $master_server_id = '1'
  class { 'mysql::server':
    root_password => $root_password,
    server_id     => $master_server_id
  }
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