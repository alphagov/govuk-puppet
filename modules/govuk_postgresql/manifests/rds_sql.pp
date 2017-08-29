# == Define Govuk_postgresql::Rds_sql
#
# In Amazon RDS, an admin role is created to manage databases and roles. To create
# a database owned by a specified role, the admin role must have membership of the
# role you're trying to assign.
#
# This defined type attempts to solve this issue.
#
# === Parameters
#
# [*title*]
#   The title of the defined type is the role that must be assigned to the admin
#   user.
#
# [*rds_root_user*]
#   The name of the RDS admin user.
#
# [*default_db*]
#   The default database to connect to when using psql.
#   Default: postgres
#
# [*connect_settings*]
#   A hash of connect settings when managing remote databases. For RDS, this is
#   always required and should be passed in elsewhere when working with the
#   Puppetlabs postgresql module.
#
define govuk_postgresql::rds_sql (
  $rds_root_user,
  $default_db = 'postgres',
  $connect_settings = $postgresql::server::default_connect_settings,
) {

  Postgresql_psql {
    db               => $default_db,
    connect_settings => $connect_settings,
  }

  postgresql_psql {"GRANT \"${title}\" TO \"${rds_root_user}\"":
    unless => "SELECT r.rolname,r1.rolname FROM pg_catalog.pg_roles r JOIN pg_catalog.pg_auth_members m ON (m.member = r.oid) JOIN pg_roles r1 ON (m.roleid=r1.oid) WHERE r.rolcanlogin AND r.rolname='${rds_root_user}' AND r1.rolname='${title}'",
  }
}
