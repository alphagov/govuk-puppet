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
#   Default: 'content_store_production'
#
class govuk::apps::content_store(
  $port = 3068,
  $mongodb_nodes,
  $mongodb_name = 'content_store_production',
) {
  govuk::app { 'content-store':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  validate_array($mongodb_nodes)

  if $mongodb_nodes != [] {
    $mongodb_nodes_string = join($mongodb_nodes, ',')
    govuk::app::envvar { "${title}-MONGODB_URI":
      app     => 'content-store',
      varname => 'MONGODB_URI',
      value   => "mongodb://${mongodb_nodes_string}/${mongodb_name}",
    }
  }
}
