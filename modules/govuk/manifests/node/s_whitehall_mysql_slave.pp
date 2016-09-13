# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_whitehall_mysql_slave inherits govuk::node::s_base {
  $root_password = hiera('mysql_root', '')

  class { 'govuk_mysql::server':
    root_password         => $root_password,
    tmp_table_size        => '256M',
    max_heap_table_size   => '256M',
    innodb_file_per_table => true,
    # FIXME
    # Slow query log is turned ON for a short period of analysis.
    slow_query_log        => true,
  }
  include govuk_mysql::server::slave

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  Govuk_mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
}
