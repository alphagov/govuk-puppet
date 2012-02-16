class mysql::backup {
  package { "automysqlbackup": ensure => installed }
  file { "/etc/default/automysqlbackup":
    owner => root,
    group => root,
    require => Package["automysqlbackup"],
    source => "puppet:///modules/mysql/automysqlbackup"
  }
}

class mysql::client {
  package { ["mysql-client","libmysqlclient-dev"]:
    ensure => installed,
  }
}

class mysql::server inherits mysql::client {
  package { ["mysql-server","automysqlbackup"]:
    ensure => installed,
  }

  service { "mysql":
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package["mysql-server"],
  }

  cron { "daily sql tarball":
    ensure => present,
    command => "for d in `find /var/lib/automysqlbackup/daily -mindepth 1 -maxdepth 1 -type d`; do ls -1tr $d/* | tail -1; done | sudo xargs tar cf /var/lib/automysqlbackup/daily.tar 2>/dev/null",
    user => 'root',
    minute => 13,
    hour => 4,
    require => Service["mysql"]
  }

  file { "/var/lib/mysql/my.cnf":
    owner   => "mysql",
    group   => "mysql",
    source  => "puppet:///modules/mysql/my.cnf",
    notify  => Service["mysql"],
    require => Package["mysql-server"],
  }

  file { "/etc/mysql/my.cnf":
    require => File["/var/lib/mysql/my.cnf"],
    notify  => Service["mysql"],
    ensure  => "/var/lib/mysql/my.cnf",
  }

  exec { "set-mysql-password":
    unless  => "/usr/bin/mysqladmin -uroot -p${mysql_password} status",
    path    => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password ${mysql_password}",
    require => Service["mysql"],
  }

  define db($user, $password, $host) {
    exec { "create-${name}-db":
      unless  => "/usr/bin/mysql -h ${host} -uroot -p${mysql_password} ${name}",
      command => "/usr/bin/mysql -h ${host} -uroot -p${mysql_password} -e \"create database ${name};\"",
      require => Service["mysql"],
    }

    exec { "grant-${name}-db":
      unless  => "/usr/bin/mysql -h ${host} -u${user} -p${password} ${name}",
      command => "/usr/bin/mysql -h ${host} -uroot -p${mysql_password} -e \"grant all on ${name}.* to ${user}@'${host}' identified by '$password'; flush privileges;\"",
      require => [Service["mysql"], Exec["create-${name}-db"]],
    }
  }
}
