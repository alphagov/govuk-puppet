# == Class: govuk::apps::authenticating_proxy
#
# Provides authenticated access to the draft stack.
#
# Read more: https://github.com/alphagov/authenticating-proxy
#
# === Parameters
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
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
class govuk::apps::authenticating_proxy(
  $port = 3107,
  $errbit_api_key = undef,
  $govuk_upstream_uri = undef,
  $secret_key_base = undef,
) {
  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }
  $app_name = 'authenticating-proxy'

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

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      app     => $app_name,
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }
}
