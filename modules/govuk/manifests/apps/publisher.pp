# == Class: govuk::apps::publisher
#
# Set up the publisher app
#
# === Parameters
#
# [*port*]
#   The port which the app runs on.
#   Default: 3000
#
# [*enable_procfile_worker*]
#   Boolean, whether the procfile worker should be enabled
#   Default: true
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*need_api_bearer_token*]
#   The bearer token to use when communicating with Need API.
#   Default: undef
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*redis_host*]
#   Redis host for Sidekiq.
#   Default: undef
#
# [*redis_port*]
#   Redis port for Sidekiq.
#   Default: undef
#
class govuk::apps::publisher(
    $port = '3000',
    $enable_procfile_worker = true,
    $publishing_api_bearer_token = undef,
    $need_api_bearer_token = undef,
    $secret_key_base = undef,
    $mongodb_name = undef,
    $mongodb_nodes = undef,
    $redis_host = undef,
    $redis_port = undef,
  ) {

  govuk::app { 'publisher':
    app_type            => 'rack',
    port                => $port,
    vhost_ssl_only      => true,
    health_check_path   => '/healthcheck',
    expose_health_check => false,
    json_health_check   => true,
    log_format_is_json  => true,
    asset_pipeline      => true,
    deny_framing        => true,
    nginx_extra_config  => '
    proxy_set_header X-Sendfile-Type X-Accel-Redirect;
    proxy_set_header X-Accel-Mapping /var/apps/publisher/reports/=/raw/;

    # /raw/(.*) is the path mapping sent from the rails application to
    # nginx and is immediately picked up. /raw/(.*) is not available
    # publicly as it is an internal path mapping.
    location ~ /raw/(.*) {
      internal;
      alias /var/apps/publisher/reports/$1;
    }',
  }

  file { '/usr/local/bin/local_authority_import_check':
    ensure  => present,
    mode    => '0755',
    content => template('govuk/local_authority_import_check.erb'),
  }

  file { ['/data/uploads/publisher', '/data/uploads/publisher/reports']:
    ensure => directory,
    mode   => '0775',
    owner  => 'assets',
    group  => 'assets',
  }

  govuk::procfile::worker {'publisher':
    enable_service => $enable_procfile_worker,
  }

  if $mongodb_nodes != undef {
    govuk::app::envvar::mongodb_uri { 'publisher':
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }
  }

  govuk::app::envvar::redis { 'publisher':
    host => $redis_host,
    port => $redis_port,
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      app     => 'publisher',
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-NEED_API_BEARER_TOKEN":
      app     => 'publisher',
      varname => 'NEED_API_BEARER_TOKEN',
      value   => $need_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
      app     => 'publisher',
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
  }
}
