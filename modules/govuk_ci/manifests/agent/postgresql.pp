# Class govuk_ci::agent::postgresql
#
# Installs and configures PostgreSQL server
#
# === Parameters
#
# [*mapit_role_password*]
#
class govuk_ci::agent::postgresql (
  $mapit_role_password = undef,
) {
  contain ::govuk_postgresql::mirror
  include ::govuk_postgresql::server::standalone
  include ::postgresql::server::contrib
  include ::postgresql::server::postgis # Required to load the PostGIS extension for mapit
  include ::postgresql::lib::devel

  postgresql::server::role { 'jenkins':
    password_hash => postgresql_password('jenkins', 'jenkins'),
    createdb      => true,
  }

  # The mapit role needs to be a superuser in order to load the PostGIS
  # extension for the test database.
  postgresql::server::role { 'mapit':
    superuser     => true,
    password_hash => postgresql_password('mapit', $mapit_role_password);
  }

}