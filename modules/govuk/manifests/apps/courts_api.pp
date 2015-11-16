# == Class: govuk::apps::courts_api
#
# An API to allow MoJ to publish courts and tribunals information to GOV.UK.
# Read more: https://github.com/alphagov/courts-api
#
# === Parameters
#
# [*port*]
#   The port that courts-api is served on.
#   Default: 3092
#
# [*enabled*]
#   Feature flag to allow the app to be deployed to an environment.
#   Default: false
#
class govuk::apps::courts_api(
  $port = '3092',
  $enabled = false
) {
  if $enabled {
    govuk::app { 'courts-api':
      # FIXME: delete this class and remove it from hieradata when this has been deployed
      ensure             => absent,
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }
  }
}
