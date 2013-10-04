class govuk::node::s_mysql_backup inherits govuk::node::s_base {
  $root_password = extlookup('mysql_root', '')

  class { 'mysql::server':
    root_password       => $root_password,
  }
  include mysql::server::slave

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }
}
