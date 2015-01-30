# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_support_contacts (
  $mysql_root_support_contacts,
  $mysql_support_contacts,
) inherits govuk::node::s_base {

  class { 'govuk_mysql::server':
    root_password => $mysql_root_support_contacts,
  }

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  mysql::db {'support_contacts_production':
    user     => 'support_contacts',
    host     => '%',
    password => $mysql_support_contacts,
  }

  class { 'backup::mysql':
    mysql_dump_password => $mysql_root_support_contacts,
    require             => Govuk::Mount['/var/lib/automysqlbackup'],
  }

  Govuk::Mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
}
