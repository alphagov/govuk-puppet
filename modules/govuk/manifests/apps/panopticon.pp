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
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
class govuk::apps::panopticon(
  $port = '3003',
  $rabbitmq_hosts = ['localhost'],
  $rabbitmq_user = 'panopticon',
  $rabbitmq_password = 'panopticon',
  $enable_procfile_worker = true,
  $publishing_api_bearer_token = undef,
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

  govuk::app::envvar { "${title}-PUBLISHING_API_BEARER_TOKEN":
    varname => 'PUBLISHING_API_BEARER_TOKEN',
    value   => $publishing_api_bearer_token,
  }

  govuk::app::envvar::rabbitmq { 'panopticon':
    hosts    => $rabbitmq_hosts,
    user     => $rabbitmq_user,
    password => $rabbitmq_password,
  }

  govuk::procfile::worker { 'panopticon':
    enable_service => $enable_procfile_worker,
  }

  govuk::logstream { 'panopticon-org-import-json-log':
    logfile => '/var/apps/panopticon/log/organisation_import.json.log',
    fields  => {'application' => 'panopticon'},
    json    => true,
  }
}
