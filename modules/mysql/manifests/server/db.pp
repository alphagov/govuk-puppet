define mysql::server::db($user, $password, $host, $root_password, $remote_host='%') {

  case $password {
    '': {
        $passarg = ''
    }
    default: {
        $passarg = "-p'${password}'"
    }
  }

  case $root_password {
    '': {
        $rootpassarg = ''
    }
    default: {
        $rootpassarg = "-p'${root_password}'"
    }
  }


  exec { "create-${name}-db":
    unless  => "/usr/bin/mysql -h ${host} -uroot ${rootpassarg} -e 'use ${name}'",
    command => "/usr/bin/mysql -h ${host} -uroot ${rootpassarg} -e \'create database ${name};\'",
    require => Class['mysql::server'],
  }

  exec { "grant-${name}-db":
    unless  => "/usr/bin/mysql -h ${::ipaddress} -u${user} ${passarg} ${name}",
    command => "/usr/bin/mysql -h ${host} -uroot ${rootpassarg} -e 'grant all on ${name}.* to ${user}@\"${remote_host}\" identified by \"$password\"; flush privileges;'",
    require => [
      Class['mysql::server'],
      Exec["create-${name}-db"]
    ],
  }

}
