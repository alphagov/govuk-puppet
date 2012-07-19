class mysql::server::service {
  service { 'mysql':
    ensure     => running,
    enable     => true,
    status     => '/etc/init.d/mysql status | grep "mysql start"'
  }
}