# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::content_performance_manager::data_scientist_role (
  $password = '',
  $rds = undef,
  ){
  $data_scientist_role = 'data_scientist'
  $db           = 'content_performance_manager_production'

  postgresql::server::role { $data_scientist_role:
    password_hash => postgresql_password($data_scientist_role, $password),
    rds           => $rds,
  }

  postgresql::server::database_grant { "${data_scientist_role} can connect to ${db}":
    privilege => 'CONNECT',
    db        => $db,
    role      => $data_scientist_role,
    require   => [Postgresql::Server::Role[$data_scientist_role], Class['govuk::apps::content_performance_manager::db']],
  }

  postgresql::server::grant { "${data_scientist_role} can SELECT from all tables in ${db}":
    privilege   => 'SELECT',
    object_type => 'ALL TABLES IN SCHEMA',
    db          => $db,
    role        => $data_scientist_role,
  }
}
