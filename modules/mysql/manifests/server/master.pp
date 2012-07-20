class mysql::server::master ($database, $user, $password, $host, $root_password, $remote_host='%') {
  class { 'mysql::server':
    root_password=> $root_password
  }
  db{"$database":
    user          => $user,
    password      => $password,
    host          => $host,
    root_password => $root_password,
    remote_host   => $remote_host
  }
}
