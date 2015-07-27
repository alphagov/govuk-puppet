# == Class: govuk::apps::content_register::db
#
# Database credentials for the content register API.
# Read more: https://github.com/alphagov/content-register
#
# === Parameters
#
# [*password*]
#   Password used to access the content register database.
#
# [*backend_ip_range*]
#   API IP addresses to allow access to the database.
#
class govuk::apps::content_register::db (
  $password,
  $backend_ip_range = '10.3.0.0/16',
) {
  govuk_postgresql::db { 'content-register_production':
    user                    => 'content-register',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
  }
}
