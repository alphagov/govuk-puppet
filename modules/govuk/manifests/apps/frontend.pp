# == Class: govuk::apps::frontend
#
# Application to serve mainstream formats, the homepage, and search.
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: 'frontend'
#
# [*port*]
#   The port that the app is served on.
#
# [*vhost_protected*]
#   Should this vhost be protected with HTTP Basic auth?
#   Default: undef
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
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run
#   Default: undef
#
# [*govuk_notify_api_key*]
#   API key for integration with GOV.UK Notify for sending emails
#
# [*govuk_notify_template_id*]
#   Template ID for GOV.UK Notify
#
# [*plek_account_manager_uri*]
#   Path to the GOV.UK Account Manager
#
class govuk::apps::frontend(
  $vhost = 'frontend',
  $port,
  $vhost_protected = false,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $sentry_dsn = undef,
  $secret_key_base = undef,
  $unicorn_worker_processes = undef,
  $govuk_notify_api_key = undef,
  $govuk_notify_template_id = undef,
  $plek_account_manager_uri = undef,
) {
  $app_name = 'frontend'

  govuk::app { $app_name:
    app_type                 => 'rack',
    port                     => $port,
    sentry_dsn               => $sentry_dsn,
    vhost_protected          => $vhost_protected,
    health_check_path        => '/',
    log_format_is_json       => true,
    asset_pipeline           => true,
    asset_pipeline_prefixes  => ['assets/frontend'],
    vhost                    => $vhost,
    unicorn_worker_processes => $unicorn_worker_processes,
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-GOVUK_NOTIFY_API_KEY":
        varname => 'GOVUK_NOTIFY_API_KEY',
        value   => $govuk_notify_api_key;
    "${title}-GOVUK_NOTIFY_TEMPLATE_ID":
        varname => 'GOVUK_NOTIFY_TEMPLATE_ID',
        value   => $govuk_notify_template_id;
    "${title}-PLEK-ACCOUNT-MANAGER-URI":
        varname => 'PLEK_SERVICE_ACCOUNT_MANAGER_URI',
        value   => $plek_account_manager_uri;
  }

  if $secret_key_base != undef {
    govuk::app::envvar {
      "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
    }
  }
}
