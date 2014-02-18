class govuk::node::s_mysql_slave inherits govuk::node::s_base {
  $root_password = extlookup('mysql_root', '')

  class { 'govuk_mysql::server':
    root_password       => $root_password,
    tmp_table_size      => '256M',
    max_heap_table_size => '256M',
  }
  include govuk_mysql::server::slave

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  #FIXME: remove if when we have moved to platform one
  if hiera(use_hiera_disks,false) {
    Govuk::Mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
  }
}
