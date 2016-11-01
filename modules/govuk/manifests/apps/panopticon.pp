# == Class: govuk::apps::panopticon
#
# Legacy app that holds content.
# Read more: https://github.com/alphagov/panopticon
#
# === Parameters
#
# [*port*]
#   The port that panopticon API is served on.
#   Default: 3003
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   Default: panopticon
#
# [*rabbitmq_password*]
#   RabbitMQ password.
#   Default: panopticon
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::panopticon(
  $port = '3003',
  $enable_procfile_worker = true,
  $errbit_api_key = undef,
  $mongodb_name = undef,
  $mongodb_nodes = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publishing_api_bearer_token = undef,
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'panopticon',
  $rabbitmq_password = 'panopticon',
  $secret_key_base = undef,
) {
  govuk::app { 'panopticon':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  Govuk::App::Envvar {
    app => 'panopticon',
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
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
  }

  if $mongodb_nodes != undef {
    govuk::app::envvar::mongodb_uri { 'panopticon':
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }
  }

  govuk::app::envvar::rabbitmq { 'panopticon':
    hosts    => $rabbitmq_hosts,
    user     => $rabbitmq_user,
    password => $rabbitmq_password,
  }

  govuk::procfile::worker { 'panopticon':
    enable_service => $enable_procfile_worker,
  }

  govuk_logging::logstream { 'panopticon-org-import-json-log':
    logfile => '/var/apps/panopticon/log/organisation_import.json.log',
    fields  => {'application' => 'panopticon'},
    json    => true,
  }
}
