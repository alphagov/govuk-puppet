# == Class: govuk::apps::event_store
#
# Event store is a Go application that receives POST requests representing
# events, for example Content-Security-Policy reports.
#
# === Parameters
#
# [*enabled*]
#   Whether the application should be enabled. Can be specified for each
#   environment using deployment hieradata.
#
# [*mongodb_servers*]
#   An array of machines running as a MongoDB cluster.
#
# [*port*]
#   The port the app should run on.
#
class govuk::apps::event_store (
  $enabled = false,
  $mongodb_servers = [],
  $port = '3097',
) {
  if $enabled {
    Govuk::App::Envvar {
      app => 'event-store',
    }

    govuk::app::envvar {
      'EVENT_STORE_MONGO_NODES':
        value => join($mongodb_servers, ',');
    }

    govuk::app { 'event-store':
      ensure             => 'absent',
      app_type           => 'bare',
      command            => './event-store',
      health_check_path  => '/healthcheck',
      port               => $port,
      enable_nginx_vhost => true,
    }

  }
}
