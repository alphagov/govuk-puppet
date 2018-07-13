# == Class: govuk::apps::content_publisher::db
#
# === Parameters
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
# [*rds*]
#   Whether to use RDS i.e. when running on AWS
#
class govuk::apps::content_publisher::db (
  $backend_ip_range = '10.3.0.0/16',
  $rds = false,
) {
  govuk_postgresql::db { $govuk::apps::content_publisher::db_name:
    user                    => $govuk::apps::content_publisher::db_username,
    password                => $govuk::apps::content_publisher::db_password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
  }
}
