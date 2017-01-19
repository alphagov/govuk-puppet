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
# [*mongodb_name*]
#   The name of the MongoDB database to use
#
# [*port*]
#   The port that it is served on.
#   Default: 3107
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*govuk_upstream_uri*]
#   The URI of the upstream service that we proxy to.
#   Default: undef
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
# [*jwt_auth_secret*]
#   The secret used to decode JWT authentication tokens. This value needs to be
#   shared with the publishing apps that generate the encoded tokens.
#
class govuk::apps::authenticating_proxy(
  $mongodb_nodes,
  $mongodb_name = 'authenticating_proxy_production',
  $port = '3107',
  $errbit_api_key = undef,
  $govuk_upstream_uri = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
  $jwt_auth_secret = undef,
) {
  $app_name = 'authenticating-proxy'

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
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

  if $jwt_auth_secret != undef {
    govuk::app::envvar { "${title}-JWT_AUTH_SECRET":
      app     => $app_name,
      varname => 'JWT_AUTH_SECRET',
      value   => $jwt_auth_secret,
    }
  }

  $app_domain = hiera('app_domain')
  govuk::app::envvar {
    "${title}-PLEK_SERVICE_SIGNON_URI":
      app     => $app_name,
      varname => 'PLEK_SERVICE_SIGNON_URI',
      value   => "https://signon.${app_domain}";
    "${title}-PLEK_SERVICE_ERRBIT_URI":
      app     => $app_name,
      varname => 'PLEK_SERVICE_ERRBIT_URI',
      value   => "https://errbit.${app_domain}";
  }
}
