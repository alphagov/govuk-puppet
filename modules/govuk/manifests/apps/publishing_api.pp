# == Class: govuk::apps::publishing_api
#
# An application to route requests between multiple content-store
# endpoints based on whether they're live or in other states.
#
class govuk::apps::publishing_api(
  $enabled = false,
  $port = 3093
) {
  if $enabled {
    govuk::app { 'publishing-api':
      app_type           => 'rack',
      port               => $port,
      vhost_ssl_only     => true,
      vhost_aliases      => ['publishing-api-test'],
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }
  }
}
