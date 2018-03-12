# == Class: govuk::apps::hmrc_manuals_api
#
# An API to allow HMRC to publish tax manuals to GOV.UK.
# Read more: https://github.com/alphagov/hmrc-manuals-api
#
# === Parameters
#
# [*port*]
#   The port that hmrc-manuals-api is served on.
#   Default: 3071
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
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
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
class govuk::apps::hmrc_manuals_api(
  $port = '3071',
  $sentry_dsn = undef,
  $allow_unknown_hmrc_manual_slugs = false,
  $oauth_id = undef,
  $oauth_secret = undef,
  $publish_topics = true,
  $publishing_api_bearer_token = undef,
) {

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
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token,
  }

  govuk::app { 'hmrc-manuals-api':
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }
}
