# Class govuk_ci::agent::postgresql
#
# Installs and configures PostgreSQL server
#
# === Parameters
#
# [*email_alert_api_role_password*]
#  The password for the email-alert-api role.
#
class govuk_ci::agent::postgresql (
  $email_alert_api_role_password = 'email-alert-api',
) {
  # Docker instances of PostgreSQL server versions that are installed in
  # parallel with the Ubuntu Trusty version
  include ::govuk_docker
  ::govuk_containers::ci_postgresql { 'ci-postgresql-13':
    version => '13',
    port    => 54313,
  }

  contain ::govuk_postgresql::mirror
  include ::govuk_postgresql::server::standalone
  include ::postgresql::server::contrib
  include ::postgresql::lib::devel

  validate_slength($email_alert_api_role_password, 20, 3)

  postgresql::server::role { 'jenkins':
    password_hash => postgresql_password('jenkins', 'jenkins'),
    createdb      => true,
  }

  # The emai-alert-api role needs to be superuser in order to load the uuid-ossp extension for the test databsase.
  postgresql::server::role { 'email-alert-api':
    superuser     => true,
    password_hash => postgresql_password('email-alert-api', $email_alert_api_role_password);
  }

}
