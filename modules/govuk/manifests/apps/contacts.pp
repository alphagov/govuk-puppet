# == Class: govuk::apps::contacts
#
# Admin app to publish contact information.
#
# === Parameters
#
# [*enabled*]
#   Whether the app is enabled.
#   Default: true
#
# [*enable_admin_routes]
#   Enables /admin route for the app running on backend servers only
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: undef
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
# [*vhost*]
#   Virtual host for this application.
#   Default: contacts-frontend-old
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*port*]
#   The port that the app is served on.
#   Default: 3051
#
# [*vhost_protected*]
#   Should this vhost be protected with HTTP Basic auth?
#   Default: undef
#
# [*extra_aliases*]
#   Other vhosts on which the app is served.
#   Default: []
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*redis_host*]
#   Redis host for Distributed Lock.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Distributed Lock.
#   Default: undef
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#   Default: undef
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#   Default: undef
#
# [*db_password*]
#   The password for the database.
#   Default: undef
#
class govuk::apps::contacts(
  $db_name = 'contacts_production',
  $db_hostname = undef,
  $db_username = undef,
  $db_password = undef,
  $enabled = true,
  $enable_admin_routes = undef,
  $errbit_api_key = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $vhost = 'contacts-frontend-old',
  $port = '3051',
  $vhost_protected = undef,
  $extra_aliases = [],
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
) {
  $app_name = 'contacts'

  validate_array($extra_aliases)

  if $enabled {
    govuk::app { 'contacts':
      app_type              => 'rack',
      vhost                 => $vhost,
      port                  => $port,
      health_check_path     => '/healthcheck',
      vhost_protected       => $vhost_protected,
      asset_pipeline        => true,
      asset_pipeline_prefix => 'contacts-assets',
      vhost_aliases         => $extra_aliases,
      nginx_extra_config    => '
        # Don\'t ask for basic auth on SSO API pages so we can sync
        # permissions.
        location /auth/gds {
          auth_basic off;
          try_files $uri @app;
        }
      ',
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    govuk::app::envvar {
      "${title}-ENABLE_ADMIN_ROUTES":
      varname => 'ENABLE_ADMIN_ROUTES',
      value   => $enable_admin_routes;
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        app     => $app_name,
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
      "${title}-OAUTH_ID":
        varname => 'OAUTH_ID',
        value   => $oauth_id;
      "${title}-OAUTH_SECRET":
        varname => 'OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    }

    if $::govuk_node_class != 'development' {
      govuk::app::envvar::database_url { $app_name:
        type     => 'mysql2',
        username => $db_username,
        password => $db_password,
        host     => $db_hostname,
        database => $db_name,
      }
    }
  }
}
