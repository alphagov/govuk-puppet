# == Class: govuk::apps::organisations_publisher
#
# Organisations Publisher exists to create and manage organisations,
# people and roles.
#
# Read more: https://github.com/alphagov/organisations-publisher
#
# === Parameters
#
# [*port*]
#   What port should the app run on?
#   Default: 3218
#
# [*enabled*]
#   Should the application be enabled? Set in hiera data for each
#   environment.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#
# [*db_port*]
#   The port of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_allow_prepared_statements*]
#   The ?prepared_statements= parameter to use in the DATABASE_URL.
#   Default: undef
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::organisations_publisher(
  $port = '3218',
  $enabled = false,
  $publishing_api_bearer_token = undef,
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $db_hostname = undef,
  $db_username = 'organisations_publisher',
  $db_password = undef,
  $db_port = undef,
  $db_allow_prepared_statements = undef,
  $db_name = 'organisations-publisher_production',
  $oauth_id = '',
  $oauth_secret = '',
  $enable_procfile_worker = true,
  $redis_host = undef,
  $redis_port = undef,
) {
  $app_name = 'organisations-publisher'

  if $enabled {
    include govuk_postgresql::client #installs libpq-dev package needed for pg gem

    govuk::app { $app_name:
      app_type           => 'rack',
      port               => $port,
      sentry_dsn         => $sentry_dsn,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
      asset_pipeline     => true,
      deny_framing       => true,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    if $secret_key_base {
      govuk::app::envvar { "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
      }
    }

    govuk::app::envvar {
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
    }

    if $::govuk_node_class !~ /^development$/ {
      govuk::app::envvar::database_url { $app_name:
        type                      => 'postgresql',
        username                  => $db_username,
        password                  => $db_password,
        host                      => $db_hostname,
        port                      => $db_port,
        allow_prepared_statements => $db_allow_prepared_statements,
        database                  => $db_name,
      }
    }

    govuk::procfile::worker { $app_name:
      enable_service => $enable_procfile_worker,
    }
  }
}
