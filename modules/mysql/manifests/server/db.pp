define mysql::server::db($user, $password, $host, $root_password, $remote_host='%') {
  exec { "create-${name}-db":
    unless  => "/usr/bin/mysql -h ${host} -uroot -p${root_password} -e 'use ${name}'",
    command => "/usr/bin/mysql -h ${host} -uroot -p${root_password} -e \'create database ${name};\'",
    require => Class['mysql::server'],
  }

  exec { "grant-${name}-db":
    unless  => "/usr/bin/mysql -h ${host} -u${user} -p'${password}' ${name}",
    command => "/usr/bin/mysql -h ${host} -uroot -p'${root_password}' -e \"grant all on ${name}.* to ${user}@'${remote_host}' identified by '$password'; flush privileges;\"",
    require => [
      Class['mysql::server'],
      Exec["create-${name}-db"]
    ],
  }
}