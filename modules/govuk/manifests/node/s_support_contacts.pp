class govuk::node::s_support_contacts inherits govuk::node::s_base {
  $root_password = extlookup('mysql_root_support_contacts')
  $support_password = extlookup('mysql_support_contacts')

  class { 'mysql::server':
    root_password => $root_password,
  }

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  mysql::server::db {'support_contacts_production':
    user          => 'support_contacts',
    password      => $support_password,
    root_password => $root_password,
  }
}
