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
    unless  => "/usr/bin/mysql -u${username} ${userpassarg} ${dbarg}",
    command => "/usr/bin/mysql -uroot ${rootpassarg} -e 'grant ${privileges} on ${db}.* to \"${username}\"@\"${remote_host}\" identified by \"$user_password\"; flush privileges;'",
    require => Class['mysql::server'],
  }
}
