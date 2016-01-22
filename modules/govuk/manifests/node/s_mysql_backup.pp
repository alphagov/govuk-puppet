# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_mysql_backup inherits govuk::node::s_base {
  $root_password = hiera('mysql_root', '')

  class { 'backup::mysql':
    mysql_dump_password => $root_password,
    require             => Govuk_mount['/var/lib/automysqlbackup'],
  }

  class { 'govuk_mysql::server':
    root_password       => $root_password,
  }
  include govuk_mysql::server::slave

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  Govuk_mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
}
