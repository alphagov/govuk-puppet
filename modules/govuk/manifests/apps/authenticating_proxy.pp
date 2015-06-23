# == Class: govuk::apps::authenticating_proxy
#
# Provides authenticated access to the draft stack.
#
# Read more: https://github.com/alphagov/authenticating-proxy
#
# === Parameters
#
# [*mongodb_nodes*]
#   Array of mongo cluster hostnames for the application to connect to.
#
# [*port*]
#   The port that it is served on.
#   Default: 3107
#
# [*govuk_upstream_uri*]
#   The URI of the upstream service that we proxy to.
#   Default: undef
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*errbit_uri*]
#   Used to set the environment variable override for the location of the
#   errbit service.
#   Default: undef
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
# [*signon_uri*]
#   Used to set the environment variable override for the location of the
#   signon service.
#   Default: undef
#
class govuk::apps::authenticating_proxy(
  $mongodb_nodes,
  $port = 3107,
  $errbit_api_key = undef,
  $errbit_uri = undef,
  $govuk_upstream_uri = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $signon_uri = undef,
) {
  $app_name = 'authenticating-proxy'

  validate_array($mongodb_nodes)

  if $mongodb_nodes != [] {
    $mongodb_nodes_string = join($mongodb_nodes, ',')
    govuk::app::envvar { "${title}-MONGODB_URI":
      app     => $app_name,
      varname => 'MONGODB_URI',
      value   => "mongodb://${mongodb_nodes_string}/authenticating_proxy_production",
    }
  }

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  if $govuk_upstream_uri {
    govuk::app::envvar {
      "${title}-GOVUK_UPSTREAM_URI":
          app     => $app_name,
          varname => 'GOVUK_UPSTREAM_URI',
          value   => $govuk_upstream_uri;
    }
  }

  if $errbit_api_key {
    govuk::app::envvar { "${title}-ERRBIT_API_KEY":
      app     => $app_name,
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key,
    }
  }

  if $errbit_uri != undef {
    govuk::app::envvar { "${title}-PLEK_SERVICE_ERRBIT_URI":
      app     => $app_name,
      varname => 'PLEK_SERVICE_ERRBIT_URI',
      value   => $errbit_uri,
    }
  }

  if $signon_uri != undef {
    govuk::app::envvar { "${title}-PLEK_SERVICE_SIGNON_URI":
      app     => $app_name,
      varname => 'PLEK_SERVICE_SIGNON_URI',
      value   => $signon_uri,
    }
  }

  if $oauth_id != undef {
    govuk::app::envvar { "${title}-OAUTH_ID":
      app     => $app_name,
      varname => 'OAUTH_ID',
      value   => $oauth_id,
    }
  }

  if $oauth_secret != undef {
    govuk::app::envvar { "${title}-OAUTH_SECRET":
      app     => $app_name,
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret,
    }
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      app     => $app_name,
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }
}
