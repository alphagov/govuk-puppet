class mysql::server::slave ($database, $user, $password, $host, $root_password, $master_host, $slave_server_id, $remote_host='%') {
  class { 'mysql::server':
    root_password => $root_password,
    server_id     => $slave_server_id,
    config_path   => 'mysql/slave/my.cnf'
  }

  Class['mysql::server'] -> Db["$database"]
  db{"$database":
    user          => $user,
    password      => $password,
    host          => $host,
    root_password => $root_password,
    remote_host   => $remote_host,
}
}
