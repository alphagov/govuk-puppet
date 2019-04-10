# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::router (
  $port = '3054',
  $api_port = 3055,
  $api_healthcheck = '/healthcheck',
  $error_log = '/var/log/router/errors.json.log',
  $mongodb_name,
  $mongodb_nodes,

  # These are only overridden in the dev VM to allow www.dev.gov.uk to go through the router.
  $enable_nginx_vhost = false,
  $vhost_aliases = [],
) {
  @ufw::allow { 'allow-router-reload-from-all':
    port => $api_port,
  }

  Govuk::App::Envvar {
    app => 'router',
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

  govuk::app { 'router':
    app_type               => 'bare',
    command                => './router',
    port                   => $port,
    enable_nginx_vhost     => $enable_nginx_vhost,
    vhost_aliases          => $vhost_aliases,
    nagios_memory_warning  => 900,
    nagios_memory_critical => 1100,
  }

  # We can't pass `health_check_path` to `govuk::app` because it has the
  # reverse proxy port, not the API port. Changing the port would lose us
  # TCP connection stats.
  @@icinga::check { "check_app_router_up_on_${::hostname}":
    check_command       => "check_nrpe!check_app_up!${api_port} ${api_healthcheck}",
    service_description => 'router app healthcheck',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(app-healthcheck-failed),
  }

  govuk_logging::logstream { 'router-error-json-log':
    logfile => $error_log,
    tags    => ['error'],
    fields  => {'application' => 'router'},
  }

  @filebeat::prospector { 'router-error-json-log':
    paths  => [$error_log],
    tags   => ['error'],
    fields => {'application' => 'router'},
    json   => {'add_error_key' => true},
  }

}
