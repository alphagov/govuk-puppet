# == Class: Govuk_containers::Apps::Static
#
# Runs the static app.
#
class govuk_containers::apps::static (
  $image = 'govuk/static',
  $port = '3013',
  $envvars = [],
  $healthcheck_path = '/',
) {
  validate_array($envvars)

  govuk_containers::service { 'static':
    image            => $image,
    image_tag        => 'master',
    port             => $port,
    envvars          => $envvars,
    healthcheck_path => $healthcheck_path,
  }
}
