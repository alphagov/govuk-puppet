class mysql::server::config{

  file { '/etc/mysql/my.cnf':
    ensure  => 'link',
    target  => '/var/lib/mysql/my.cnf',
    require => File['/var/lib/mysql/my.cnf'],
  }

}