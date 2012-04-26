define mysql::server::db($user, $password, $host) {
  exec { "create-${name}-db":
    unless  => "/usr/bin/mysql -h ${host} -uroot -p${mysql_password} ${name}",
    command => "/usr/bin/mysql -h ${host} -uroot -p${mysql_password} -e \'create database ${name};\'",
    require => Service['mysql'],
  }

  exec { "grant-${name}-db":
    unless  => "/usr/bin/mysql -h ${host} -u${user} -p${password} ${name}",
    command => "/usr/bin/mysql -h ${host} -uroot -p${mysql_password} -e \"grant all on ${name}.* to ${user}@'${host}' identified by '$password'; flush privileges;\"",
    require => [
      Service['mysql'],
      Exec["create-${name}-db"]
    ],
  }
}

