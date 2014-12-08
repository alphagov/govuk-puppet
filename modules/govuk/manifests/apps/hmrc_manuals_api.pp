# == Class: govuk::apps::hmrc_manuals_api
#
# An API to allow HMRC to publish tax manuals to GOV.UK.
# Read more: https://github.com/alphagov/hmrc-manuals-api
#
# === Parameters
#
# [*port*]
#   The port that courts-api is served on.
#   Default: 3071
#
# [*enabled*]
#   Feature flag to allow the app to be deployed to an environment.
#   Default: false
#
class govuk::apps::hmrc_manuals_api(
  $port = 3071,
  $enabled = false
) {
  if $enabled {
    govuk::app { 'hmrc-manuals-api':
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }
  }
}
