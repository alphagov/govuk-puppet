class mysql::server::service {
  service { 'mysql':
    ensure     => running,
    status     => '/etc/init.d/mysql status | grep "mysql start"'
  }
}
