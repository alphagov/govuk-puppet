# == Class: govuk::apps::content_data_api::db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
class govuk::apps::content_data_api::db (
  $password = undef,
) {
  govuk_postgresql::db { 'content_performance_manager_production':
    user       => 'content_performance_manager',
    password   => $password,
    rds        => true,
    extensions => ['plpgsql'],
  }
}
