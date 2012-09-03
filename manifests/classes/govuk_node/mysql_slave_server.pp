class govuk_node::mysql_slave_server inherits govuk_node::base {
  $root_password = extlookup('mysql_root', '')
  $replica_password = extlookup('mysql_replica_password', '')

  class { 'mysql::server':
    root_password => $root_password,
    server_id     => $::mysql_server_id,
    config_path   => 'mysql/slave/my.cnf'
  }
}
