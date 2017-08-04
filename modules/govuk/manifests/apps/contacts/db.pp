# == Class: govuk::apps:contacts:db
#
# MySQL to store content for the Contacts app
# https://github.com/alphagov/contacts-admin
#
# === Parameters
#
# [*password*]
#   The DB user password.
#
class govuk::apps::contacts::db (
  $mysql_contacts_admin = '',
  $mysql_contacts_frontend =  '',
){
  govuk_mysql::db { 'contacts_production':
    user     => 'contacts',
    host     => '%',
    password => $mysql_contacts_admin,
  }

  govuk_mysql::user { 'contacts_fe@%':
    password_hash => mysql_password($mysql_contacts_frontend),
    table         => 'contacts_production.*',
    privileges    => ['SELECT'],
  }
}
