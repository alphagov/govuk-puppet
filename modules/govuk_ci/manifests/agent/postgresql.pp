# Class govuk_ci::agent::postgresql
#
# Installs and configures PostgreSQL server
#
# === Parameters
#
# [*mapit_role_password*]
#  The password for the mapit role.
#
# [*email_alert_api_role_password*]
#  The password for the email-alert-api role.
#
class govuk_ci::agent::postgresql (
  $mapit_role_password = undef,
  $email_alert_api_role_password = undef,
) {
  contain ::govuk_postgresql::mirror
  include ::govuk_postgresql::server::standalone
  include ::postgresql::server::contrib
  include ::postgresql::server::postgis # Required to load the PostGIS extension for mapit
  include ::postgresql::lib::devel

  validate_slength($mapit_role_password, 20, 3)
  validate_slength($email_alert_api_role_password, 20, 3)

  postgresql::server::role { 'jenkins':
    password_hash => postgresql_password('jenkins', 'jenkins'),
    createdb      => true,
  }

  # The mapit role needs to be a superuser in order to load the PostGIS extension for the test database.
  postgresql::server::role { 'mapit':
    superuser     => true,
    password_hash => postgresql_password('mapit', $mapit_role_password);
  }

  # The emai-alert-api role needs to be superuser in order to load the uuid-ossp extension for the test databsase.
  postgresql::server::role { 'email-alert-api':
    superuser     => true,
    password_hash => postgresql_password('email-alert-api', $email_alert_api_role_password);
  }

}
