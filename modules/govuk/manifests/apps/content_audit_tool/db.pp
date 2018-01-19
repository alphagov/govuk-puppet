# == Class: govuk::apps::content_audit_tool::db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
# [*backend_ip_range*]
#   Backend IP addresses to allow access to the database.
#
class govuk::apps::content_audit_tool::db (
  $password,
  $backend_ip_range = undef,
  $rds = false,
) {
  govuk_postgresql::db { 'content_audit_tool_production':
    user                    => 'content_audit_tool',
    password                => $password,
    allow_auth_from_backend => true,
    backend_ip_range        => $backend_ip_range,
    rds                     => $rds,
  }
}
