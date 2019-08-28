# == Define: govuk_postgresql::db
#
# A wrapper to setup Postgres databases in a standard way with sensible
# defaults.
#
# The title of the resource can be a valid database name, however if it
# is not valid as a database name, you should pass the $database param.
#
# === Parameters
#
# [*user*]
# The name of the user who will have access to this database
#
# [*password*]
# The password (in plaintext) for this user. It will be wrapped in a
# call to postgresql_password to enable it to be passed in to the
# postgresql::server::db type.
#
# [*database*]
# An optional name for this database. It will default to the resource title.
# Default: $title
#
# [*owner*]
# An optional owner for this database. It will default to $user, however this
# differs from postgresql::server::db which has a default of 'postgres'
# Default: $user
#
# [*encoding*]
# An optional database encoding.
# Default: UTF8
#
# [*extensions*]
# An optional array of Postgresql Extensions to load for this database.
# Default: []
#
# [*allow_auth_from_backend*]
# Whether to create a pg_hba.conf rule to allow this user to authenticate for
# this database from the backend network using its password.
# Default: false
#
# [*backend_ip_range*]
# Network range for Backend.
#
# [*allow_auth_from_lb*]
# Whether to create a pg_hba.conf rule to allow this user to authenticate for
# this database from the load balancer using its password.
# Default: false
#
# [*lb_ip_range*]
# Network range for the load balancer.
#
# [*ssl_only*]
# Whether to configure the pg_hba.conf rules to only respond to clients who
# connect over SSL. If it is false it will allow either.
# Default: false
#
define govuk_postgresql::db (
    $user,
    $password,
    $database                = undef,
    $owner                   = undef,
    $encoding                = 'UTF8',
    $extensions              = [],
    $allow_auth_from_backend = false,
    $backend_ip_range        = undef,
    $allow_auth_from_lb      = false,
    $lb_ip_range             = undef,
    $ssl_only                = false,
    $rds                     = false,
    $rds_root_user           = 'aws_db_admin',
) {

    if ($database == undef) {
        $db_name = $title
    } else {
        $db_name = $database
    }
    if ($owner == undef) {
        $db_owner = $user
    } else {
        $db_owner = $owner
    }
    $password_hash = postgresql_password($user, $password)

    if $ssl_only {
      $hba_type = 'hostssl'
    } else {
      $hba_type = 'host'
    }

    if ! defined(Postgresql::Server::Role[$user]) {
        @postgresql::server::role { $user:
            password_hash => $password_hash,
            tag           => 'govuk_postgresql::server::not_slave',
            rds           => $rds,
        }
    }

    if $rds {
      if ! defined(Govuk_postgresql::Rds_sql[$user]) {
        @govuk_postgresql::rds_sql { $user:
          rds_root_user => $rds_root_user,
          tag           => 'govuk_postgresql::server::not_slave',
          before        => Postgresql::Server::Db[$db_name],
          require       => Postgresql::Server::Role[$user],
        }
      }
    }

    # We do not want to include the entire govuk_postgresql::server wrapper,
    # but require the upstream postgresql::server class to be present
    if $::aws_migration {
      Postgresql::Server::Db {
        require => [Class['postgresql::server'], Postgresql::Server::Role[$user]],
      }
    } else {
      Postgresql::Server::Db {
        require => [Class['govuk_postgresql::server'], Postgresql::Server::Role[$user]],
      }
    }

    @postgresql::server::db {$db_name:
        encoding => $encoding,
        owner    => $db_owner,
        password => $password_hash,
        user     => $user,
        tag      => 'govuk_postgresql::server::not_slave',
    }

    validate_array($extensions)

    if ! $rds {
      if (!empty($extensions)) {
          $temp_extensions = prefix($extensions,"${db_name}:")
          @govuk_postgresql::extension { $temp_extensions:
            tag  => 'govuk_postgresql::server::not_slave',
          }
      }

      if $allow_auth_from_backend {
          postgresql::server::pg_hba_rule { "Allow access for ${user} role to ${db_name} database from backend network":
            type        => $hba_type,
            database    => $db_name,
            user        => $user,
            address     => $backend_ip_range,
            auth_method => 'md5',
          }
      }

    if ! $rds {
      collectd::plugin::postgresql_db{$db_name:}
      govuk_postgresql::monitoring::db{$db_name:}
    }
  } else {
    if (!empty($extensions)) {
      # this only checks the first extension which is sufficient for 
      # ckan_pycsw_production as its only got 1 extension
      if ! defined(Postgresql::Server::Extension[$extensions[0]]) {
        postgresql::server::extension { $extensions:
          ensure   => present,
          database => $db_name,
        }
      }
    }
  }
}
