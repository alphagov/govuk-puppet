# == Class: govuk::apps::need_api
#
# An application to maintain all the user needs for GOV.UK.  This presents an
# API for managing them.  See maslow for the UI that consumes this.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3093
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*elasticsearch_hosts*]
#   A string of comma-separated list of Elasticsearch hosts,
#   for example: es-host-1:9200,es-host-2:9200
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*mongodb_nodes*]
#   An array of MongoDB instance hostnames
#
# [*mongodb_name*]
#   The name of the MongoDB database to use
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*redis_host*]
#   The hostname of a Redis instance to connect to
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::need_api(
  $port = '3052',
  $publishing_api_bearer_token = undef,
  $errbit_api_key = '',
  $sentry_dsn = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $secret_key_base = undef,
) {
  govuk::app { 'need-api':
    ensure             => 'absent',
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    repo_name          => 'govuk_need_api',
  }

  govuk_logging::logstream { 'need-api-org-import-json-log':
    logfile => '/var/apps/need-api/log/organisation_import.json.log',
    fields  => {'application' => 'need-api'},
    json    => true,
  }

  Govuk::App::Envvar {
    app => 'need-api',
  }
  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      ensure  => absent,
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-ELASTICSEARCH_HOSTS":
      ensure  => absent,
      varname => 'ELASTICSEARCH_HOSTS',
      value   => $elasticsearch_hosts;
    "${title}-ERRBIT_API_KEY":
      ensure  => absent,
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-OAUTH_ID":
      ensure  => absent,
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      ensure  => absent,
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-REDIS_HOST":
      ensure  => absent,
      varname => 'REDIS_HOST',
      value   => $redis_host;
  }

  validate_array($mongodb_nodes)
  if $mongodb_nodes != [] {
    $mongodb_nodes_string = join($mongodb_nodes, ',')
    govuk::app::envvar { "${title}-MONGODB_URI":
      ensure  => absent,
      varname => 'MONGODB_URI',
      value   => "mongodb://${mongodb_nodes_string}/${mongodb_name}",
    }
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      ensure  => absent,
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }
}
