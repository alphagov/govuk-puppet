# == Class: govuk::apps:contacts:db
#
# MySQL to store content for the Contacts Admin app
# https://github.com/alphagov/contacts-admin
#
# === Parameters
#
# [*mysql_contacts_admin*]
#   The DB user password.
#
class govuk::apps::contacts::db (
  $mysql_contacts_admin = '',
){
  mysql::db { 'contacts_production':
    user     => 'contacts',
    host     => '%',
    password => $mysql_contacts_admin,
  }
}
