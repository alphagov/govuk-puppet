# == Class: govuk::apps::spotlight
#
# Spotlight is a frontend application for the Performance Platform.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*port*]
#   What port should the app run on?
#
class govuk::apps::spotlight (
  $enabled = false,
  $port = 3057,
) {

  if $enabled {
    govuk::app { 'spotlight':
      app_type          => 'bare',
      command           => '/usr/bin/node app/server',
      port              => $port,
      vhost_ssl_only    => true,
      health_check_path => '/_status',
    }
  }
}
