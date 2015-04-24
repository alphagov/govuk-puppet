# == Class: govuk::apps::screenshot_as_a_service
#
# Screenshot as a service is a frontend application
# for the Performance Platform.
#
# === Parameters
#
# [*enabled*]
#   Should the app exist?
#
# [*port*]
#   What port should the app run on?
#
#
class govuk::apps::screenshot_as_a_service (
  $enabled = false,
  $port = 3060,
) {

  if $enabled {
    govuk::app { 'screenshot-as-a-service':
      app_type          => 'bare',
      command           => '/usr/bin/node app',
      port              => $port,
      vhost_ssl_only    => true,
      health_check_path => '/usage.html',
    }

    package { ['libcairo2-dev', 'libjpeg8-dev', 'libpango1.0-dev', 'libgif-dev']:
      ensure => 'latest',
    }

    package { 'phantomjs':
      ensure => '1.9.7-0~ppa1',
    }
  }
}
