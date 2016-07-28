# == Class: govuk::apps::travel_advice_publisher
#
# App to publish travel advice.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3035
#
# [*enable_email_alerts*]
#   Send email alerts via the email-alert-api
#   Default: false
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*redis_host*]
#   Redis host for sidekiq.
#
# [*redis_port*]
#   Redis port for sidekiq.
#   Default: 6379
#
# [*enable_procfile_worker*]
#   Enables the sidekiq background worker.
#   Default: true
#
class govuk::apps::travel_advice_publisher(
  $port = '3035',
  $enable_email_alerts = false,
  $mongodb_name = undef,
  $mongodb_nodes = undef,
  $secret_key_base = undef,
  $publishing_api_bearer_token = undef,
  $redis_host = undef,
  $redis_port = undef,
  $enable_procfile_worker = true,
) {
  $app_name = 'travel-advice-publisher'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  Govuk::App::Envvar {
    app     => $app_name,
  }

  if $mongodb_nodes != undef {
    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }
  }

  govuk::app::envvar::redis { $app_name:
    host => $redis_host,
    port => $redis_port,
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
  }

  validate_bool($enable_email_alerts)
  if ($enable_email_alerts) {
    govuk::app::envvar {
      "${title}-SEND_EMAIL_ALERTS":
        varname => 'SEND_EMAIL_ALERTS',
        value   => '1';
    }
  }

  validate_bool($enable_procfile_worker)
  govuk::procfile::worker { $app_name:
    enable_service => $enable_procfile_worker,
  }
}
