define mysql::user ($root_password, $user_password, $username=$title, $remote_host='%', $db='*', $privileges='all') {
  case $user_password {
    "": {
        $userpassarg = ""
    }
    default: {
        $userpassarg = "'-p${user_password}'"
    }
  }

  case $root_password {
    "": {
        $rootpassarg = ""
    }
    default: {
        $rootpassarg = "'-p${root_password}'"
    }
  }

  case $db {
    "*": {
        $dbarg = ""
    }
    default: {
        $dbarg = "'${db}'"
    }
  }

  exec { "create_mysql_user_${title}":
    unless  => "/usr/bin/mysql -u${username} ${userpassarg}",
    command => "/usr/bin/mysql -uroot ${rootpassarg} -e 'FLUSH PRIVILEGES; CREATE USER \"${username}\"@\"${remote_host}\" IDENTIFIED BY \"$user_password\"; FLUSH PRIVILEGES;'",
    require => Class['mysql::server'],
  }

  exec { "create_mysql_database_${db}_for_${title}":
    unless  => "/usr/bin/mysql -u${username} ${userpassarg} ${dbarg}",
    command => "/usr/bin/mysql -uroot ${rootpassarg} -e 'GRANT ${privileges} PRIVILEGES ON ${db}.* TO \"${username}\"@\"${remote_host}\" WITH GRANT OPTION; FLUSH PRIVILEGES;'",
    require => [Class['mysql::server'], Exec["create_mysql_user_${title}"]],
  }
}
