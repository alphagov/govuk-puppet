class govuk::node::s_mysql_slave inherits govuk::node::s_base {
  $root_password = extlookup('mysql_root', '')

  class { 'mysql::server':
    root_password       => $root_password,
    tmp_table_size      => '256M',
    max_heap_table_size => '256M',
  }
  include mysql::server::slave

  #REMOVE: once deployed to production can be removed.
  package { 'automysqlbackup': ensure => purged }

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }
}
