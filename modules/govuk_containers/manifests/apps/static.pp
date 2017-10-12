# == Class: Govuk_containers::Apps::Static
#
# Runs the static app in a Swarm Cluster.
#
class govuk_containers::apps::static (
  $port = '3013',
  $envvars = {},
  $healthcheck_path = '/',
) {
  validate_hash($envvars)

  @govuk_containers::cluster::app { 'static':
    port             => $port,
    envvars          => $envvars,
    healthcheck_path => $healthcheck_path,
    tag              => 'frontend',
  }
}
