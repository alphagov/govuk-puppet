# == Class govuk::apps::content_store
#
# The central storage of published content on GOV.UK
#
# === Parameters
#
# [*port*]
#   The port the app will listen on.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_name*]
#   The mongo database to be used. Overriden in development
#   to be 'content_store_development'.
#
# [*vhost*]
#   Virtual host for this application.
#
# [*default_ttl*]
#   The default cache timeout in seconds.
#
# [*disable_rabbitmq_publishing*]
#   Whether to disable publishing updates to RabbitMQ.  When set, content-store
#   will continue to accept updates, they just won't be broadcase on the
#   rabbitmq exchange.
#   Default: false
#
class govuk::apps::content_store(
  $port = 3068,
  $mongodb_nodes,
  $mongodb_name,
  $vhost,
  $default_ttl = '1800',
  $disable_rabbitmq_publishing = false,
) {
  govuk::app { 'content-store':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    vhost              => $vhost,
  }

  validate_array($mongodb_nodes)

  Govuk::App::Envvar {
    app => 'content-store',
  }

  if $mongodb_nodes != [] {
    $mongodb_nodes_string = join($mongodb_nodes, ',')
    govuk::app::envvar { "${title}-MONGODB_URI":
      varname => 'MONGODB_URI',
      value   => "mongodb://${mongodb_nodes_string}/${mongodb_name}",
    }
  }

  govuk::app::envvar { "${title}-DEFAULT_TTL":
      varname => 'DEFAULT_TTL',
      value   => $default_ttl,
  }

  if $disable_rabbitmq_publishing {
    govuk::app::envvar { "${title}-DISABLE_QUEUE_PUBLISHER":
      varname => 'DISABLE_QUEUE_PUBLISHER',
      value   => '1',
    }
  }
}
