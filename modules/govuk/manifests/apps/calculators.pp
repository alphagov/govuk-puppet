# == Class: govuk::apps::calculators
#
# App details at: https://github.com/alphagov/calculators
#
# === Parameters
#
# [*port*]
#   The port that it is served on.
#   Default: 3047
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::calculators(
  $port = '3047',
  $sentry_dsn = undef,
  $publishing_api_bearer_token = undef,
  $secret_key_base = undef,
) {
  govuk::app { 'calculators':
    app_type              => 'rack',
    port                  => $port,
    sentry_dsn            => $sentry_dsn,
    health_check_path     => '/child-benefit-tax-calculator/main',
    log_format_is_json    => true,
    asset_pipeline        => true,
    asset_pipeline_prefix => 'calculators',
  }

  Govuk::App::Envvar {
    app => 'calculators',
  }

  govuk::app::envvar {
    "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
    "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base;
  }

  $app_domain = hiera('app_domain')

  if ($::aws_environment == 'staging') or ($::aws_environment == 'production') {
    govuk::app::envvar::plek_uri_overrides { 'calculators':
      app_domain => $app_domain,
    }
  }
}
