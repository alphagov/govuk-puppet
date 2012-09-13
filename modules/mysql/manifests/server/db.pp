define mysql::server::db($user, $password, $root_password, $remote_host='%') {
  case $root_password {
    '': {
        $rootpassarg = ''
    }
    default: {
        $rootpassarg = "-p'${root_password}'"
    }
  }

  exec { "create-${name}-db":
    unless  => "/usr/bin/mysql -uroot ${rootpassarg} -e 'use ${name}'",
    command => "/usr/bin/mysql -uroot ${rootpassarg} -e \'create database ${name};\'",
    require => Class['mysql::server'],
  }

  mysql::user {"${user}_on_${name}":
    root_password => $root_password,
    user_password => $password,
    remote_host   => $remote_host,
    db            => $name,
    require       => Exec["create-${name}-db"],
  }
}
