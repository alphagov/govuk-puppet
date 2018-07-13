# == Class: govuk::apps::content_publisher::db
#
# === Parameters
#
# [*user*]
#   The DB instance user.
#
# [*password*]
#   The DB instance password.
#
# [*hostname*]
#   The DB instance hostname.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
# [*rds*]
#   Whether to use RDS i.e. when running on AWS
#
class govuk::apps::content_publisher::db (
  $user = 'content_publisher',
  $hostname,
  $password,
  $backend_ip_range = '10.3.0.0/16',
  $rds = false,
) {
  govuk_postgresql::db { "${user}_production":
    user                    => $user,
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
  }

  if $::govuk_node_class !~ /^development$/ {
    govuk::app::envvar::database_url { $app_name:
      type     => 'postgresql',
      username => $user,
      password => $password,
      host     => $hostname,
      database => "${user}_production"
    }
  }
}
