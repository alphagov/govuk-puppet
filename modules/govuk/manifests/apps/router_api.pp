# == Class: govuk::apps::router_api
#
# Configure the router-api app on a node.
#
# === Parameters
#
# [*port*]
#   The port that router-api listens on.
#   Default: 3056
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
#   Default: router-api
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*router_nodes_class*]
#   The class or classes of machine that run router that require reloading
#   after app deployment. Acceptable formats are "cache" or "cache,draft_cache"
#
# [*oauth_id*]
#   The OAuth ID used to identify the app to GOV.UK Signon (in govuk-secrets)
#
# [*oauth_secret*]
#   The OAuth secret used to authenticate the app to GOV.UK Signon (in govuk-secrets)
#

class govuk::apps::router_api(
  $port = '3056',
  $mongodb_name,
  $mongodb_nodes,
  $router_nodes = [],
  $vhost = 'router-api',
  $secret_key_base = undef,
  $sentry_dsn = undef,
  $router_nodes_class = undef,
  $oauth_id = undef,
  $oauth_secret = undef,
) {
  $app_name = 'router-api'

  validate_array($router_nodes)

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    vhost              => $vhost,
  }

  Govuk::App::Envvar {
    app            => $app_name,
  }

  govuk::app::envvar {
    "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
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

  # Set up a cron job which outputs the current nodes for a specific machine class.
  # The file can then be read in by router-api to publish routes for those nodes.
  if $::aws_migration {
    if $router_nodes_class {
      $router_port = '3055'
      $router_nodes_file = '/etc/router_nodes'

      cron::crondotdee { 'update-router-nodes':
        command => "/usr/local/bin/govuk_node_list -c ${router_nodes_class} | sed 's/$/:${router_port}/g' > ${router_nodes_file}",
        hour    => '*',
        minute  => '*/5',
        mailto  => '""',
      }

      govuk::app::envvar { "${title}-ROUTER_NODES_FILE":
        varname => 'ROUTER_NODES_FILE',
        value   => $router_nodes_file,
      }
    }
  }
}
