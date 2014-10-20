# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::bouncer::postgresql_role ( $password = '' ){
  $bouncer_role = 'bouncer'
  $db           = 'transition_production'

  postgresql::server::role { $bouncer_role:
    password_hash => postgresql_password($bouncer_role, $password),
  }

  postgresql::server::database_grant { "${bouncer_role} can connect to ${db}":
    privilege => 'CONNECT',
    db        => $db,
    role      => $bouncer_role,
    require   => [Postgresql::Server::Role[$bouncer_role], Class['govuk::apps::transition::postgresql_db']],
  }

  exec { "${bouncer_role} will be able to SELECT from all yet-to-be-created tables in ${db}":
    command => "psql -d ${db} -c 'ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO ${bouncer_role}'",
    unless  => "psql -d ${db} -c '\\ddp' | grep -q 'bouncer=r/'",
    user    => 'postgres',
    require => Postgresql::Server::Database_grant["${bouncer_role} can connect to ${db}"],
  }

  # FIXME: We will be able to do this via the postgres puppet module if this
  # PR is merged: https://github.com/puppetlabs/puppetlabs-postgresql/pull/405
  exec { "${bouncer_role} can SELECT from all existing tables in ${db}":
    command => "psql -d ${db} -c 'GRANT SELECT ON ALL TABLES IN SCHEMA public TO ${bouncer_role}'",
    # This only tests that the privilege is set for at least one table, not all of them:
    unless  => "psql -d ${db} -c '\\dp' | grep -q 'bouncer=r/'",
    user    => 'postgres',
    require => Exec["${bouncer_role} will be able to SELECT from all yet-to-be-created tables in ${db}"],
  }
}
