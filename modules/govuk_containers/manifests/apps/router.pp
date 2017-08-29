# == Class: Govuk_containers::Apps::Router
#
# Runs the router app.
#
class govuk_containers::apps::router (
  $image = 'govuk/router',
  $port = '3054',
  $envvars = [],
  $healthcheck_path = '/healthcheck',
) {
  validate_array($envvars)

  govuk_containers::app { 'router':
    image            => $image,
    port             => $port,
    envvars          => $envvars,
    healthcheck_path => $healthcheck_path,
  }

}
