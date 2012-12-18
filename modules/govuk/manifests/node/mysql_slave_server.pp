class govuk::node::mysql_slave_server inherits govuk::node::base {
  $root_password = extlookup('mysql_root', '')
  $replica_password = extlookup('mysql_replica_password', '')

  include mysql::backup

  class { 'mysql::server':
    root_password => $root_password,
  }
  include mysql::server::slave

}
