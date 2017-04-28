# == Class: Govuk_containers::Apps::Release
#
# Runs the release app.
#
class govuk_containers::apps::release (
  $image = 'govuk/release',
  $port = '3036',
  $envvars = [],
) {
  validate_array($envvars)

  govuk_containers::app { 'release':
    image   => $image,
    port    => $port,
    envvars => $envvars,
  }

  govuk_containers::balancermember { 'release':
    port => $port,
  }

}
