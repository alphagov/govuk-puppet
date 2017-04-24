# == Class govuk::apps::router_api::enable_running_in_draft_mode
#
# Enables running router-api to serve content pages from the draft content store
#
# === Parameters
#
# [*port*]
#   The port that draft-router-api listens on.
#   Default: 3135
#
# [*mongodb_name*]
#   The Mongo database to be used.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*router_nodes*]
#   Array of hostname:port pairs for the router instances.  These will be used
#   when reloading routes in the router.
#
# [*vhost*]
#   Virtual host to be used by the application.
#   Default: draft-router-api
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::router_api::enable_running_in_draft_mode(
  $port = '3135',
  $mongodb_name,
  $mongodb_nodes,
  $router_nodes,
  $vhost = 'draft-router-api',
  $secret_key_base = undef,
) {
  $app_name = 'draft-router-api'

  validate_array($router_nodes)

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    vhost              => $vhost,
    repo_name          => 'router-api',
  }

  Govuk::App::Envvar {
    app            => $app_name,
  }

  if $secret_key_base != undef {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base,
    }
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
  }

  if $router_nodes != [] {
    govuk::app::envvar { "${title}-ROUTER_NODES":
      varname => 'ROUTER_NODES',
      value   => join($router_nodes, ','),
    }
  }
}
