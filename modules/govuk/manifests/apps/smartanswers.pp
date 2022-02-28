# == Class: govuk::apps::smartanswers
#
# Configures Smart Answers application
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: 'smartanswers'
#
# [*port*]
#   The port that Smart Answers is served on.
#
# [*expose_govspeak*]
#   A boolean value indicating if govspeak format should be made
#   available alongside other formats (e.g. html, json)
#   Default: false
#
# [*show_draft_flows*]
#   A boolean value indicating if the draft flows of smart answers will be
#   shown in an environment
#   Default: false
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*link_checker_api_bearer_token*]
#   The bearer token to use when communicating with Link Checker API.
#   Default: undef
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*unicorn_worker_processes*]
#   The number of unicorn workers to run for an instance of this app
#
# [*zendesk_client_password*]
#   Password for connection to GDS zendesk client.
#
# [*zendesk_client_username*]
#   Username for connection to GDS zendesk client.
#
class govuk::apps::smartanswers(
  $vhost = 'smartanswers',
  $port,
  $expose_govspeak = false,
  $show_draft_flows = false,
  $sentry_dsn = undef,
  $publishing_api_bearer_token = undef,
  $link_checker_api_bearer_token = undef,
  $secret_key_base = undef,
  $unicorn_worker_processes = undef,
  $zendesk_client_password = undef,
  $zendesk_client_username = undef,
) {
  Govuk::App::Envvar {
    app => 'smartanswers',
  }

  if $expose_govspeak {
    govuk::app::envvar {
      "${title}-EXPOSE_GOVSPEAK":
        varname => 'EXPOSE_GOVSPEAK',
        value   => '1';
    }
  }

  if $show_draft_flows {
    govuk::app::envvar {
      "${title}-SHOW_DRAFT_FLOWS":
        varname => 'SHOW_DRAFT_FLOWS',
        value   => '1';
    }
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-LINK_CHECKER_API_BEARER_TOKEN":
      varname => 'LINK_CHECKER_API_BEARER_TOKEN',
      value   => $link_checker_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    "${title}-ZENDESK_CLIENT_PASSWORD":
      varname => 'ZENDESK_CLIENT_PASSWORD',
      value   => $zendesk_client_password;
    "${title}-ZENDESK_CLIENT_USERNAME":
      varname => 'ZENDESK_CLIENT_USERNAME',
      value   => $zendesk_client_username;
  }

  govuk::app { 'smartanswers':
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    log_format_is_json         => true,
    asset_pipeline             => true,
    asset_pipeline_prefixes    => ['assets/smartanswers'],
    vhost                      => $vhost,
    alert_5xx_warning_rate     => 0.001,
    alert_5xx_critical_rate    => 0.005,
    repo_name                  => 'smart-answers',
    unicorn_worker_processes   => $unicorn_worker_processes,
  }
}
