# == Class: govuk::apps::hmrc_manuals_api
#
# An API to allow HMRC to publish tax manuals to GOV.UK.
# Read more: https://github.com/alphagov/hmrc-manuals-api
#
# === Parameters
#
# [*ensure*]
#   Allow govuk app to be removed.
#
# [*port*]
#   The port that hmrc-manuals-api is served on.
#
# [*allow_unknown_hmrc_manual_slugs*]
#   Feature flag to allow publishing manuals (and their sections) with
#   non-whitelisted manual slugs.
#   Default: false
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*oauth_id*]
#   The OAuth ID used by GDS-SSO to identify the app to GOV.UK Signon
#   Default: undef
#
# [*oauth_secret*]
#   The OAuth secret used by GDS-SSO to authenticate the app to GOV.UK Signon
#   Default: undef
#
# [*publish_topics*]
#   Feature flag to allow publishing of manual topics to the Publishing
#   API and Rummager.
#   Default: true
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*override_search_location*]
#   Alternative hostname to use for Plek("search") and Plek("rummager")
#
class govuk::apps::hmrc_manuals_api(
  $ensure = 'present',
  $port,
  $sentry_dsn = undef,
  $allow_unknown_hmrc_manual_slugs = false,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publish_topics = true,
  $publishing_api_bearer_token = undef,
  $override_search_location = undef,
) {

  validate_re($ensure, '^(present|absent)$', 'Invalid ensure value')

  govuk::app { 'hmrc-manuals-api':
    ensure                     => $ensure,
    app_type                   => 'rack',
    port                       => $port,
    sentry_dsn                 => $sentry_dsn,
    vhost_ssl_only             => true,
    health_check_path          => '/healthcheck',
    has_liveness_health_check  => true,
    has_readiness_health_check => true,
    log_format_is_json         => true,
    override_search_location   => $override_search_location,
  }

  unless $ensure == 'absent' {
    Govuk::App::Envvar {
      app => 'hmrc-manuals-api',
    }

    if $allow_unknown_hmrc_manual_slugs {
      govuk::app::envvar {
        "${title}-ALLOW_UNKNOWN_HMRC_MANUAL_SLUGS":
          varname => 'ALLOW_UNKNOWN_HMRC_MANUAL_SLUGS',
          value   => '1';
      }
    }

    if $publish_topics {
      govuk::app::envvar {
        "${title}-PUBLISH_TOPICS":
          varname => 'PUBLISH_TOPICS',
          value   => '1';
      }
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
        value   => $publishing_api_bearer_token,
    }

  }
}
