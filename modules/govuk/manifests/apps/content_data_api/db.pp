# == Class: govuk::apps::content_data_api::db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
class govuk::apps::content_data_api::db (
  $password = undef,
) {
  govuk_postgresql::db { 'content_performance_manager_production':
    user                => 'content_performance_manager',
    password            => $password,
    rds                 => true,
    extensions          => ['plpgsql'],
    enable_in_pgbouncer => false,
  }

  @@monitoring::checks::rds_config { 'content-data-api-postgresql-primary':
    memory_warning   => 2,
    memory_critical  => 1,
    storage_warning  => 50,
    storage_critical => 25,
  }

  @@monitoring::checks::rds_config { 'content-data-api-postgresql-standby':
    memory_warning   => 2,
    memory_critical  => 1,
    storage_warning  => 50,
    storage_critical => 25,
  }
}
