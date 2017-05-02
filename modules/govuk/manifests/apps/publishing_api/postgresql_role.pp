# == Class: govuk::apps::publishing_api::postgresql_role
#
# Creates a `migration_checker` role in publishing-api PostgreSQL database
# with READ ONLY privileges
class govuk::apps::publishing_api::postgresql_role ( $password = '' ) {
  $role = 'migration_checker'
  $db   = 'publishing_api_production'

  postgresql::server::role { $role:
    password_hash => postgresql_password($role, $password),
  }

  # Allows SELECT from any column, or the specific columns listed,
  # of the specified table and also allows the use of COPY
  postgresql::server::database_grant { "${role} can query ${db}":
    privilege => 'SELECT',
    db        => $db,
    role      => $role,
    require   => [Postgresql::Server::Role[$role],
  }
}
