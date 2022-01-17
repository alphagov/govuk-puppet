# == Class: govuk_node::s_contacts_admin_db_admin
#
# This machine class is used to administer the Contacts Admin
# MySQL RDS instances.
#
# === Parameters
#
# [*mysql_db_host*]
#  The database hostname
#
# [*mysql_db_password*]
#  The database password
#
# [*mysql_db_user*]
#  The database user to connect to the remote database as
#
class govuk::node::s_contacts_admin_db_admin(
  $mysql_db_host     = undef,
  $mysql_db_password = undef,
  $mysql_db_user     = undef,
) {
  include ::govuk::node::s_base
  include govuk_env_sync
  include ::mysql::client

  file { '/root/.my.cnf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    content => template('govuk/mysql_my.cnf.erb'),
  }

  # The database and user needs manually creating. Read:
  # https://docs.publishing.service.gov.uk/apps/govuk-puppet/create-mysql-db-and-users.html
}
