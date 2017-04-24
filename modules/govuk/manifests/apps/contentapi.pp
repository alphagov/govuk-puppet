# == Class: govuk::apps::contentapi
#
# Configure the contentapi application - https://github.com/alphagov/govuk_content_api
#
# === Parameters
#
# [*port*]
#   The port that the app is served on.
#   Default: 3022
#
# [*asset_manager_bearer_token*]
#   The bearer token to use when communicating with Asset Manager.
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*memcached_entitystore_url*]
#   Memcached url for entitystore
#
# [*memcached_metastore_url*]
#   Memcached url for metastore
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
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
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::contentapi (
  $port = '3022',
  $asset_manager_bearer_token = undef,
  $errbit_api_key = undef,
  $memcached_entitystore_url = undef,
  $memcached_metastore_url = undef,
  $mongodb_name = undef,
  $mongodb_nodes = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publishing_api_bearer_token = undef,
  $secret_key_base = undef,
) {

  govuk::app { 'contentapi':
    app_type               => 'rack',
    port                   => $port,
    health_check_path      => '/vat-rates.json',
    log_format_is_json     => true,
    nginx_extra_config     => 'proxy_set_header API-PREFIX $http_api_prefix;',
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
    repo_name              => 'govuk_content_api',
  }

  if $mongodb_nodes != undef {
    govuk::app::envvar::mongodb_uri { 'contentapi':
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }
  }

  Govuk::App::Envvar {
    app => 'contentapi',
  }

  govuk::app::envvar {
    "${title}-ASSET_MANAGER_BEARER_TOKEN":
      varname => 'ASSET_MANAGER_BEARER_TOKEN',
      value   => $asset_manager_bearer_token;
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-MEMCACHED_ENTITYSTORE":
      varname => 'MEMCACHED_ENTITYSTORE',
      value   => $memcached_entitystore_url;
    "${title}-MEMCACHED_METASTORE":
      varname => 'MEMCACHED_METASTORE',
      value   => $memcached_metastore_url;
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
}
