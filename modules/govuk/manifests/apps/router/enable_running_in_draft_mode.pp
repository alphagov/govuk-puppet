# == Class govuk::apps::router::enable_running_in_draft_mode
#
# Enables running router to serve content pages from the draft content store
#
class govuk::apps::router::enable_running_in_draft_mode(
  $port = '3133',
  $api_port = 3134,
  $api_healthcheck = '/healthcheck',
  $error_log = '/var/log/router/errors.json.log',
  $mongodb_name,
  $mongodb_nodes,

  # These are only overridden in the dev VM to allow draft-origin.dev.gov.uk to go through the router.
  $enable_nginx_vhost = false,
  $vhost_aliases = [],
) {
  $app_name = 'draft-router'

  Govuk::App::Envvar {
    app => 'draft-router',
  }

  govuk::app::envvar {
    "${title}-ROUTER_PUBADDR":
      value   => "localhost:${port}",
      varname => 'ROUTER_PUBADDR';
    "${title}-ROUTER_APIADDR":
      value   => ":${api_port}",
      varname => 'ROUTER_APIADDR';
    "${title}-ROUTER_MONGO_DB":
      value   => $mongodb_name,
      varname => 'ROUTER_MONGO_DB';
    "${title}-ROUTER_MONGO_URL":
      value   => join($mongodb_nodes, ','),
      varname => 'ROUTER_MONGO_URL';
    "${title}-ROUTER_ERROR_LOG":
      value   => $error_log,
      varname => 'ROUTER_ERROR_LOG';
    "${title}-ROUTER_BACKEND_HEADER_TIMEOUT":
      value   => '20s',
      varname => 'ROUTER_BACKEND_HEADER_TIMEOUT';
  }

  govuk::app { 'draft-router':
    app_type           => 'bare',
    command            => './router',
    port               => $port,
    enable_nginx_vhost => $enable_nginx_vhost,
    vhost_aliases      => $vhost_aliases,
  }
}
