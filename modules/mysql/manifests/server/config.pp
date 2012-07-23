class mysql::server::config($server_id='1'){
  file { '/etc/mysql/my.cnf':
    owner    => 'mysql',
    group    => 'mysql',
    content  => template('mysql/my.cnf'),
    notify   => Service['mysql'],
    require  => File['/var/lib/mysql'],
  }
}