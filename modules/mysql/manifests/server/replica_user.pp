class mysql::server::replica_user($root_password, $host, $password, $remote_host='%') {
  $user = 'replica_user'

  exec { 'create_replica_user':
    unless  => "/usr/bin/mysql -h ${host} -u${user} -p'${password}'",
    command => "/usr/bin/mysql -h ${host} -uroot -p'${root_password}' -e \"grant SUPER, REPLICATION CLIENT, REPLICATION SLAVE on *.* to ${user}@'${remote_host}' identified by '$password'; flush privileges;\"",
  }
}
