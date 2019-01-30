# == Define: nginx::config::vhost::app_default
#
# Creates the default nginx vhost file
#
# === Parameters
#
# [*app_hostname*]
#   The "Host" value that the app expects in the HTML header request.
#
# [*app_port*]
#   The network port on which the app is listening.
#
# [*app_healthcheck_url*]
#   The URL from which the app serves the health check.
#   Default: "/healthcheck"
#
# [*default_healthcheck_url*]
#   The default URL that nginx expects the health check requests to have.
#   Default: "/_healthcheck"
#
define nginx::config::vhost::app_default(
  $app_hostname,
  $app_port,
  $app_healthcheck_url = '/healthcheck',
  $default_healthcheck_url = '/_healthcheck',
) {

  nginx::config::site { 'default':
    content => template('nginx/app-default-vhost.conf'),
  }

}
