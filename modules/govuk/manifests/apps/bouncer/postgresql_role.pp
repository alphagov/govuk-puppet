# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::bouncer::postgresql_role (
  $password = '',
  $rds = undef,
  ){
  $bouncer_role = 'bouncer'
  $db           = 'transition_production'

  postgresql::server::role { $bouncer_role:
    password_hash => postgresql_password($bouncer_role, $password),
    rds           => $rds,
  }

  postgresql::server::database_grant { "${bouncer_role} can connect to ${db}":
    privilege => 'CONNECT',
    db        => $db,
    role      => $bouncer_role,
    require   => [Postgresql::Server::Role[$bouncer_role], Class['govuk::apps::transition::postgresql_db']],
  }

  postgresql::server::grant { "${bouncer_role} can SELECT from all tables in ${db}":
    privilege   => 'SELECT',
    object_type => 'ALL TABLES IN SCHEMA',
    db          => $db,
    role        => $bouncer_role,
  }
}
