# == Class: Govuk_containers::Apps::Release
#
# Runs the release app.
#
class govuk_containers::apps::release (
  $image = 'govuk/release',
  $port = '3036',
  $envvars = [],
  $healthcheck_path = '/',
) {
  validate_array($envvars)

  govuk_containers::service { 'release':
    image            => $image,
    image_tag        => 'master',
    port             => $port,
    envvars          => $envvars,
    healthcheck_path => $healthcheck_path,
  }

  # errored since removing SSL stuff, need to investigate
  #govuk_containers::balancermember { 'release':
  #  port => $port,
  #}

}
