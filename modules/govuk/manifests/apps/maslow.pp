# The GOV.UK Maslow application -- handles user needs submissions
#
# === Parameters
#
# [*port*]
#   The port the app will listen on.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_name*]
#   The mongo database to be used. Overriden in development
#   to be 'content_store_development'.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*oauth_id*]
#   The application's OAuth ID from Signon
#
# [*oauth_secret*]
#   The application's OAuth Secret from Signon
#
class govuk::apps::maslow(
  $port = '3053',
  $mongodb_nodes,
  $mongodb_name,
  $publishing_api_bearer_token = undef,
  $secret_key_base = undef,
  $errbit_api_key = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
) {
  $app_name = 'maslow'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-ERRBIT_API_KEY":
        varname => 'ERRBIT_API_KEY',
        value   => $errbit_api_key;
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
  }
}
