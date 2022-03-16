# == Class: govuk::apps::manuals_frontend
#
# Front-end app for the manuals format.
#
# === Parameters
#
# [*vhost*]
#   Virtual host used by the application.
#   Default: 'manuals-frontend'
#
# [*port*]
#   The port that the app is served on.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::manuals_frontend(
  $vhost = 'manuals-frontend',
  $port,
  $publishing_api_bearer_token = undef,
  $sentry_dsn = undef,
  $secret_key_base = undef,
) {
  govuk::app { 'manuals-frontend':
    ensure                     => 'absent',
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    asset_pipeline             => true,
    asset_pipeline_prefixes    => ['assets/manuals-frontend'],
    vhost                      => $vhost,
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
  }
}
