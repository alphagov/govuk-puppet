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
  $mapit_role_password = 'mapit',
  $email_alert_api_role_password = 'email-alert-api',
) {
  # Docker instances of PostgreSQL server versions that are installed in
  # parallel with the Ubuntu Trusty version
  include ::govuk_docker
  ::govuk_containers::ci_postgresql { 'ci-postgresql-13':
    version => '13',
    port    => 54313,
  }
  ::govuk_containers::ci_postgis { 'ci-postgis-14':
    version         => '14',
    postgis_version => '3.2',
    port            => 54414,
  }

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
