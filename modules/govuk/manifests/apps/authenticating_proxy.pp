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
# [*enabled*]
#   Feature flag to allow the app to be deployed to an environment.
#   Default: false
#
# [*govuk_upstream_uri*]
#   The URI of the upstream service that we proxy to.
#   Default: undef
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*errbit_environment_name*]
#   Errbit environment name, one of preview, staging or production
#   Default: ''
#
class govuk::apps::authenticating_proxy(
  $port = 3107,
  $enabled = false,
  $errbit_api_key = undef,
  $errbit_environment_name = undef,
  $govuk_upstream_uri = undef,
) {
  if $enabled {
    govuk::app { 'authenticating-proxy':
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }

    if $govuk_upstream_uri {
      govuk::app::envvar {
        "${title}-GOVUK_UPSTREAM_URI":
            app     => 'authenticating-proxy',
            varname => 'GOVUK_UPSTREAM_URI',
            value   => $govuk_upstream_uri;
      }
    }

    if $errbit_api_key {
      govuk::app::envvar {
      "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
      "${title}-ERRBIT_ENVIRONMENT_NAME":
        varname => 'ERRBIT_ENVIRONMENT_NAME',
        value   => $errbit_environment_name;
      }
    }
  }
}
