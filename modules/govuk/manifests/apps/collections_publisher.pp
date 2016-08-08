# == Class: govuk::apps::collections_publisher
#
# Publishes certain collection and tag formats requiring
# complicated UIs.
#
# === Parameters
#
# [*panopticon_bearer_token*]
#   The bearer token to use when communicating with Panopticon.
#   Default: example
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3078
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*oauth_id*]
#   Sets the OAuth ID used by gds-sso
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key used by gds-sso
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::collections_publisher(
  $panopticon_bearer_token = 'example',
  $port = '3078',
  $secret_key_base = undef,
  $errbit_api_key = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $enable_procfile_worker = true,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
) {

  govuk::app { 'collections-publisher':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  Govuk::App::Envvar {
    app =>  'collections-publisher',
  }

  govuk::app::envvar::redis { 'collections-publisher':
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
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PANOPTICON_BEARER_TOKEN":
      varname => 'PANOPTICON_BEARER_TOKEN',
      value   => $panopticon_bearer_token;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
  }

  govuk::procfile::worker {'collections-publisher':
    enable_service => $enable_procfile_worker,
  }
}
