# == Class: Govuk_containers::Apps::Release
#
# Runs the release app in a Swarm Cluster.
#
class govuk_containers::apps::release (
  $port = '3036',
  $envvars = {},
  $healthcheck_path = '/',
) {
  validate_hash($envvars)

  @govuk_containers::cluster::app { 'release':
    port             => $port,
    envvars          => $envvars,
    healthcheck_path => $healthcheck_path,
    tag              => 'backend',
  }

}
