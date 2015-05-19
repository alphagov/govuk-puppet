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
class govuk::apps::content_register::db (
  $password,
) {
  govuk_postgresql::db { 'content-register_production':
    user                    => 'content-register',
    password                => $password,
    allow_auth_from_backend => true,
  }
}
