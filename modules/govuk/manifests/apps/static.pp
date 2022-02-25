# govuk::apps::static
#
# The GOV.UK static application -- serves static assets and templates
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: static
#
# [*port*]
#   The port that the app is served on.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*draft_environment*]
#   A boolean to indicate whether we are in the draft environment.
#   Sets the environment variable DRAFT_ENVIRONMENT to 'true' if
#   true, does not set it if false.
#   Default: false
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#   Default: undef
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*asset_host*]
#   The URL that will be used as a prefix for statics assets.
#   Default: undef
#
# [*ga_universal_id*]
#   The Google Analytics ID.
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
# [*unicorn_worker_processes*]
#   The number of unicorn worker processes to run.
#   Default: undef
#
# # [*google_tag_manager_id*]
#   The ID for the Google Tag Manager account
#
# [*google_tag_manager_preview*]
#   Allows a tag to be previewed in the Google Tag Manager interface
#
# [*google_tag_manager_auth*]
#   The identifier of an environment for Google Tag Manager
#
# [*govuk_personalisation_manage_uri*]
#   URI for the account management page.
#
# [*govuk_personalisation_security_uri*]
#   URI for the account security page.
#
# [*govuk_personalisation_feedback_uri*]
#   URI for the account feedback page.
#
class govuk::apps::static(
  $vhost = 'static',
  $port,
  $sentry_dsn = undef,
  $draft_environment = false,
  $secret_key_base = undef,
  $publishing_api_bearer_token = undef,
  $asset_host = undef,
  $ga_universal_id = undef,
  $redis_host = undef,
  $redis_port = undef,
  $unicorn_worker_processes = undef,
  $google_tag_manager_id = undef,
  $google_tag_manager_preview = undef,
  $google_tag_manager_auth = undef,
  $govuk_personalisation_manage_uri = undef,
  $govuk_personalisation_security_uri = undef,
  $govuk_personalisation_feedback_uri = undef,
) {
  $enable_ssl = hiera('nginx_enable_ssl', true)
  $app_name = 'static'

  govuk::app { $app_name:
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    log_format_is_json         => true,
    nginx_extra_config         => template('govuk/static_extra_nginx_config.conf.erb'),
    asset_pipeline             => true,
    asset_pipeline_prefixes    => ['assets/static'],
    vhost                      => $vhost,
    unicorn_worker_processes   => $unicorn_worker_processes,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  if $draft_environment {
    govuk::app::envvar {
      "${title}-DRAFT_ENVIRONMENT":
        varname => 'DRAFT_ENVIRONMENT',
        value   => '1';
    }
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
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
    "${title}-ASSET_HOST":
      varname => 'ASSET_HOST',
      value   => $asset_host;
    "${title}-GOOGLE_TAG_MANAGER_ID":
        varname => 'GOOGLE_TAG_MANAGER_ID',
        value   => $google_tag_manager_id;
    "${title}-GOOGLE_TAG_MANAGER_PREVIEW":
        varname => 'GOOGLE_TAG_MANAGER_PREVIEW',
        value   => $google_tag_manager_preview;
    "${title}-GOOGLE_TAG_MANAGER_AUTH":
        varname => 'GOOGLE_TAG_MANAGER_AUTH',
        value   => $google_tag_manager_auth;
    "${title}-GOVUK-PERSONALISATION-MANAGE-URI":
      varname => 'GOVUK_PERSONALISATION_MANAGE_URI',
      value   => $govuk_personalisation_manage_uri;
    "${title}-GOVUK-PERSONALISATION-SECURITY-URI":
      varname => 'GOVUK_PERSONALISATION_SECURITY_URI',
      value   => $govuk_personalisation_security_uri;
    "${title}-GOVUK-PERSONALISATION-FEEDBACK-URI":
      varname => 'GOVUK_PERSONALISATION_FEEDBACK_URI',
      value   => $govuk_personalisation_feedback_uri;
  }

  if $ga_universal_id != undef {
    govuk::app::envvar { "${title}-GA_UNIVERSAL_ID":
      varname => 'GA_UNIVERSAL_ID',
      value   => $ga_universal_id,
    }
  }
}
