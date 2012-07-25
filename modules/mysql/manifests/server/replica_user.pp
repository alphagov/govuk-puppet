define mysql::server::replica_user($root_password, $host, $password, $remote_host='%') {
  $user = 'replica_user'
  exec { "$name":
    unless  => "/usr/bin/mysql -h ${host} -u${user} -p'${password}' ${name}",
    command => "/usr/bin/mysql -h ${host} -uroot -p'${root_password}' -e \"grant SUPER, REPLICATION CLIENT, REPLICATION SLAVE on *.* to ${user}@'${remote_host}' identified by '$password'; flush privileges;\"",
    require => [
      Class['mysql::server'],
      Exec["create-${name}-db"]
    ],
  }
}