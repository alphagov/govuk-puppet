# == Class: Govuk_containers::Apps::Router
#
# Runs the router app.
#
class govuk_containers::apps::router (
  $image = 'govuk/router',
  $port = '3054',
  $api_port = '3055',
  $envvars = [],
  $healthcheck_path = '/healthcheck',
) {
  validate_array($envvars)

  @ufw::allow { 'allow-router-reload-from-all':
    port => $api_port,
  }

  govuk_containers::app { 'router':
    image            => $image,
    port             => $port,
    envvars          => $envvars,
    healthcheck_path => $healthcheck_path,
  }

}
