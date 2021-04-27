# == Class: govuk::apps::short_url_manager
#
# Publishing tool to request, approve and create short URL redirects.
#
# === Parameters
#
# [*ensure*]
#   Allow govuk app to be removed.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*instance_name*]
#   Environment specific name used when sending emails.
#   Default: undef
#
# [*mongodb_name*]
#   The mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#   Default: undef
#
# [*mongodb_username*]
#   The username to use when logging to the MongoDB database,
#   only needed if the app uses documentdb rather than mongodb
#
# [*mongodb_password*]
#   The password to use when logging to the MongoDB database
#   only needed if the app uses documentdb rather than mongodb
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#   Default: undef
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#   Default: undef
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*port*]
#   The port that publishing API is served on.
#
# [*redis_host*]
#   Redis host for sidekiq.
#
# [*redis_port*]
#   Redis port for sidekiq.
#   Default: 6379
#
# [*secret_key_base*]
#   Used to set the app ENV var SECRET_KEY_BASE which is used to configure
#   rails 4.x signed cookie mechanism. If unset the app will be unable to
#   start.
#   Default: undef
#
# [*govuk_notify_api_key*]
#   The API key used to send email via GOV.UK Notify.
#
# [*govuk_notify_template_id*]
#   The template ID used to send email via GOV.UK Notify.
#
# [*enable_procfile_worker*]
#   Whether to enable the procfile worker
#   Default: true
#
class govuk::apps::short_url_manager(
  $ensure = 'present',
  $sentry_dsn = undef,
  $instance_name = undef,
  $mongodb_name = undef,
  $mongodb_nodes = undef,
  $mongodb_username = '',
  $mongodb_password = '',
  $oauth_id = undef,
  $oauth_secret = undef,
  $publishing_api_bearer_token = undef,
  $port,
  $redis_host = undef,
  $redis_port = '6379',
  $secret_key_base = undef,
  $govuk_notify_api_key = undef,
  $govuk_notify_template_id = undef,
  $enable_procfile_worker = true,
) {

  $app_name = 'short-url-manager'

  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  govuk::app { $app_name:
    ensure                     => $ensure,
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    vhost_ssl_only             => true,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    log_format_is_json         => true,
  }

  govuk::procfile::worker { $app_name:
    ensure         => $ensure,
    enable_service => $enable_procfile_worker,
  }

  unless $ensure == 'absent' {
    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar {
      "${title}-GDS_SSO_OAUTH_ID":
        varname => 'GDS_SSO_OAUTH_ID',
        value   => $oauth_id;
      "${title}-GDS_SSO_OAUTH_SECRET":
        varname => 'GDS_SSO_OAUTH_SECRET',
        value   => $oauth_secret;
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
      "${title}-GOVUK_NOTIFY_API_KEY":
        varname => 'GOVUK_NOTIFY_API_KEY',
        value   => $govuk_notify_api_key;
      "${title}-GOVUK_NOTIFY_TEMPLATE_ID":
        varname => 'GOVUK_NOTIFY_TEMPLATE_ID',
        value   => $govuk_notify_template_id;
    }

    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
      username => $mongodb_username,
      password => $mongodb_password,
    }

    govuk::app::envvar::redis { $app_name:
      host => $redis_host,
      port => $redis_port,
    }

    if $secret_key_base != undef {
      govuk::app::envvar { "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base,
      }
    }

    if $instance_name != undef {
      govuk::app::envvar { "${title}-INSTANCE_NAME":
        varname => 'INSTANCE_NAME',
        value   => $instance_name,
      }
    }
  }
}
