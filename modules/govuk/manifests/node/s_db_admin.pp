# == Class: Govuk_Node::S_db_admin
#
# This machine class is used to administer RDS instances.
#
class govuk::node::s_db_admin {
  include ::govuk::node::s_base

  $packages = [
    'postgresql-client-9.3',
    'mysql-client-5.5',
  ]

  package { $packages:
    ensure =>  present,
  }
}
