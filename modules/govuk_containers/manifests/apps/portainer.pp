# == Class: Govuk_containers::Apps::Portainer
#
# Runs Portainer app in the Swarm Cluster.
# https://portainer.io/
#
class govuk_containers::apps::portainer (
  $port = '9000',
  $healthcheck_path = '/',
) {
  @govuk_containers::cluster::app { 'portainer':
    port             => $port,
    healthcheck_path => $healthcheck_path,
    tag              => ['frontend', 'backend'],
  }
}
